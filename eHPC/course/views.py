from flask import render_template, abort
from . import course
from ..models import Course
from flask_babel import gettext


@course.route('/')
def index():
    all_courses = Course.query.all()
    return render_template('course/index.html', title=gettext('Courses'), courses=all_courses)


@course.route('<int:cid>', methods=['GET', 'POST'])
def view(cid):
    # TODO
    abort(404)
