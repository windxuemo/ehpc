#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
# @Last Modified time: 2016-09-19 14:14:25

from flask import Blueprint
article = Blueprint('article', __name__)
from . import views
