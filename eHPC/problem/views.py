#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
from flask import render_template, jsonify, request, url_for, abort, redirect
from flask_login import current_user, login_required
from . import problem
from ..models import Program, Choice, Classify, choice_classifies
from flask_babel import gettext
from ..problem.code_process import c_compile, c_run
from .. import db

@problem.route('/')
def index():
    return render_template('problem/index.html',
                           title=gettext('Practice Platform'))


@problem.route('/program/')
def show_program():
    pro = Program.query.all()
    return render_template('problem/show_program.html',
                           title=gettext('Program Practice'),
                           problems=pro)


@problem.route('/choice/')
def show_choice():
    classifies = Classify.query.all()
    rows = []
    for c in classifies:
        rows.append([c.name, c.choices.count(), c.id])

    return render_template('problem/show_choice.html',
                           title=gettext('Choice Practice'),
                           rows=rows)


@problem.route('/program/<int:pid>/')
@login_required
def program_view(pid):
    pro = Program.query.filter_by(id=pid).first()
    return render_template('problem/program_detail.html',
                           title=pro.title,
                           problem=pro)


@problem.route('/choice/<int:cid>/')
def choice_view(cid):
    cho = db.session().query(Choice).\
        join(choice_classifies, Choice.id == choice_classifies.columns['choice_id']).\
        filter(choice_classifies.columns['classify_id'] == cid).all()
    return render_template('problem/choice_detail.html',
                           choiceProblem=cho)


@problem.route('/<int:pid>/submit/', methods=['POST'])
@login_required
def submit(pid):
    source_code = request.form['source_code']

    # TODO here.  Get the result.
    is_compile_success = [False]
    compile_out = c_compile(source_code, pid, current_user.id, is_compile_success)
    run_out = "编译失败!\n程序无法运行..."
    if is_compile_success[0]:
        run_out = c_run(pid, current_user.id) or "程序无输出结果"

    result = dict()
    result['status'] = 'success'
    result['problem_id'] = pid
    result['compile_out'] = compile_out
    result['run_out'] = run_out

    return jsonify(**result)
