#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
import subprocess
import os
import urllib2, urllib
import json
import time
import random, string

# 参数设置
base_url = "http://10.127.48.5:8000/api"
login_url = "/auth"
async_url = "/async"
async_wait_time = 5
login_data = {"username": "sysu_dwu_1", "password": "ae0a22c8b3695ce8"}
DEBUG_ASYNC = True
machine_name = "ln3"


def c_compile(source_code, pid, uid, is_success):
    save_src_filename = "code/%s_%s.c" % (str(pid), str(uid))
    save_exe_filename = "code/%s_%s.o" % (str(pid), str(uid))

    with open(save_src_filename, 'w') as src_file:
        src_file.write(source_code)

    commands = "gcc %s -o %s" % (save_src_filename, save_exe_filename)
    p = subprocess.Popen(commands, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()

    is_success[0] = not p.returncode

    if is_success[0]:
        return "编译成功!\n %s" % stderr
    else:
        return "编译失败!\n %s" % stderr


def c_run(pid, uid):
    save_exe_filename = "code/%s_%s.o" % (str(pid), str(uid))
    # 编译通过
    if os.path.isfile(save_exe_filename):
        commands = "./%s" % save_exe_filename
        p = subprocess.Popen(commands, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = p.communicate()
        return stdout
    else:
        return None


# 又要重写TAT
# 参考@JiangLiNSCC的代码
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
            # 都这么做,但是我不是很清楚method具体是什么,为什么可以用lambda表达
            req.get_method = lambda: method

        # 发送接收请求
        try:
            resp = urllib2.urlopen(req)
            self.resp = resp
            rdata = resp.read()
        # rdata = json.loads((rdata).decode('ascii'))
        except urllib2.HTTPError, e:
            rdata = e.fp.read()

        # 保存
        try:
            rdata = json.loads((rdata).decode('ascii'))
            self.data = rdata
            self.status = self.data["status"]
            self.status_code = self.data["status_code"]
            self.output = self.data["output"]
        except ValueError:
            self.data = rdata
            self.status = "unknown"
            self.status_code = resp.getcode()
            self.output = rdata
            if self.status_codce == 200: self.status = "OK"

        # 这里的意思其实是设置了可以异步获取,当卡了的时候等待,死掉的话会保存在那边,再获取
        if self.status_code == 201 and async_get:
            self.async_wait_time = async_wait_time
            time.sleep(1)
            if DEBUG_ASYNC: print "jump to async"
            self.open(async_url + '/' + self.output)

        # 其实就是100continue啦
        if self.status_code == 100 and async_wait and self.async_wait_time > 0:
            time.sleep(1)
            self.async_wait_time = async_wait_time
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
        return self.ret200()

    # POST  /api/command/<machine>
    # 返回保存输出的文件的id
    def run_command(self, command):
        tmpdata = self.open("/command/" + machine_name, data={"command": command})
        if self.ret200():
            if self.data["output"]["retcode"] != 0:
                return tmpdata["output"]["error"]
            else:
                return tmpdata["output"]["output"]
        else:
            return None

    # POST /api/job/<machine>
    def upload_job(self, batchfile):
        pass

    # GET /api/job/<machine>
    def get_job(self):
        pass


if __name__ == '__main__':
    mc = ehpc_client()
    input_filename = "main.cpp"
    output_filename = "a.out"
    path = "/HOME/sysu_dwu_1/coreos"
    test_text = open("main.cpp").read()

    if not mc.login():
        print "login fail."
    if not mc.upload(path, input_filename, test_text):
        print "upload fail."

    compile_command = "bash -c 'cd %s;g++ -o %s %s'" % (path, output_filename, input_filename)
    run_command = "bash -c 'cd %s;./%s'" % (path, output_filename)

    compile_output = mc.run_command(compile_command)
    compile_out = compile_output or "Compile success."

    if compile_output is None:
        compile_out = "Request fail."
        print "Request fail."

    run_output = mc.run_command(run_command)
    run_out = run_output or "No output."

    if run_output is None:
        run_out = "Request error."
        print "Request error."

    print compile_out
    print run_out
