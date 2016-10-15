#! /usr/bin/env python
# -*- coding: utf-8 -*-
from . import filter_blueprint


@filter_blueprint.app_template_filter('is_admin_user')
def is_admin_user(u):
    if u.is_authenticated and u.permissions == 0:
        return True
    return False


@filter_blueprint.app_template_filter('is_student_user')
def is_student_user(u):
    if u.is_authenticated and u.permissions == 1:
        return True
    return False


@filter_blueprint.app_template_filter('is_teacher_user')
def is_teacher_user(u):
    if u.is_authenticated and u.permissions == 2:
        return True
    return False
