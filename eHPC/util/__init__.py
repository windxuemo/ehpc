#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import Blueprint
filter_blueprint = Blueprint('filters', __name__)

from . import course_manage, time_process
