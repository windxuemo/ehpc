#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
# @Last Modified time: 2016-09-19 14:28:55
from flask import Blueprint
lab = Blueprint('lab', __name__)
from . import views
