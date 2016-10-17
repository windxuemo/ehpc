from flask import render_template, jsonify, request, url_for, abort, redirect
from . import problem
from ..models import Program, Choice, Classify
from flask_babel import gettext
from time import sleep
import subprocess


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
def program_view(pid):
    pro = Program.query.filter_by(id=pid).first()
    return render_template('problem/program_detail.html',
                           title=pro.title,
                           problem=pro)


@problem.route('/choice/<int:cid>/')
def choice_view(cid):
    cho = Choice.query.filter_by(id=cid).first()
    return render_template('problem/choice_detail.html',
                           title=cho.title,
                           choice=cho)


@problem.route('/<int:pid>/submit/', methods=['POST'])
def submit(pid):
    source_code = request.form['source_code']
    # TODO here.  Get the result.
    try:
        source_file = open('main.c', 'w')
        source_file.write(source_code)
    except IOError:
        print('File Error')
    finally:
        source_file.close()

    build_cmd = {
        "gcc": "gcc main.c -o main -Wall -lm -O2 -std=c99 --static -DONLINE_JUDGE",
    }

    p = subprocess.Popen(build_cmd["gcc"], shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    out, err = p.communicate()

    result = dict()
    result['problem_id'] = pid
    result['compiler'] = out  # Get the compiler result
    result['run'] = err  # Get the run result

    sleep(2)
    return jsonify(**result)
