from flask import render_template, abort, jsonify
from . import course
from ..models import Course
from flask_babel import gettext


@course.route('/')
def index():
    all_courses = Course.query.all()
    return render_template('course/index.html', title=gettext('Courses'), courses=all_courses)


@course.route('/<int:cid>/', methods=['GET', 'POST'])
def view(cid):
    # TODO
    c = Course.query.filter_by(id=cid).first()
    return render_template('course/detail.html', course=c)


@course.route('/<int:uid>/join/<int:cid>')
def join(uid, cid):
    # TODO
    return jsonify(join_in='success')


# API to get overview of one course
@course.route('/<int:cid>/about/')
def detail_course(cid):
    c = Course.query.filter_by(id=cid).first()
    data = dict()
    data['about'] = c.about
    return jsonify(**data)


# API to get all lessons info contained in the course
@course.route('/<int:cid>/lessons/')
def detail_lessons(cid):
    c = Course.query.filter_by(id=cid).first()
    data = dict()
    data['lessons'] = c.lessons
    return jsonify(**data)
