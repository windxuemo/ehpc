#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
from flask import render_template, jsonify, request
from flask_login import current_user, login_required
from . import problem
from ..models import Program, Classify, SubmitProblem, Question
from flask_babel import gettext
from ..problem.code_process import c_compile, c_run
from .. import db
from sqlalchemy import or_


@problem.route('/')
def index():
    return render_template('problem/index.html',
                           title=gettext('Practice Platform'))


@problem.route('/program/')
@login_required
def show_program():
    pro = Program.query.all()
    submission = SubmitProblem.query.filter_by(uid=current_user.id).all()
    cnt = {}
    for i in submission:
        cnt[i.pid] = 0
    for i in submission:
        cnt[i.pid] += 1
    return render_template('problem/show_program.html',
                           title=gettext('Program Practice'),
                           problems=pro,
                           count=cnt)


# 新增一个连接到我的提交界面的路由
@problem.route('/program/submits/<int:pid>/')
@login_required
def show_my_submits(pid):
    my_submits = SubmitProblem.query.filter_by(pid=pid, uid=current_user.id).all()
    pro = Program.query.filter_by(id=pid).first_or_404()
    return render_template('problem/show_my_submits.html',
                           title=gettext('My Submit'),
                           program=pro,
                           submits=my_submits)


# 查看某一次提交的代码
@problem.route('/program/submit/<int:sid>/')
@login_required
def view_code(sid):
    cur_submit = SubmitProblem.query.filter_by(id=sid).first_or_404()
    cur_problem = Program.query.filter_by(id=cur_submit.pid).first_or_404()
    return render_template('problem/view_code.html',
                           title=gettext('Program Practice'),
                           problem=cur_problem,
                           language=cur_submit.language,
                           code=cur_submit.code)


@problem.route('/choice/')
def show_choice():
    classifies = Classify.query.all()   # 知识点
    rows = []
    for c in classifies:
        temp = c.questions.filter(or_(Question.type == 0, Question.type == 1, Question.type == 2)).count()
        rows.append([c.name, temp, c.id])

    return render_template('problem/show_choice.html',
                           title=gettext('Choice Practice'),
                           rows=rows)


@problem.route('/program/<int:pid>/')
@login_required
def program_view(pid):
    pro = Program.query.filter_by(id=pid).first_or_404()
    return render_template('problem/program_detail.html',
                           title=pro.title,
                           problem=pro)


@problem.route('/choice/<int:cid>/')
@login_required
def choice_view(cid):
    classify_name = Classify.query.filter_by(id=cid).first_or_404()
    choice_problem = classify_name.questions.filter(or_(Question.type == 0, Question.type == 1, Question.type == 2)).all()

    return render_template('problem/choice_detail.html',
                           classify_id=classify_name.id,
                           title=classify_name.name,
                           choiceProblem=choice_problem)


@problem.route('/<int:pid>/submit/', methods=['POST'])
@login_required
def submit(pid):
    uid = current_user.id
    problem_id = request.form['problem_id']
    source_code = request.form['source_code']
    language = request.form['language']
    submit_problem = SubmitProblem(uid, problem_id, source_code, language)
    db.session.add(submit_problem)
    db.session.commit()

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

