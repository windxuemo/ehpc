#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
from flask import render_template, jsonify, request, abort
from flask_login import current_user, login_required
from . import problem
from ..models import Program, Classify, SubmitProblem, Question
from flask_babel import gettext
from ..problem.code_process import ehpc_client
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


@problem.route('/question/')
def show_question():
    classifies = Classify.query.all()   # 知识点
    rows = []
    for c in classifies:
        rows.append([c.name, c.questions.count(), c.id])

    return render_template('problem/show_question.html',
                           rows=rows)


@problem.route('/program/<int:pid>/')
@login_required
def program_view(pid):
    pro = Program.query.filter_by(id=pid).first_or_404()
    return render_template('problem/program_detail.html',
                           title=pro.title,
                           problem=pro)


@problem.route('/question/<question_type>/<int:cid>/')
@login_required
def question_view(cid, question_type):
    classify_name = Classify.query.filter_by(id=cid).first_or_404()

    practices = None;
    if question_type == 'choice':
        practices = classify_name.questions.filter(or_(Question.type == 0,
                                                       Question.type == 1, Question.type == 2)).all()
    elif question_type == 'fill':
        practices = classify_name.questions.filter_by(type=3).all()
    elif question_type == 'judge':
        practices = classify_name.questions.filter_by(type=4).all()
    elif question_type == 'essay':
        practices = classify_name.questions.filter_by(type=5).all()
    else:
        abort(404)

    return render_template('problem/practice_detail.html',
                           classify_id=classify_name.id,
                           title=classify_name.name,
                           practices=practices,
                           q_type=question_type)


@problem.route('/<int:pid>/submit/', methods=['POST'])
@login_required
def submit(pid):
	uid = current_user.id
	problem_id = request.form['problem_id']
	source_code = request.form['source_code']
	compiler = request.form['compiler']
	submit_problem = SubmitProblem(uid, problem_id, source_code, language)
	db.session.add(submit_problem)
	db.session.commit()

	path = "/HOME/sysu_dwu_1/coreos"
	#之后需要改进
	input_filename = "code/%s_%s.c" % (str(pid), str(uid))
	output_filename = "code/%s_%s.o" % (str(pid), str(uid))

	task_number = request.form['task_number']
	#task_number = "4"
	cpu_number_per_task = request.form['cpu_number_per_task']
	#cpu_number_per_task = "1"
	node_number = request.form['node_number']
	#node_number = "1"
	#print task_number
	partition = "free"

	#print task_number
	#print cpu_number_per_task
	#print node_number
	#with open(input_filename, 'w') as src_file:
		#src_file.write(source_code)

	client = ehpc_client()

	is_success = client.login()
	if not is_success:
		print "login fail."

	is_success = client.upload(path, input_filename, source_code)
	if not is_success:
		print "upload fail."

	compile_out = client.ehpc_compile(path, input_filename, output_filename, compiler)
	run_out = client.ehpc_run(output_filename, path, task_number, cpu_number_per_task, node_number)

	result['status'] = 'success'
	result['problem_id'] = pid
	result['compile_out'] = str(compile_out)
	result['run_out'] = str(run_out)

	return jsonify(**result)

