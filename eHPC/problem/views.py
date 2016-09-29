from flask import render_template, jsonify, request
from . import problem
from ..models import Problem
from flask_babel import gettext
from ..util.time_process import natural_time


@problem.route('/')
def index():
    return render_template('problem/index.html', title=gettext('Petition Problem List'))


@problem.route("lists/")
def list():
    fields = ['id', 'title', 'difficulty', 'createdTime', 'acceptedNum']
    order_dir = request.args.get('sSortDir_0')
    order_field = int(request.args.get('iSortCol_0'))
    length = int(request.args.get('iDisplayLength', 10))
    start = int(request.args.get('iDisplayStart', 0))

    problems = Problem.query.all()
    # Filter the topic according to the keywords.
    key = request.args.get('sSearch')
    if key:
        problems = filter(lambda x: (key == str(x.id) or key == x.title or key in x.detail), problems)

    # Sort the data according to specified columns.
    problems.sort(key=lambda x: getattr(x, fields[order_field]), reverse=False if order_dir == 'asc' else True)

    # Put data together to response.
    data = dict()
    data['aaData'] = []
    data['iTotalDisplayRecords'] = len(problems)
    data['iTotalRecords'] = Problem.query.count()

    pro = problems[start:start + length]
    data['aaData'] = [[p.id, p.title, p.difficulty, natural_time(p.createdTime), p.acceptedNum] for p in pro]

    return jsonify(**data)
