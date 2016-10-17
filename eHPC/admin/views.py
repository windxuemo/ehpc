#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, request, redirect, url_for
from . import admin
from ..models import Course
from ..user.authorize import student_login
from .. import db
import os


@admin.route('/', methods=['POST', 'GET'])
def index():
    if request.method == "POST":
        if request.form['op'] == 'del':
            c = Course.query.filter_by(id=request.form['cid']).first()
            db.session.delete(c)
            db.session.commit()

    all_courses = Course.query.all()
    return render_template('admin/course/index.html', courses=all_courses)


@admin.route('/course', methods=['POST', 'GET'])
def course():
    if request.method == "POST":
        if request.form['op'] == 'del':
            c = Course.query.filter_by(id=request.form['cid']).first()
            db.session.delete(c)
            db.session.commit()

    all_courses = Course.query.all()
    return render_template('admin/course/index.html', courses=all_courses)


@admin.route('/course/create')
def create():
    return render_template('admin/course/base.html')


@admin.route('/course/edit')
def edit():
    cour = Course.query.filter_by(id=request.args['cid']).first()
    return render_template('admin/course/edit.html', c=cour)


@admin.route('/course/picture')
def picture():
    return render_template('admin/course/picture.html')


@admin.route('/course/lesson')
def lesson(): pass


@admin.route('/process', methods=['POST'])
def process():
    # for edit
    if 'id' in request.form:
        c = Course.query.filter_by(id=request.form['id']).first()
        c.title = request.form['title']
        c.subtitle = request.form['subtitle']
        c.about = request.form['about']

        db.session.add(c)
        db.session.commit()
        return redirect(url_for('admin.edit', cid=c.id))
    # for create
    else:
        c = Course(title=request.form['title'], subtitle=request.form['subtitle'], about=request.form['about'])
        if 'lessonNum' not in request.form:
            c.lessonNum = 0
        if 'img' not in request.form:
            c.smallPicture = 'images/course/noImg.jpg'

        db.session.add(c)
        db.session.commit()
        return redirect(url_for('admin.create'))


@admin.route('/problem')
def problem(): pass


@admin.route('/group')
def group(): pass


@admin.route('/upload')
def upload():
    if request.method == 'POST':
        f = request.files['file']
        if f:
            f.save(os.path.join('/static/images/course', f.filename))
            return redirect(url_for('course.picture'))

