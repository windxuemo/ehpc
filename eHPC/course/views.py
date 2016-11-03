#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, abort, jsonify, current_app
from . import course
from ..models import Course, Material
from flask_babel import gettext
from flask_login import current_user
from ..course.course_util import student_not_in_course, student_in_course
from ..user.authorize import student_login
from .. import db
import os


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
@student_not_in_course
def join(cid, u=current_user):
    course_joined = Course.query.filter_by(id=cid).first_or_404()
    course_joined.users.append(u)
    course_joined.studentNum += 1
    db.session.commit()

    # 更新在本课堂的学员
    users_list = render_template('course/widget_course_students.html', course=course_joined)
    student_num = course_joined.studentNum
    return jsonify(status='success', users_list=users_list,
                   student_num=student_num)


@course.route('/exit/<int:cid>/')
@student_login
@student_in_course
def exit_out(cid, u=current_user):
    course_joined = Course.query.filter_by(id=cid).first_or_404()
    course_joined.users.remove(u)
    course_joined.studentNum -= 1
    db.session.commit()

    users_list = render_template('course/widget_course_students.html', course=course_joined)
    student_num = course_joined.studentNum
    return jsonify(status='success', users_list=users_list,
                   student_num=student_num)


@course.route('/res/<int:mid>/')
def material(mid):
    cur_material = Material.query.filter_by(id=mid).first()
    cur_lesson = cur_material.lesson
    cur_course = cur_lesson.course
    print(cur_material.m_type)
    return render_template('course/player.html',
                           type=cur_material.m_type,
                           title=cur_material.name,
                           cur_course=cur_course,
                           cur_material=cur_material)


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
