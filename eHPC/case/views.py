#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, request, jsonify, url_for, current_app
from . import case
from flask_babel import gettext
from flask_login import login_required, current_user
from ..models import Case, CaseCode
from .. import db
import os


@case.route('/')
def index():
    cases = Case.query.all()
    return render_template("case/index.html", cases=cases)


@case.route('/<int:case_id>/', methods=['GET', 'POST'])
def show_case(case_id):
    if request.method == 'GET':
        cur_case = Case.query.filter_by(id=case_id).first_or_404()
        return render_template('case/case_detail.html', case=cur_case)
    elif request.method == 'POST':
        if request.form['type'] == 'case-description':
            case_to_show = Case.query.filter_by(id=request.form['case_id']).first_or_404()
            return jsonify(status='success', description=case_to_show.description)
        elif request.form['type'] == 'version-description':
            case_code = CaseCode.query.filter_by(case_id=request.form['case_id'],
                                                 version_id=request.form['version_id']).first_or_404()

            return jsonify(status='success', description=case_code.description)
        elif request.form['type'] == 'code':
            case_code = CaseCode.query.filter_by(case_id=request.form['case_id'],
                                                 version_id=request.form['version_id']).first_or_404()

            path = os.path.join(current_app.config['RESOURCE_FOLDER'], case_code.code_path)
            with open(os.path.join(path, request.form['file_name']), 'r') as code:
                return jsonify(status='success', code=code.read())


@case.route('/<int:cid>/')
def case_view(cid):
    cur_case = Case.query.filter_by(id=cid).first_or_404()
    return render_template('case/case.html',
                           title=cur_case.name,
                           case=cur_case)
