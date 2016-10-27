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
from flask import current_app
from ..util.upload_file import upload_img, upload_material

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'bmp', 'mkv', 'mp3', 'pdf', 'ppt', 'pptx'}


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
        return render_template('admin/problem/edit_choice_problem.html', choice=choice, classifies=classifies,
                               classify_selected=classify_selected, options=options)
    else:
        return render_template('admin/problem/add_new_choice_problem.html', classifies=classifies)


@admin.route('/process/course/', methods=['POST'])
@teacher_login
def process_course():
    if request.form['op'] == 'create':
        cur_course = Course(title=request.form['title'], subtitle='', about='', lessonNum=0,
                            smallPicture='images/course/noImg.jpg')
        db.session.add(cur_course)
        db.session.commit()
        return redirect(url_for('admin.course_edit', cid=unicode(cur_course.id)))
    elif request.form['op'] == 'del':
        cur_course = Course.query.filter_by(id=request.form['id']).first_or_404()
        for l in cur_course.lessons:
            for m in l.materials:
                os.remove(os.path.join(current_app.config['RESOURCE_FOLDER'], m.uri))
                db.session.delete(m)
            db.session.delete(l)
        if os.path.exists(os.path.join(current_app.config['RESOURCE_FOLDER'], 'course_%d' % cur_course.id)):
            os.rmdir(os.path.join(current_app.config['RESOURCE_FOLDER'], 'course_%d' % cur_course.id))
        os.remove(os.path.join(current_app.config['COURSE_COVER_FOLDER'], 'cover_%d.png' % cur_course.id))
        db.session.delete(cur_course)
        db.session.commit()
        return jsonify(status="success", id=cur_course.id)
    elif request.form['op'] == 'edit':
        cur_course = Course.query.filter_by(id=request.form['id']).first_or_404()
        cur_course.title = request.form['title']
        cur_course.subtitle = request.form['subtitle']
        cur_course.about = request.form['about']
        db.session.commit()
        return jsonify(status="success", id=cur_course.id)
    elif request.form['op'] == 'pic':
        cur_course = Course.query.filter_by(id=request.form['id']).first_or_404()
        cur_course.smallPicture = os.path.join('images/course', request.form['name'])
        db.session.commit()
        return unicode(cur_course.id)
    elif request.form['op'] == 'upload_pic':
        cur_course = Course.query.filter_by(id=request.form['id']).first_or_404()
        pic = request.files['pic']
        filename = "cover_%d.png" % cur_course.id
        cover_path = os.path.join(current_app.config['COURSE_COVER_FOLDER'], filename)
        status = upload_img(pic, 171, 304, cover_path)
        print(status)
        if status[0]:
            return os.path.join('/static/images/course', filename)
        else:
            return jsonify(status="fail", id=cur_course.id)
    else:
        return abort(404)


@admin.route('/process/lesson/', methods=['POST'])
@teacher_login
def process_lesson():
    if request.form['op'] == 'create':
        cur_lesson = Lesson(number=request.form['id'], title=request.form['title'], content=request.form['content'])
        cur_course = Course.query.filter_by(id=request.form['id']).first_or_404()
        cur_course.lessons.append(cur_lesson)
        cur_course.lessonNum += 1
        db.session.commit()
        return jsonify(status="success", id=cur_lesson.id)
    elif request.form['op'] == "del":
        cur_course = Course.query.filter_by(id=request.form['cid']).first_or_404()
        cur_lesson = cur_course.lessons.filter_by(id=request.form['lid']).first_or_404()
        cur_course.lessons.remove(cur_lesson)
        cur_course.lessonNum -= 1
        for m in cur_lesson.materials:
            os.remove(os.path.join(current_app.config['RESOURCE_FOLDER'], m.uri))
            db.session.delete(m)
        db.session.delete(cur_lesson)
        db.session.commit()
        return jsonify(status="success", id=cur_lesson.id)
    elif request.form['op'] == "edit":
        cur_course = Course.query.filter_by(id=request.form['id']).first_or_404()
        cur_lesson = cur_course.lessons.filter_by(id=request.form['lid']).first_or_404()
        cur_lesson.title = request.form['title']
        cur_lesson.content = request.form['content']
        db.session.commit()
        return jsonify(status="success", id=cur_lesson.id)
    elif request.form['op'] == 'data':
        l = Lesson.query.filter_by(id=request.form['lid']).first_or_404()
        return jsonify(title=l.title, content=l.content)
    else:
        return abort(404)


@admin.route('/process/material/', methods=['POST'])
@teacher_login
def process_material():
    if request.form['op'] == "upload":
        cur_course = Course.query.filter_by(id=request.form['id']).first_or_404()
        cur_lesson = cur_course.lessons.filter_by(id=request.form['lid']).first_or_404()
        cur_material = request.files['file']
        filename = secure_filename(cur_material.filename)
        print(filename)
        m = Material(name=filename, m_type=request.form['type'], uri="")
        cur_lesson.materials.append(m)
        db.session.commit()  # get material id
        m.uri = os.path.join("course_%d" % cur_course.id,
                             "lesson%d_material%d." % (cur_lesson.id, m.id) + cur_material.filename.rsplit('.', 1)[1])
        status = upload_material(cur_material, os.path.join(current_app.config['RESOURCE_FOLDER'], m.uri))
        if status:
            db.session.commit()
            return jsonify(status="success", id=cur_lesson.id)
        else:
            db.session.delete(m)
            db.session.commit()
            return jsonify(status="fail", id=cur_lesson.id)
    elif request.form['op'] == "del":
        cur_course = Course.query.filter_by(id=request.form['id']).first_or_404()
        cur_lesson = cur_course.lessons.filter_by(id=request.form['lid']).first_or_404()
        seq = request.form.getlist('seq[]')
        for x in seq:
            m = cur_lesson.materials.filter_by(id=x).first_or_404()
            # cur_lesson.materials.remove(m)
            os.remove(os.path.join(current_app.config['RESOURCE_FOLDER'], m.uri))
            db.session.delete(m)
            db.session.commit()
        return jsonify(status="success", id=cur_lesson.id)
    else:
        return abort(404)


@admin.route('/process/choice/', methods=['POST'])
@teacher_login
def process_choice():
    if request.form['op'] == 'create':
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
    elif request.form['op'] == 'edit':
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
    elif request.form['op'] == "del":
        choice = Choice.query.filter_by(id=request.form['id']).first_or_404()
        db.session.delete(choice)
        db.session.commit()
        return unicode(choice.id)
    else:
        return abort(404)


@admin.route('/process/user/', methods=['POST'])
@teacher_login
def process_user():
    if request.form['op'] == 'change_permission':
        u = User.query.filter_by(id=request.form['id']).first()
        u.permissions = request.form['permission']
        db.session.add(u)
        db.session.commit()
        return redirect(url_for('admin.user', uid=unicode(u.id)))
    else:
        return abort(404)
