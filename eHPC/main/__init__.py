#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
# @Last Modified time: 2016-09-19 14:29:22

from flask import Blueprint
main = Blueprint('main', __name__)
from . import views

