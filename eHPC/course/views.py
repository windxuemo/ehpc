#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, abort, jsonify
from . import course
from ..models import Course, Material
from flask_babel import gettext
from flask_login import current_user
from ..user.authorize import student_login
from .. import db


@course.route('/')
def index():
    all_courses = Course.query.all()
    return render_template('course/index.html', title=gettext('Courses'), courses=all_courses)


@course.route('/<int:cid>/')
def view(cid):
    c = Course.query.filter_by(id=cid).first()
    return render_template('course/detail.html',
                           title=c.title,
                           course=c)


@course.route('/join/<int:cid>/')
@student_login
def join(cid, u=current_user):
    course_joined = Course.query.filter_by(id=cid).first_or_404()
    course_joined.users.append(u)
    db.session.commit()

    # 更新在本课堂的学员
    users_list = render_template('course/widget_course_students.html', course=course_joined)
    return jsonify(join_in='success', users_list=users_list)


@course.route('/exit/<int:cid>/')
@student_login
def exit_out(cid, u=current_user):
    course_joined = Course.query.filter_by(id=cid).first_or_404()
    course_joined.users.remove(u)
    db.session.commit()

    users_list = render_template('course/widget_course_students.html', course=course_joined)
    return jsonify(exit_result='success', users_list=users_list)


@course.route('/res/<int:mid>/')
def material(mid):
    m = Material.query.filter_by(id=mid).first()
    return render_template('course/material_detail.html', material=m)


# API to get overview of one course
@course.route('/<int:cid>/about/')
def detail_course(cid):
    c = Course.query.filter_by(id=cid).first()
    html_content = render_template('course/widget_detail_about.html', course=c)
    return jsonify(data=html_content)


# API to get all lessons info contained in the course
@course.route('/<int:cid>/lessons/')
def detail_lessons(cid):
    c = Course.query.filter_by(id=cid).first()
    all_lessons = c.lessons
    html_content = render_template('course/widget_detail_lessons.html', lessons=all_lessons)
    return jsonify(data=html_content)
