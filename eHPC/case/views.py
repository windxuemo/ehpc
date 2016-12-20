#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, request, jsonify, current_app, render_template_string
from . import case
from flask_babel import gettext
from ..models import Case, CaseVersion
import os


@case.route('/')
def index():
    cases = Case.query.all()
    return render_template("case/index.html",
                           title=gettext('Case List'),
                           cases=cases)


@case.route('/<int:case_id>/', methods=['GET', 'POST'])
def show_case(case_id):
    if request.method == 'GET':
        cur_case = Case.query.filter_by(id=case_id).first_or_404()
        return render_template('case/case_detail.html',
                               title=gettext('Case Display'),
                               case=cur_case)
    elif request.method == 'POST':
        if request.form['type'] == 'case-description':
            case_to_show = Case.query.filter_by(id=request.form['case_id']).first_or_404()
            html = '{{ "' + case_to_show.description + '" }}'
            return jsonify(status='success', description=render_template_string(html))

        elif request.form['type'] == 'version-description':
            case_version = CaseVersion.query.filter_by(id=request.form['auto_increment']).first_or_404()
            html = '{{ "' + case_version.description + '" }}'
            return jsonify(status='success', description=render_template_string(html))

        elif request.form['type'] == 'code':
            case_version = CaseVersion.query.filter_by(id=request.form['auto_increment']).first_or_404()
            path = None
            code_name = None
            for m in case_version.materials:
                if request.form['file_name'] == m.name:
                    path = os.path.join(current_app.config['CASE_FOLDER'], case_version.dir_path, m.uri, m.name)
                    break
            if path is not None:
                try:
                    with open(path, 'r') as code:
                        return jsonify(status='success', code=code.read())
                except IOError:
                    return jsonify(status='fail')
            else:
                return jsonify(status='fail')
