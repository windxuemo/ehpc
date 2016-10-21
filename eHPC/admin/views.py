#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, request, redirect, url_for
from . import admin
from ..models import Course, Classify, Choice
from ..user.authorize import admin_login
from .. import db
import os
from werkzeug.utils import secure_filename


@admin.route('/')
def index():
    return redirect(url_for('admin.course'))


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
def problem():
    choice = Choice.query.all()
    return render_template('admin/problem/choice.html', choices=choice)


@admin.route('/problem/choice_problem/')
def choice_problem():
    classifies = Classify.query.all()
    if 'id' in request.args:
        choice = Choice.query.filter_by(id=request.args['id']).first_or_404()
        classify_selected = ""
        for temp in choice.classifies:
            classify_selected += unicode(temp.id) + u';'
        classify_selected = classify_selected[:len(classify_selected) - 1]

        options = choice.detail.split(';')
        return render_template('admin/problem/edit-choice-problem.html', choice=choice,
                               classifies=classifies, classify_selected=classify_selected, options=options)
    else:
        return render_template('admin/problem/add-new-choice-problem.html', classifies=classifies)


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
