#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import Blueprint
markdown_files = Blueprint('markdown_files', __name__)
from . import views
