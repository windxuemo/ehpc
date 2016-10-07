from flask import render_template, jsonify, request, url_for, abort, redirect
from . import problem
from ..models import Problem
from flask_babel import gettext
from time import sleep

@problem.route('/')
def index():
    problems = Problem.query.all();
    return render_template('problem/index.html',
                           title=gettext('Petition Problem List'),
                           problems=problems)


@problem.route('/<int:pid>/')
def view(pid):
    pro = Problem.query.filter_by(id=pid).first()
    return render_template('problem/detail.html',
                           title=gettext('Problem'),
                           problem=pro)


@problem.route('/<int:pid>/submit/', methods=['POST'])
def submit(pid):
    if request.method == 'POST':
        print request.form
        source_code = request.form['source_code']
        # TODO here.  Get the result.
        result = dict()
        result['problem_id'] = pid
        result['status'] = "Accepted! "

        sleep(2)
        return jsonify(**result)
