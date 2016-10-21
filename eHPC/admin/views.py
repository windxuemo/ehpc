#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, request, redirect, url_for
from . import admin
from ..models import Course, User
from ..user.authorize import admin_login
from .. import db
import os
from werkzeug.utils import secure_filename


@admin.route('/')
def index():
    return redirect(url_for('admin.course'))

@admin.route('/user', methods=['POST', 'GET'])
def user():
    all_users = User.query.all()
    return render_template('admin/user/index.html', users=all_users)

@admin.route('/user/edit')
def user_edit():
    u = User.query.filter_by(id=request.args['uid']).first()
    return render_template('admin/user/edit.html', u=u)

@admin.route('/course', methods=['POST', 'GET'])
def course():
    all_courses = Course.query.all()
    return render_template('admin/course/index.html', courses=all_courses)


@admin.route('/course/create')
def create():
    return render_template('admin/course/create.html')


@admin.route('/course/edit')
def edit():
    cour = Course.query.filter_by(id=request.args['cid']).first()
    return render_template('admin/course/edit.html', c=cour)


@admin.route('/course/picture')
def picture():
    cour = Course.query.filter_by(id=request.args['cid']).first()
    return render_template('admin/course/picture.html', c=cour)


@admin.route('/course/lesson')
def lesson():
    cour = Course.query.filter_by(id=request.args['cid']).first()
    return render_template('admin/course/lesson.html', c=cour)


@admin.route('/problem')
def problem(): pass


@admin.route('/group')
def group(): pass


@admin.route('/process', methods=['POST'])
def process():
    # for delete
    if request.form['op'] == 'del':
        c = Course.query.filter_by(id=request.form['id']).first()
        db.session.delete(c)
        db.session.commit()
        return "finished"
    # for edit
    elif request.form['op'] == 'edit':
        c = Course.query.filter_by(id=request.form['id']).first()
        c.title = request.form['title']
        c.subtitle = request.form['subtitle']
        c.about = request.form['about']
        db.session.add(c)
        db.session.commit()
        return unicode(c.id)
    # for create
    elif request.form['op'] == 'create':
        c = Course(title=request.form['title'])
        c.subtitle = ""
        c.about = ""
        c.lessonNum = 0
        c.smallPicture = 'images/course/noImg.jpg'
        db.session.add(c)
        db.session.commit()
        return redirect(url_for('admin.edit', cid=unicode(c.id)))
    # for save picture
    elif request.form['op'] == 'pic':
        c = Course.query.filter_by(id=request.form['id']).first()
        c.smallPicture = os.path.join('images/course', request.form['name'])
        db.session.add(c)
        db.session.commit()
        return unicode(c.id)
    elif request.form['op'] == 'change_permission':
        u = User.query.filter_by(id=request.form['id']).first()
	u.permissions = request.form['permission']
	db.session.add(u)
	db.session.commit()
	return redirect(url_for('admin.user', uid=unicode(u.id)))
    else:
        return "error"


ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'bmp'}


def allowed_file(filename):
    return '.' in filename and \
        filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS


@admin.route('/upload', methods=['POST'])
def upload():
    pic = request.files['pic']
    if pic and allowed_file(pic.filename):
        filename = secure_filename(pic.filename)
        pic.save(os.path.join('eHPC/static/images/course', filename))
        return os.path.join('/static/images/course', filename)
    return 'error'
