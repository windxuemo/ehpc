from . import filter_blueprint
from ..models import Case, CaseVersion, CaseCodeMaterial
from sqlalchemy import *
from .. import db
import os
from flask import current_app


@filter_blueprint.app_template_filter('get_files_list')
def get_files_list(materials):
    files = []
    for m in materials:
        files.append(m.name)
    return files
