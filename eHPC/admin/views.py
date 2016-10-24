#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, request, redirect, url_for, abort, jsonify
from . import admin
from ..models import Course, Lesson, Material, User
from ..user.authorize import student_login, admin_login
from .. import db
import os
from werkzeug.utils import secure_filename

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'bmp', 'mkv', 'mp3', 'pdf', 'ppt'}


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS


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
    cour = Course.query.filter_by(id=request.args['cid']).first_or_404()
    return render_template('admin/course/edit.html', c=cour)


@admin.route('/course/picture')
def picture():
    cour = Course.query.filter_by(id=request.args['cid']).first_or_404()
    return render_template('admin/course/picture.html', c=cour)


@admin.route('/course/lesson')
def lesson():
    cour = Course.query.filter_by(id=request.args['cid']).first_or_404()
    return render_template('admin/course/lesson.html', c=cour, lessons=cour.lessons)


@admin.route('/course/lesson/material')
def material():
    c = Course.query.filter_by(id=request.args['cid']).first_or_404()
    l = c.lessons.filter_by(id=request.args['lid']).first_or_404()
    return render_template('admin/course/material.html', c=c, l=l, materials=l.materials)


@admin.route('/problem')
def problem(): pass


@admin.route('/group')
def group(): pass


@admin.route('/process', methods=['POST'])
def process():
    if request.form['op'] == 'del':
        c = Course.query.filter_by(id=request.form['id']).first_or_404()
        db.session.delete(c)
        db.session.commit()
        return "finished"
    elif request.form['op'] == 'edit':
        c = Course.query.filter_by(id=request.form['id']).first_or_404()
        c.title = request.form['title']
        c.subtitle = request.form['subtitle']
        c.about = request.form['about']
        # db.session.add(c)
        db.session.commit()
        return unicode(c.id)
    elif request.form['op'] == 'create':
        c = Course(title=request.form['title'])
        c.subtitle = ""
        c.about = ""
        c.lessonNum = 0
        c.smallPicture = 'images/course/noImg.jpg'
        db.session.add(c)
        db.session.commit()
        return redirect(url_for('admin.edit', cid=unicode(c.id)))
    elif request.form['op'] == 'pic':
        c = Course.query.filter_by(id=request.form['id']).first_or_404()
        c.smallPicture = os.path.join('images/course', request.form['name'])
        # db.session.add(c)
        db.session.commit()
        return unicode(c.id)
    elif request.form['op'] == 'upload_pic':
        pic = request.files['pic']
        if pic and allowed_file(pic.filename):
            filename = secure_filename(pic.filename)
            pic.save(os.path.join('eHPC/static/images/course', filename))
            return os.path.join('/static/images/course', filename)
        else:
            return abort(404)
    elif request.form['op'] == 'create_lesson':
        l = Lesson(number=request.form['id'], title=request.form['title'], content=request.form['content'])
        c = Course.query.filter_by(id=request.form['id']).first_or_404()
        c.lessons.append(l)
        c.lessonNum += 1
        db.session.commit()
        return unicode(c.id)
    elif request.form['op'] == "del_lesson":
        c = Course.query.filter_by(id=request.form['id']).first_or_404()
        l = c.lessons.filter_by(id=request.form['lid']).first_or_404()
        c.lessons.remove(l)
        c.lessonNum -= 1
        db.session.delete(l)
        db.session.commit()
        return "finished"
    elif request.form['op'] == "edit_lesson":
        c = Course.query.filter_by(id=request.form['id']).first_or_404()
        l = c.lessons.filter_by(id=request.form['lid']).first_or_404()
        l.title = request.form['title']
        l.content = request.form['content']
        db.session.commit()
        return unicode(c.id)
    elif request.form['op'] == "upload_material":
        c = Course.query.filter_by(id=request.form['id']).first_or_404()
        l = c.lessons.filter_by(id=request.form['lid']).first_or_404()
        f = request.files['file']
        if f and allowed_file(f.filename):
            filename = secure_filename(f.filename)
            f.save(os.path.join('eHPC/static/upload', filename))
            m = Material(name=filename, m_type=request.form['type'], uri=os.path.join('static/upload', filename))
            l.materials.append(m)
            db.session.commit()
            return unicode(c.id)
        else:
            abort(404)
    elif request.form['op'] == "del_material":
        c = Course.query.filter_by(id=request.form['id']).first_or_404()
        l = c.lessons.filter_by(id=request.form['lid']).first_or_404()
        seq = request.form.getlist('seq[]')
        for x in seq:
            m = l.materials.filter_by(id=x).first_or_404()
            l.materials.remove(m)
            os.remove(os.path.join('eHPC/', m.uri))
            db.session.delete(m)
            db.session.commit()
        return unicode(c.id)
    elif request.form['op'] == 'change_permission':
        u = User.query.filter_by(id=request.form['id']).first()
        u.permissions = request.form['permission']
        db.session.add(u)
        db.session.commit()
        return redirect(url_for('admin.user', uid=unicode(u.id)))
    else:
        return abort(404)


@admin.route('/data', methods=['POST'])
def data():
    if request.form['type'] == 'lesson':
        l = Lesson.query.filter_by(id=request.form['lid']).first_or_404()
        return jsonify(title=l.title, content=l.content)
    else:
        return abort(404)
