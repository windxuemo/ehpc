#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
# @Last Modified time: 2016-09-19 14:30:07
from flask import Blueprint
api = Blueprint('api', __name__)
from . import views
