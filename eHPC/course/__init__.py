#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
# @Last Modified time: 2016-09-19 14:29:43
from flask import Blueprint
course = Blueprint('course', __name__)
from . import views
