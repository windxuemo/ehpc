#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
import subprocess
import os


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
