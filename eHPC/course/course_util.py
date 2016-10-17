#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
from flask import redirect, url_for
from functools import wraps
from flask_login import current_user
from ..models import Course


# 装饰器, 保证当前用户已经加入了课程
def student_in_course(func):
    @wraps(func)
    def wrap(cid):
        cur_course = Course.query.filter_by(id=cid).first()
        if current_user in cur_course.users:
            return func(cid)
        else:
            return redirect(url_for('course.view', cid=cid))

    return wrap


def student_not_in_course(func):
    @wraps(func)
    def wrap(cid):
        cur_course = Course.query.filter_by(id=cid).first()
        if current_user not in cur_course.users:
            return func(cid)
        else:
            return redirect(url_for('course.view', cid=cid))

    return wrap
