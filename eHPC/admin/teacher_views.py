#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, request, redirect, url_for, abort, jsonify, current_app
from ..user.authorize import admin_login, teacher_login
from . import admin
from ..models import Course, Lesson, Material, User, Choice, Classify, Article
from .. import db
import os
from werkzeug.utils import secure_filename
from flask_babel import gettext

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'bmp', 'mkv', 'mp3', 'pdf', 'ppt'}


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS


@admin.route('/course/', methods=['POST', 'GET'])
@teacher_login
def course():
    all_courses = Course.query.all()
    return render_template('admin/course/index.html',
                           title=gettext('Course Admin'),
                           courses=all_courses)


@admin.route('/course/create/')
@teacher_login
def course_create():
    return render_template('admin/course/create.html',
                           title=gettext('Create Course'))


@admin.route('/course/<int:cid>/edit/')
@teacher_login
def course_edit(cid):
    cour = Course.query.filter_by(id=cid).first_or_404()
    return render_template('admin/course/edit.html', c=cour,
                           title=gettext('Edit Course'))


@admin.route('/course/<int:cid>/picture/')
@teacher_login
def course_picture(cid):
    cour = Course.query.filter_by(id=cid).first_or_404()
    return render_template('admin/course/picture.html', c=cour,
                           title=gettext('Course Picture'))


@admin.route('/course/<int:cid>/lesson/')
@teacher_login
def course_lesson(cid):
    cour = Course.query.filter_by(id=cid).first_or_404()
    return render_template('admin/course/lesson.html',
                           title=gettext('Course Lesson'),
                           lessons=cour.lessons,
                           c=cour)


@admin.route('/course/<int:cid>/lesson/<int:lid>/material/')
@teacher_login
def lesson_material(cid, lid):
    c = Course.query.filter_by(id=cid).first_or_404()
    l = c.lessons.filter_by(id=lid).first_or_404()
    return render_template('admin/course/material.html', c=c,
                           l=l,
                           materials=l.materials,
                           title=gettext('Lesson Material'))


@admin.route('/problem/')
@teacher_login
def problem():
    choice = Choice.query.all()
    return render_template('admin/problem/choice.html',
                           title=gettext('Problem Admin'),
                           choices=choice)


@admin.route('/problem/choice_problem/')
@teacher_login
def choice_problem():
    classifies = Classify.query.all()
    if 'id' in request.args:
        choice = Choice.query.filter_by(id=request.args['id']).first_or_404()
        classify_selected = ""
        for temp in choice.classifies:
            classify_selected += unicode(temp.id) + u';'
        classify_selected = classify_selected[:len(classify_selected) - 1]

        options = choice.detail.split(';')
        return render_template('admin/problem/edit_choice_problem.html', choice=choice,
                               classifies=classifies,
                               classify_selected=classify_selected,
                               options=options)
    else:
        return render_template('admin/problem/add_new_choice_problem.html',
                               classifies=classifies)


@admin.route('/process/', methods=['POST'])
@teacher_login
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
        return redirect(url_for('admin.course_edit', cid=unicode(c.id)))
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
    elif request.form['op'] == 'create_choice_problem':
        if request.form['c_type'] == '0':
            c_type = False
        else:
            c_type = True
        choice = Choice(title=request.form['title'], detail=request.form['detail'],
                        c_type=c_type, answer=request.form['answer'])
        classify = request.form.getlist('classify[]')
        for i in classify:
            classify = Classify.query.filter_by(id=i).first_or_404()
            choice.classifies.append(classify)
        db.session.add(choice)
        db.session.commit()
        return unicode(choice.id)
    elif request.form['op'] == 'edit_choice_problem':
        choice = Choice.query.filter_by(id=request.form['id']).first_or_404()
        choice.title = request.form['title']
        choice.detail = request.form['detail']
        if request.form['c_type'] == '0':
            c_type = False
        else:
            c_type = True
        choice.c_type = c_type
        choice.answer = request.form['answer']
        classify = request.form.getlist('classify[]')
        for i in choice.classifies:
            choice.classifies.remove(i)
        for i in classify:
            classify = Classify.query.filter_by(id=i).first_or_404()
            choice.classifies.append(classify)
        db.session.commit()
        return unicode(choice.id)
    elif request.form['op'] == "del_choice":
        choice = Choice.query.filter_by(id=request.form['id']).first_or_404()
        db.session.delete(choice)
        db.session.commit()
        return unicode(choice.id)
    elif request.form['op'] == "del_lesson":
        c = Course.query.filter_by(id=request.form['cid']).first_or_404()
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
    else:
        return abort(404)


ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'bmp'}


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS


@admin.route('/upload/', methods=['POST'])
@teacher_login
def upload():
    pic = request.files['pic']
    if pic and allowed_file(pic.filename):
        filename = secure_filename(pic.filename)
        pic.save(os.path.join('eHPC/static/images/course', filename))
        return os.path.join('/static/images/course', filename)
    return 'error'


@admin.route('/data/', methods=['POST'])
@teacher_login
def data():
    if request.form['type'] == 'lesson':
        l = Lesson.query.filter_by(id=request.form['lid']).first_or_404()
        return jsonify(title=l.title, content=l.content)
    else:
        abort(404)

