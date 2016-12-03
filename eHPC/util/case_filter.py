from . import filter_blueprint
from ..models import Case, CaseCode
from sqlalchemy import *
from .. import db
import os
from flask import current_app


@filter_blueprint.app_template_filter('get_files_list')
def get_files_list(code_path):
    path = os.path.join(current_app.config['CASE_FOLDER'], code_path)
    print path
    files = list(os.walk(path))[0][2]
    return files
