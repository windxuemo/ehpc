#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
from flask import redirect, url_for
from functools import wraps
from flask_login import current_user
from ..models import Group, User


# 装饰器, 保证用户已经加入了群组
def user_in_group(func):
    @wraps(func)
    def wrap(gid):
        cur_group = Group.query.filter_by(id=gid).first()
        if current_user in cur_group.members:
            return func(gid)
        else:
            return redirect(url_for('group.group_view', gid=gid))

    return wrap


def user_not_in_group(func):
    @wraps(func)
    def wrap(gid):
        cur_group = Group.query.filter_by(id=gid).first()
        if current_user not in cur_group.members:
            return func(gid)
        else:
            return redirect(url_for('group.group_view', gid=gid))

    return wrap


