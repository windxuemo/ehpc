from flask import render_template, request, jsonify, url_for, current_app
from . import case
from flask_babel import gettext
from flask_login import login_required, current_user
from ..models import Case, CaseCode
from .. import db
import os


@case.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'GET':
        all_case = Case.query.all()
        return render_template('case/index.html', cases=all_case)
    elif request.method == 'POST':
        if request.form['type'] == 'case-description':
            case_to_show = Case.query.filter_by(id=request.form['case_id']).first_or_404()
            return jsonify(status='success', description=case_to_show.description)
        elif request.form['type'] == 'code':
            case_code = CaseCode.query.filter_by(case_id=request.form['case_id'],
                                                 version_id=request.form['version_id']).first_or_404()

            path = os.path.join(current_app.config['RESOURCE_FOLDER'], case_code.code_path)
            files = list(os.walk(path))[0][2]
            codes = {}

            for f in files:
                with open(os.path.join(path, f), 'r') as code:
                    codes[f] = code.read()
            return jsonify(status='success', codes=codes)



