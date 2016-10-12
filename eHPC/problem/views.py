from flask import render_template, jsonify, request, url_for, abort, redirect
from . import problem
from ..models import Program, Choice
from flask_babel import gettext
from time import sleep


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
    cho = Choice.query.all()
    return render_template('problem/show_choice.html',
                           title=gettext('Choice Practice'),
                           choices=cho)


@problem.route('/program/<int:pid>/')
def program_view(pid):
    pro = Program.query.filter_by(id=pid).first()
    return render_template('problem/problem_detail.html',
                           title=pro.title,
                           problem=pro)


@problem.route('/<int:pid>/submit/', methods=['POST'])
def submit(pid):
    source_code = request.form['source_code']
    # TODO here.  Get the result.
    result = dict()
    result['problem_id'] = pid
    result['compiler'] = "Compiling... "                # Get the compiler result
    result['run'] = "Running result... "                # Get the run result

    sleep(2)
    return jsonify(**result)
