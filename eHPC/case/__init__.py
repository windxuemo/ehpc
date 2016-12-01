#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import Blueprint
case = Blueprint('case', __name__)
from . import views
