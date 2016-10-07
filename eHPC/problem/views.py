from flask import render_template, jsonify, request, url_for, abort, redirect
from . import problem
from ..models import Problem
from flask_babel import gettext


@problem.route('/')
def index():
    problems = Problem.query.all();
    return render_template('problem/index.html',
                           title=gettext('Petition Problem List'),
                           problems=problems)


@problem.route('/<int:pid>/')
def view(pid):
    pro = Problem.query.filter_by(id=pid).first()
    return render_template('problem/detail.html', problem=pro)


@problem.route('/<int:pid>/submit/', methods=['POST'])
def submit(pid):
    if request.method == 'POST':
        source_code = request.form['source_code']
        # TODO here.  Get the result.
        result = dict()
        result['status'] = "Accept"

        return jsonify(**result)
