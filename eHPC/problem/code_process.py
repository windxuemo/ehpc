#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
import urllib2, urllib
import json
import time
import re

# 参数设置
base_url = "http://10.127.48.5:8000/api"
login_url = "/auth"
async_url = "/async"
async_first_wait_time = 1
async_wait_time = 5
login_data = {"username": "sysu_dwu_1", "password": "ae0a22c8b3695ce8"}
DEBUG_ASYNC = True
machine_name = "ln3"
input_filename = "mpicc_demo.c"
output_filename = "a.out"
path = "/HOME/sysu_dwu_1/coreos"


# 完成天河2号接口的功能
class ehpc_client:
    def __init__(self, base_url=base_url, headers={}, login_cookie=None, login_data=login_data):
        self.headers = headers
        self.base_url = base_url
        self.login_cookie = login_cookie
        self.login_data = login_data
        self.async_wait_time = async_wait_time

    def open(self, url, data=None, method=None, login=True, async_get=True, async_wait=True, retjson=True):
        url = self.base_url + url

        # data目前只有帐号和密码
        if data:
            try:
                data = urllib.urlencode(data)
            except TypeError:
                pass

            req = urllib2.Request(url, data)
        else:
            req = urllib2.Request(url)

        # 要求登录的话,就要查cookie,没有的话要调用login函数登录
        if login:
            if not self.login_cookie:
                self.login()

            req.add_header("Cookie", self.login_cookie)

        for (k, v) in self.headers:
            req.add_header(k, v)

        if method:
            req.get_method = lambda: method

        # 发送接收请求
        try:
            resp = urllib2.urlopen(req)
            self.resp = resp
            rdata = resp.read()
        # rdata = json.loads((rdata).decode('ascii'))
        except urllib2.HTTPError, e:
            rdata = e.fp.read()

        rdata = (rdata).decode('ascii')
        rdata_reg = re.search('\{.+\}', rdata)
        rdata = rdata if rdata_reg is None else rdata_reg.group()
        # 保存
        try:
            rdata = json.loads(rdata)
            self.data = rdata
            self.status = self.data["status"]
            self.status_code = self.data["status_code"]
            self.output = self.data["output"]
        except ValueError:
            self.data = rdata
            try:
                self.status_code = self.data["status_code"]
                self.status = self.data["status"]
            except Exception as exc:
                print ("exe : ", exc)
                print ("rdata : ", rdata)
                self.status_code = rdata["status_code"]
                self.status = "unknown"
            self.output = self.data
            if self.status_code == 200: self.status = "OK"

        # 这里的意思其实是设置了可以异步获取,当卡了的时候等待,死掉的话会保存在那边,再获取
        if self.status_code == 201 and async_get:
            self.async_wait_time = async_wait_time
            time.sleep(async_first_wait_time)
            if DEBUG_ASYNC: print "jump to async"
            return self.open(async_url + '/' + self.output)

        # 其实就是100continue啦
        if self.status_code == 100 and async_wait and self.async_wait_time > 0:
            time.sleep(1)
            self.async_wait_time -= 1
            if DEBUG_ASYNC: print "async retry"
            self.open(async_url + '/' + self.output)

        if self.async_wait_time <= 0:
            print "Error: async connection time out."
            self.async_wait_time = async_wait_time

        return self.data

    def ret200(self):
        return self.status == "OK" and self.status_code == 200

    def ret403(self):
        return self.status == "ERROR" and self.status_code == 403

    def ret500(self):
        return self.status == "ERROR" and self.status_code == 500

    def retError(self):
        return self.status == "ERROR"

    # POST /api/auth
    def login(self):
        tmpdata = self.open(login_url, data=self.login_data, login=False)
        self.login_cookie = 'newt_sessionid=' + tmpdata["output"]["newt_sessionid"]
        return self.ret200()

    # DELETE /api/auth
    def logout(self):
        tmpdata = self.open("/auth", login=True, method="DELETE")
        return self.ret200()

    # GET /api/file/<machine>/<path>列目录
    # 那边没有给输出,暂时不用
    def get_directory(self, path):
        tmpdata = self.open("/file/" + machine_name + path + '/')
        return self.ret200()

    # GET /api/async/<id>获取
    def get_file(self, file_id):
        tmpdata = self.open(async_url + '/' + file_id)
        if self.ret200():
            return tmpdata["output"]["output"]
        else:
            return None

    # GET /api/file/<machine>/<path>?download=True
    def download(self, path, filename):
        tmpdata = self.open("/file/" + machine_name + path + '/' + filename + "?download=True")
        return self.ret200()

    # PUT /api/file/<machine>/<path>
    def upload(self, path, filename, data):
        tmpdata = self.open("/file/" + machine_name + path + '/' + filename, method="PUT", data=data)
        # print tmpdata
        return self.ret200()

    # POST  /api/command/<machine>
    # 返回保存输出的文件的id
    def run_command(self, command):
        tmpdata = self.open("/command/" + machine_name, data={"command": command})
        # print tmpdata
        if self.ret200() and type(tmpdata) == type({}):
            return tmpdata["output"]["output"]
        elif type(tmpdata) == type({}):
            return tmpdata["output"]["error"]
        else:
            return None

    # POST /api/job/<machine>
    def upload_job(self, batchfile):
        pass

    # GET /api/job/<machine>
    def get_job(self):
        pass

    def ehpc_compile(self, path, input_filename, output_filename, language):
        compile_command = {
            "c++": "g++ -o %s %s" % (output_filename, input_filename),
            "mpicc": "mpicc -o %s %s" % (output_filename, input_filename)
        }

        commands = 'cd %s;%s' % (path, compile_command[language])

        compile_output = self.run_command(commands)
        compile_out = compile_output or "Compile success."

        if compile_output is None:
            compile_out = "Request fail."

        return compile_out

    def ehpc_run(self, output_filename, path, task_number, cpu_number_per_task, node_number, language,
                 partition="free"):

        run_command = {
            "c++": "./%s" % (output_filename),
            "mpicc": "yhrun -n %s -p %s %s" % (task_number, partition, output_filename)
        }
        # print run_command[language]
        commands = 'cd %s;%s' % (path, run_command[language])
        run_output = self.run_command(commands)
        run_out = run_output or "No output."

        if run_output is None:
            run_out = "Request error."

        return run_out


if __name__ == '__main__':
    mc = ehpc_client()
    test_text = open("mpicc_demo.c").read()

    if not mc.login():
        print "login fail."
        exit(-1)
    if not mc.upload(path, input_filename, test_text):
        print "upload fail."
        exit(-1)

    compile_out = mc.ehpc_compile(path, input_filename, output_filename, "mpicc")
    # mc.run_command('cd %s;yhrun -n 4 -p free a.out'%(path))
    run_out = mc.ehpc_run(output_filename, path, "4", "1", "1", "mpicc")
    print compile_out, type(compile_out)
    print run_out, type(run_out)
