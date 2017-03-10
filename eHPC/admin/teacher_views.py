#! /usr/bin/env python
# -*- coding: utf-8 -*-
import json
import os
import zipfile
import shutil
from datetime import datetime

from flask import render_template, request, redirect, url_for, abort, jsonify, current_app, make_response, send_file
from flask_login import current_user
from flask_babel import gettext
from sqlalchemy import or_

from . import admin
from .. import db
from ..models import Classify, Program, Paper, Question, PaperQuestion, Homework, HomeworkUpload
from ..models import Course, Lesson, Material, User, Apply
from ..models import Knowledge, Challenge
from ..user.authorize import teacher_login
from ..util.file_manage import upload_img, upload_file, get_file_type, custom_secure_filename, extension_to_file_type
from ..util.pdf import get_paper_pdf
from ..util.file_manage import remove_dirs


@admin.route('/course/', methods=['GET', 'POST'])
@teacher_login
def course():
    if request.method == 'GET':
        return render_template('admin/course/index.html',
                               title=gettext('Course Admin'))
    elif request.method == 'POST':
        # 删除课程
        curr_course = Course.query.filter_by(id=request.form['course_id']).first_or_404()
        for l in curr_course.lessons:
            for m in l.materials:
                os.remove(os.path.join(current_app.config['RESOURCE_FOLDER'], m.uri))
                db.session.delete(m)
            db.session.delete(l)

        resource_path = os.path.join(current_app.config['RESOURCE_FOLDER'], 'course_%d' % curr_course.id)
        homework_path = os.path.join(current_app.config['HOMEWORK_FOLDER'], 'course_%d' % curr_course.id)
        cover_path = os.path.join(current_app.config['COURSE_COVER_FOLDER'], 'cover_%d.png' % curr_course.id)
        remove_dirs(resource_path, homework_path, cover_path)

        db.session.delete(curr_course)
        db.session.commit()
        return jsonify(status="success", course_id=curr_course.id)


@admin.route('/course/create/', methods=['GET', 'POST'])
@teacher_login
def course_create():
    if request.method == 'GET':
        return render_template('admin/course/create.html',
                               title=gettext('Create Course'))
    elif request.method == 'POST':
        # 创建课程
        curr_course = Course(title=request.form['title'], subtitle='', about='',
                             lessonNum=0, smallPicture='upload/course/noImg.jpg')
        curr_course.teacher = current_user
        db.session.add(curr_course)
        db.session.commit()
        os.makedirs(os.path.join(current_app.config['RESOURCE_FOLDER'], 'course_%d' % curr_course.id))
        os.makedirs(os.path.join(current_app.config['HOMEWORK_FOLDER'], 'course_%d' % curr_course.id))
        return redirect(url_for('admin.course_edit', course_id=curr_course.id))


@admin.route('/course/<int:course_id>/edit/', methods=['GET', 'POST'])
@teacher_login
def course_edit(course_id):
    if request.method == 'GET':
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        return render_template('admin/course/edit.html', course=curr_course,
                               title=gettext('Edit Course'))
    elif request.method == 'POST':
        # 编辑课程基本信息
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        curr_course.title = request.form['title']
        curr_course.subtitle = request.form['subtitle']
        curr_course.about = request.form['about']
        db.session.commit()
        return jsonify(status="success", course_id=curr_course.id)


@admin.route('/course/<int:course_id>/picture/', methods=['GET', 'POST'])
@teacher_login
def course_picture(course_id):
    if request.method == 'GET':
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        return render_template('admin/course/picture.html', course=curr_course,
                               title=gettext('Course Picture'))
    elif request.method == 'POST':
        # 上传图片和保存图片
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        curr_course.smallPicture = os.path.join('upload/course', "cover_%d.png" % curr_course.id)
        filename = "cover_%d.png" % curr_course.id
        cover_path = os.path.join(current_app.config['COURSE_COVER_FOLDER'], filename)
        status = upload_img(request.files['pic'], 171, 304, cover_path)
        if status[0]:
            db.session.commit()
            return jsonify(status='success')
        else:
            return jsonify(status="fail")


@admin.route('/course/<int:course_id>/lesson/', methods=['GET', 'POST'])
@teacher_login
def course_lesson(course_id):
    if request.method == 'GET':
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        return render_template('admin/course/lesson.html',
                               title=gettext('Course Lesson'),
                               lessons=curr_course.lessons,
                               course=curr_course)
    elif request.method == 'POST':
        # 课时的增删查改
        if request.form['op'] == 'create':
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_lesson = Lesson(number=course_id, title=request.form['title'], content=request.form['content'])
            db.session.add(curr_lesson)
            curr_course.lessons.append(curr_lesson)
            curr_course.lessonNum += 1
            db.session.commit()
            return jsonify(status="success", id=curr_lesson.id)
        elif request.form['op'] == "edit":
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_lesson = curr_course.lessons.filter_by(id=request.form['lesson_id']).first_or_404()
            curr_lesson.title = request.form['title']
            curr_lesson.content = request.form['content']
            db.session.commit()
            return jsonify(status="success", id=curr_lesson.id)
        elif request.form['op'] == "del":
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_lesson = curr_course.lessons.filter_by(id=request.form['lesson_id']).first_or_404()
            curr_course.lessons.remove(curr_lesson)
            curr_course.lessonNum -= 1
            for m in curr_lesson.materials:
                os.remove(os.path.join(current_app.config['RESOURCE_FOLDER'], m.uri))
                db.session.delete(m)
            db.session.delete(curr_lesson)
            db.session.commit()
            return jsonify(status="success", id=curr_lesson.id)
        elif request.form['op'] == 'data':
            curr_lesson = Lesson.query.filter_by(id=request.form['lesson_id']).first_or_404()
            return jsonify(status="success", title=curr_lesson.title, content=curr_lesson.content)


@admin.route('/course/<int:course_id>/lesson/<int:lesson_id>/material/', methods=['GET', 'POST'])
@teacher_login
def lesson_material(course_id, lesson_id):
    if request.method == 'GET':
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        curr_lesson = curr_course.lessons.filter_by(id=lesson_id).first_or_404()
        return render_template('admin/course/material.html', course=curr_course,
                               lesson=curr_lesson,
                               materials=curr_lesson.materials,
                               title=gettext('Lesson Material'))
    elif request.method == 'POST':
        # 课时材料的上传和删除
        if request.form['op'] == "del":
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_lesson = curr_course.lessons.filter_by(id=lesson_id).first_or_404()
            material_id = request.form.getlist('material_id[]')
            for idx in material_id:
                curr_material = curr_lesson.materials.filter_by(id=idx).first()
                if not curr_material:
                    return jsonify(status="fail", id=curr_lesson.id)
                # 需要在课时对象中删除该资源
                curr_lesson.materials.remove(curr_material)
                db.session.delete(curr_material)
                db.session.commit()
                try:
                    os.remove(os.path.join(current_app.config['RESOURCE_FOLDER'], curr_material.uri))
                except OSError:
                    pass
            return jsonify(status="success", lesson_id=curr_lesson.id)
        elif request.form['op'] == 'local-upload':
            cur_course = Course.query.filter_by(id=course_id).first_or_404()
            cur_lesson = cur_course.lessons.filter_by(id=lesson_id).first_or_404()
            raw_file = request.files['file']
            file_name = custom_secure_filename(raw_file.filename)
            extension = file_name[file_name.rfind('.')+1:]
            file_type = extension_to_file_type(extension)
            cur_material = Material(name=file_name, m_type=file_type, uri="")
            cur_lesson.materials.append(cur_material)
            db.session.commit()  # get material id
            cur_material.uri = os.path.join("course_%d" % course_id,
                                            "lesson%d_material%d.%s" % (lesson_id, cur_material.id, extension))
            status = upload_file(raw_file, os.path.join(current_app.config['RESOURCE_FOLDER'], cur_material.uri),
                                 ['audio', 'video', 'pdf'])
            if status[0]:
                db.session.commit()
                return jsonify(status="success")
            else:
                cur_lesson.materials.remove(cur_material)
                db.session.delete(cur_material)
                db.session.commit()
                return jsonify(status="fail")
        elif request.form['op'] == "link-upload":
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_lesson = curr_course.lessons.filter_by(id=lesson_id).first_or_404()
            if request.form['link-type'] == "origin":
                m_link = request.form['file-link']
                m_name = request.form['file-name']
                m_type = request.form['file-type']
                curr_material = Material(name=m_name, m_type=m_type, uri=m_link)
                db.session.add(curr_material)
                curr_lesson.materials.append(curr_material)
                db.session.commit()
                return jsonify(status="success", id=curr_lesson.id)


@admin.route('/course/<int:course_id>/permission/', methods=['GET', 'POST'])
@teacher_login
def course_permission(course_id):
    if request.method == 'GET':
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        return render_template('admin/course/permission.html', course=curr_course, title=u'权限管理')
    elif request.method == 'POST':
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        curr_course.public = int(request.form['public'])
        if curr_course.public:
            curr_course.beginTime = None
            curr_course.endTime = None
        else:
            curr_course.beginTime = datetime.strptime(request.form['begin'], '%Y-%m-%d %X')
            curr_course.endTime = datetime.strptime(request.form['end'], '%Y-%m-%d %X')
        db.session.commit()
        return jsonify(status="success", course_id=course_id)


@admin.route('/course/<int:course_id>/member/', methods=['GET', 'POST'])
@teacher_login
def course_member(course_id):
    if request.method == 'GET':
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        return render_template('admin/course/member.html', course=curr_course, applies=curr_course.applies, title=u'成员管理')
    elif request.method == 'POST':
        print request.form
        return redirect(url_for('admin.course_member', course_id=course_id))


@admin.route('/course/<int:apply_id>/approved/')
@teacher_login
def course_approved(apply_id):
    curr_apply = Apply.query.filter_by(id=apply_id).first_or_404()
    curr_apply.status = 1
    curr_course = curr_apply.course
    curr_student = curr_apply.user
    curr_course.users.append(curr_student)
    curr_course.studentNum += 1
    db.session.commit()
    return redirect(url_for('admin.course_member', course_id=curr_course.id))


@admin.route('/course/<int:apply_id>/disapproved/')
@teacher_login
def course_disapproved(apply_id):
    curr_apply = Apply.query.filter_by(id=apply_id).first_or_404()
    curr_apply.status = 2
    db.session.commit()
    curr_course = curr_apply.course
    return redirect(url_for('admin.course_member', course_id=curr_course.id))


@admin.route('/course/<int:apply_id>/kick/')
@teacher_login
def course_kick(apply_id):
    curr_apply = Apply.query.filter_by(id=apply_id).first_or_404()
    curr_apply.status = 2
    curr_course = curr_apply.course
    curr_student = curr_apply.user
    curr_course.users.remove(curr_student)
    curr_course.studentNum -= 1
    db.session.commit()
    return redirect(url_for('admin.course_member', course_id=curr_course.id))


@admin.route('/course/<int:course_id>/homework/', methods=['GET', 'POST'])
@teacher_login
def course_homework(course_id):
    """ 课程的作业管理入口页面 """
    if request.method == 'GET':
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        return render_template('admin/course/homework.html', course=curr_course,
                               homeworks=curr_course.homeworks,
                               title=gettext('Course Homework'))
    elif request.method == "POST":
        # 作业的增加查改
        if request.form['op'] == 'create':
            curr_homework = Homework(title=request.form['title'], description=request.form['description'],
                                     deadline=request.form['deadline'])
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_course.homeworks.append(curr_homework)
            db.session.add(curr_homework)
            db.session.commit()
            os.makedirs(os.path.join(current_app.config['HOMEWORK_FOLDER'], 'course_%d' % curr_course.id, 'homework_%d' % curr_homework.id))
            return jsonify(status="success", homework_id=curr_homework.id)
        elif request.form['op'] == "del":
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_homework = curr_course.homeworks.filter_by(id=request.form['homework_id']).first_or_404()
            curr_course.homeworks.remove(curr_homework)
            db.session.delete(curr_homework)
            db.session.commit()

            homework_path = os.path.join(current_app.config['HOMEWORK_FOLDER'], 'course_%d' % curr_course.id, 'homework_%d' % curr_homework.id)

            remove_dirs(homework_path)
            return jsonify(status="success", homework_id=curr_homework.id)
        elif request.form['op'] == "edit":
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_homework = curr_course.homeworks.filter_by(id=request.form['homework_id']).first_or_404()
            curr_homework.title = request.form['title']
            curr_homework.description = request.form['description']
            curr_homework.deadline = request.form['deadline']
            db.session.commit()
            return jsonify(status="success", homework_id=curr_homework.id)
        elif request.form['op'] == 'data':
            curr_homework = Homework.query.filter_by(id=request.form['homework_id']).first_or_404()
            deadline = curr_homework.deadline.strftime('%Y-%m-%d %H:%M')
            return jsonify(status="success", title=curr_homework.title, description=curr_homework.description,
                           deadline=deadline)
        else:
            return abort(404)


@admin.route('/course/<int:course_id>/homework/<int:homework_id>', methods=['GET', 'POST'])
@teacher_login
def course_homework_upload_list(course_id, homework_id):
    if request.method == "GET":
        curr_homework = Homework.query.filter_by(id=homework_id).first_or_404()
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        return render_template('admin/course/homework_upload.html', course=curr_course, homework=curr_homework, uploads=curr_homework.uploads)
    elif request.method == "POST":
        curr_homework = Homework.query.filter_by(id=homework_id).first_or_404()
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        upload_id = request.form.getlist('upload_id[]')
        if request.form['op'] == "del":
            for idx in upload_id:
                curr_upload = curr_homework.uploads.filter_by(id=idx).first()
                if not curr_upload:
                    return jsonify(status="fail", info="Not Found")
                curr_homework.uploads.remove(curr_upload)
                db.session.delete(curr_upload)
                db.session.commit()
                try:
                    os.remove(os.path.join(current_app.config['HOMEWORK_FOLDER'], curr_upload.uri))
                except OSError:
                    pass
            return jsonify(status="success")
        elif request.form["op"] == "download":
            zip_name = "homework_%d.zip" % curr_homework.id
            f = zipfile.ZipFile(zip_name, 'w', zipfile.ZIP_DEFLATED)
            for idx in upload_id:
                curr_upload = curr_homework.uploads.filter_by(id=idx).first()
                file_path = os.path.join(current_app.config['HOMEWORK_FOLDER'], curr_upload.uri)
                try:
                    f.write(file_path, curr_upload.name)
                except OSError:
                    pass
            f.close()
            dest_path = os.path.join(current_app.config['HOMEWORK_FOLDER'], "course_%d" % curr_course.id, "homework_%d" % curr_homework.id)
            if os.path.exists(os.path.join(dest_path, "homework_%d.zip" % curr_homework.id)):
                os.remove(os.path.join(dest_path, "homework_%d.zip" % curr_homework.id))
            shutil.move(zip_name, dest_path)
            file_name = os.path.join("course_%d" % curr_course.id, "homework_%d.zip" % curr_homework.id)
            return jsonify(status="success", homework_id=curr_homework.id)


@admin.route('/course/<int:course_id>/paper/', methods=['GET', 'POST'])
@teacher_login
def course_paper(course_id):
    """ 课程cid 的试卷管理入口页面 """
    if request.method == 'GET':
        curr_course = Course.query.filter_by(id=course_id).first_or_404()
        return render_template('admin/course/paper.html', course=curr_course,
                               papers=curr_course.papers,
                               title=gettext('Course Paper'))
    elif request.method == 'POST':
        # 试卷的增加查改
        if request.form['op'] == 'create':
            curr_paper = Paper(title=request.form['title'], about=request.form['content'])
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_course.papers.append(curr_paper)
            db.session.add(curr_paper)
            db.session.commit()
            return jsonify(status="success", paper_id=curr_paper.id)
        elif request.form['op'] == "del":
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_paper = curr_course.papers.filter_by(id=request.form['paper_id']).first_or_404()
            curr_course.papers.remove(curr_paper)
            db.session.delete(curr_paper)
            db.session.commit()
            return jsonify(status="success", paper_id=curr_paper.id)
        elif request.form['op'] == "edit":
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_paper = curr_course.papers.filter_by(id=request.form['paper_id']).first_or_404()
            curr_paper.title = request.form['title']
            curr_paper.about = request.form['content']
            db.session.commit()
            return jsonify(status="success", paper_id=curr_paper.id)
        elif request.form['op'] == 'data':
            curr_paper = Paper.query.filter_by(id=request.form['paper_id']).first_or_404()
            return jsonify(status="success", title=curr_paper.title, content=curr_paper.about)
        else:
            return abort(404)


@admin.route('/course/<int:course_id>/paper/<int:paper_id>/edit/', methods=['GET', 'POST'])
@teacher_login
def paper_edit(course_id, paper_id):
    """ 课程cid 的试卷 pid 对应的题目列表入口页面 """
    if request.method == 'GET':
        curr_cour = Course.query.filter_by(id=course_id).first_or_404()
        curr_paper = curr_cour.papers.filter_by(id=paper_id).first_or_404()
        return render_template('admin/course/question.html', course=curr_cour, paper=curr_paper)
    elif request.method == 'POST':
        # 试题的增删查改
        if os.path.exists(os.path.join(current_app.config['DOWNLOAD_FOLDER'], 'paper%d.pdf' % paper_id)):
            os.remove(os.path.join(current_app.config['DOWNLOAD_FOLDER'], 'paper%d.pdf' % paper_id))
        if request.form['op'] == 'create':
            curr_paper = Paper.query.filter_by(id=paper_id).first_or_404()
            curr_question = Question(type=request.form['type'], content=request.form['content'],
                                     solution=request.form['solution'], analysis=request.form['analysis'])
            aux = PaperQuestion(point=request.form['point'])
            aux.questions = curr_question
            db.session.add(aux)
            curr_paper.questions.append(aux)
            classifies = request.form.getlist('classify')
            for x in classifies:
                curr_question.classifies.append(Classify.query.filter_by(id=x).first_or_404())
            db.session.add(curr_question)
            db.session.commit()
            return redirect(url_for('admin.paper_edit', course_id=curr_paper.course.id, paper_id=curr_paper.id))
        elif request.form['op'] == 'edit':
            curr_paper = Paper.query.filter_by(id=paper_id).first_or_404()
            aux = curr_paper.questions.filter_by(question_id=request.form['question_id']).first_or_404()
            aux.point = request.form['point']
            curr_question = aux.questions
            curr_question.type = request.form['type']
            curr_question.content = request.form['content']
            curr_question.solution = request.form['solution']
            curr_question.analysis = request.form['analysis']
            for x in xrange(len(curr_question.classifies)):
                curr_question.classifies.pop(0)
            classifies = request.form.getlist('classify')
            for x in classifies:
                curr_question.classifies.append(Classify.query.filter_by(id=x).first_or_404())
            db.session.commit()
            return redirect(url_for('admin.paper_edit', course_id=curr_paper.course.id, paper_id=curr_paper.id))
        elif request.form['op'] == 'del':
            curr_paper = Paper.query.filter_by(id=paper_id).first_or_404()
            question_id = request.form.getlist('question_id[]')
            for idx in question_id:
                print idx
                aux = curr_paper.questions.filter_by(question_id=idx).first_or_404()
                curr_paper.questions.remove(aux)
                curr_question = aux.questions
                db.session.delete(curr_question)
                db.session.delete(aux)
            db.session.commit()
            return jsonify(status="success", paper_id=curr_paper.id)
        else:
            return abort(404)


@admin.route('/problem/')
@teacher_login
def problem():
    return render_template('admin/problem/index.html', classify=Classify.query.all(),
                           questions=current_user.teacher_questions,
                           programs=current_user.teacher_program)


@admin.route('/problem/<question_type>/', methods=['GET', 'POST'])
@teacher_login
def question(question_type):
    if request.method == 'GET':
        questions = None
        if question_type == 'choice':
            questions = current_user.teacher_questions.filter(or_(Question.type == 0, Question.type == 1, Question.type == 2))
        elif question_type == 'judge':
            questions = current_user.teacher_questions.filter_by(type=4)
        elif question_type == 'fill':
            questions = current_user.teacher_questions.filter_by(type=3)
        elif question_type == 'essay':
            questions = current_user.teacher_questions.filter_by(type=5)
        return render_template('admin/problem/question.html',
                               title=gettext('Question Manage'),
                               questions=questions,
                               type=question_type)
    elif request.method == 'POST':
        # 删除练习题目
        curr_question = Question.query.filter_by(id=request.form['id']).first_or_404()
        db.session.delete(curr_question)
        db.session.commit()
        return jsonify(status="success", question_id=curr_question.id)


@admin.route('/problem/<question_type>/<int:question_classify>/', methods=['GET', 'POST'])
@teacher_login
def question_filter_by_classify(question_type, question_classify):
    if request.method == 'GET':
        questions = None
        if question_type == 'choice':
            questions = Classify.query.filter_by(id=question_classify).first().questions.filter(or_(Question.type == 0, Question.type == 1, Question.type == 2))
        elif question_type == 'judge':
            questions = Classify.query.filter_by(id=question_classify).first().questions.filter_by(type=4)
        elif question_type == 'fill':
            questions = Classify.query.filter_by(id=question_classify).first().questions.filter_by(type=3)
        elif question_type == 'essay':
            questions = Classify.query.filter_by(id=question_classify).first().questions.filter_by(type=5)
        questions = questions.filter_by(user_id=current_user.id)
        return render_template('admin/problem/question.html',
                               title=gettext('Question Manage'),
                               questions=questions,
                               type=question_type)
    elif request.method == 'POST':
        # 删除练习题目
        curr_question = Question.query.filter_by(id=request.form['id']).first_or_404()
        db.session.delete(curr_question)
        db.session.commit()
        return jsonify(status="success", question_id=curr_question.id)


@admin.route('/problem/program/<int:question_classify>/', methods=['GET', 'POST'])
@teacher_login
def program_filter_by_classify(question_classify):
    """ 题库中编程题的入口页面 """
    if request.method == 'GET':
        return render_template('admin/problem/program.html', title=gettext('Program question'))
    elif request.method == 'POST':
        # 删除编程题目
        curr_program = Program.query.filter_by(id=request.form['id']).first_or_404()
        db.session.delete(curr_program)
        db.session.commit()
        return unicode(curr_program.id)


@admin.route('/problem/<question_type>/create/', methods=['GET', 'POST'])
@teacher_login
def question_create(question_type):
    if request.method == 'GET':
        return render_template('admin/problem/question_detail.html',
                               title=gettext('Edit question'),
                               op='create',
                               classifies=Classify.query.all(),
                               mode='practice',
                               type=question_type)
    elif request.method == 'POST':
        # 添加练习题目
        curr_question = Question(type=request.form['type'], content=request.form['content'],
                                 solution=request.form['solution'], analysis=request.form['analysis'])
        curr_question.teacher = current_user
        classifies = request.form.getlist('classify')
        for x in classifies:
            curr_question.classifies.append(Classify.query.filter_by(id=x).first_or_404())
        db.session.add(curr_question)
        db.session.commit()
        return redirect(url_for('admin.question', question_type=question_type))


@admin.route('/problem/<question_type>/edit/<int:question_id>/', methods=['GET', 'POST'])
@teacher_login
def question_edit(question_type, question_id):
    if request.method == 'GET':
        curr_question = Question.query.filter_by(id=question_id).first_or_404()
        curr_classifies = {}
        index = 0
        for c in curr_question.classifies:
            curr_classifies[index] = c.id
            index += 1
        return render_template('admin/problem/question_detail.html',
                               title=gettext('Edit question'),
                               op='edit',
                               question=curr_question,
                               classifies=Classify.query.all(),
                               mode='practice',
                               type=question_type,
                               curr_classifies=json.dumps(curr_classifies, ensure_ascii=False))
    elif request.method == 'POST':
        # 编辑练习题
        curr_question = Question.query.filter_by(id=request.form['id']).first_or_404()
        curr_question.type = request.form['type']
        curr_question.content = request.form['content']
        curr_question.solution = request.form['solution']
        curr_question.analysis = request.form['analysis']
        for x in xrange(len(curr_question.classifies)):
            curr_question.classifies.pop(0)
        classifies = request.form.getlist('classify')
        for x in classifies:
            curr_question.classifies.append(Classify.query.filter_by(id=x).first_or_404())
        db.session.commit()
        return redirect(url_for('admin.question', question_type=question_type))


@admin.route('/paper/<int:paper_id>/<question_type>/create/', methods=['GET', 'POST'])
@teacher_login
def paper_question_create(paper_id, question_type):
    if request.method == 'GET':
        curr_paper = Paper.query.filter_by(id=paper_id).first_or_404()
        return render_template('admin/problem/question_detail.html',
                               title=gettext('Create question'),
                               op='create',
                               classifies=Classify.query.all(),
                               mode='paper',
                               curr_paper=curr_paper,
                               type=question_type)
    elif request.method == 'POST':
        # 添加试卷题目
        curr_paper = Paper.query.filter_by(id=paper_id).first_or_404()
        curr_question = Question(type=request.form['type'], content=request.form['content'],
                                 solution=request.form['solution'], analysis=request.form['analysis'])
        curr_question.teacher = current_user
        aux = PaperQuestion(point=request.form['point'])
        aux.questions = curr_question
        db.session.add(aux)
        curr_paper.questions.append(aux)
        classifies = request.form.getlist('classify')
        for x in classifies:
            curr_question.classifies.append(Classify.query.filter_by(id=x).first_or_404())
        db.session.add(curr_question)
        db.session.commit()
        return redirect(url_for('admin.paper_edit', course_id=curr_paper.course.id, paper_id=curr_paper.id))


@admin.route('/paper/<int:paper_id>/<question_type>/edit/<int:question_id>/', methods=['GET', 'POST'])
@teacher_login
def paper_question_edit(paper_id, question_type, question_id):
    if request.method == 'GET':
        curr_paper = Paper.query.filter_by(id=paper_id).first_or_404()
        curr_question = curr_paper.questions.filter_by(question_id=question_id).first_or_404()
        curr_classifies = {}
        index = 0
        for c in curr_question.questions.classifies:
            curr_classifies[index] = c.id
            index += 1
        return render_template('admin/problem/question_detail.html',
                               title=gettext('Edit question'),
                               op='edit',
                               question=curr_question.questions,
                               classifies=Classify.query.all(),
                               mode='paper',
                               curr_paper=curr_paper,
                               point=curr_question.point,
                               type=question_type,
                               curr_classifies=json.dumps(curr_classifies, ensure_ascii=False))
    elif request.method == 'POST':
        # 编辑试卷题目
        curr_paper = Paper.query.filter_by(id=request.form['pid']).first_or_404()
        aux = curr_paper.questions.filter_by(question_id=request.form['id']).first_or_404()
        aux.point = request.form['point']
        curr_question = aux.questions
        curr_question.type = request.form['type']
        curr_question.content = request.form['content']
        curr_question.solution = request.form['solution']
        curr_question.analysis = request.form['analysis']
        for x in xrange(len(curr_question.classifies)):
            curr_question.classifies.pop(0)
        classifies = request.form.getlist('classify')
        for x in classifies:
            curr_question.classifies.append(Classify.query.filter_by(id=x).first_or_404())
        db.session.commit()
        return redirect(url_for('admin.paper_edit', course_id=curr_paper.course.id, paper_id=curr_paper.id))


@admin.route('/problem/program/', methods=['GET', 'POST'])
@teacher_login
def program():
    """ 题库中编程题的入口页面 """
    if request.method == 'GET':
        return render_template('admin/problem/program.html', title=gettext('Program question'))
    elif request.method == 'POST':
        # 删除编程题目
        curr_program = Program.query.filter_by(id=request.form['id']).first_or_404()
        db.session.delete(curr_program)
        db.session.commit()
        return unicode(curr_program.id)


@admin.route('/problem/program/create/', methods=['GET', 'POST'])
@teacher_login
def program_create():
    """ 在题库添加编程题 """
    if request.method == 'GET':
        return render_template('admin/problem/program_detail.html',
                               title=gettext('Create question'),
                               op='create')
    elif request.method == 'POST':
        # 添加编程题
        curr_program = Program(title=request.form['title'], detail=request.form['content'])
        curr_program.teacher = current_user
        db.session.add(curr_program)
        db.session.commit()
        return redirect(url_for('admin.program'))


@admin.route('/problem/program/edit/', methods=['GET', 'POST'])
@teacher_login
def program_edit():
    """ 题库中编程题目的编辑页面 """
    if request.method == 'GET':
        curr_program = Program.query.filter_by(id=request.args['id']).first_or_404()
        return render_template('admin/problem/program_detail.html',
                               title=gettext('Edit question'),
                               op='edit',
                               program_problem=curr_program)
    elif request.method == 'POST':
        # 编辑编程题
        curr_program = Program.query.filter_by(id=request.form['id']).first_or_404()
        curr_program.title = request.form['title']
        curr_program.detail = request.form['content']
        db.session.commit()
        return redirect(url_for('admin.program'))


@admin.route('/lab/', methods=['GET', 'POST'])
@teacher_login
def lab():
    if request.method == 'GET':
        return render_template('admin/lab/index.html',
                               title=gettext('Lab Manage'))
    elif request.method == 'POST':
        if request.form['op'] == 'create':
            curr_knowledge = Knowledge(title=request.form['title'], content=request.form['content'])
            curr_knowledge.teacher = current_user
            db.session.add(curr_knowledge)
            db.session.commit()
            return jsonify(status='success')
        elif request.form['op'] == 'edit':
            curr_knowledge = Knowledge.query.filter_by(id=request.form['knowledge_id']).first_or_404()
            curr_knowledge.title = request.form['title']
            curr_knowledge.content = request.form['content']
            db.session.commit()
            return jsonify(status='success')
        elif request.form['op'] == 'del':
            curr_knowledge = Knowledge.query.filter_by(id=request.form['knowledge_id']).first_or_404()
            for challenge in curr_knowledge.challenges:
                db.session.delete(challenge)
            db.session.delete(curr_knowledge)
            db.session.commit()
            return jsonify(status='success')


@admin.route('/lab/<int:knowledge_id>/', methods=['GET', 'POST'])
@teacher_login
def lab_view(knowledge_id):
    if request.method == 'GET':
        curr_knowledge = Knowledge.query.filter_by(id=knowledge_id).first_or_404()
        return render_template('admin/lab/knowledge.html',
                               title=gettext('Lab tasks'),
                               knowledge=curr_knowledge)
    elif request.method == 'POST':
        # 删除任务以及调整顺序
        if request.form['op'] == 'del':
            curr_challenge = Challenge.query.filter_by(id=request.form['challenge_id']).first_or_404()
            curr_knowledge = Knowledge.query.filter_by(id=knowledge_id).first_or_404()
            curr_knowledge.challenges.remove(curr_challenge)
            for x in curr_knowledge.challenges:
                if x.knowledgeNum >= curr_challenge.knowledgeNum:
                    x.knowledgeNum -= 1
            db.session.delete(curr_challenge)
            db.session.commit()
            return jsonify(status='success')
        elif request.form['op'] == 'seq':
            print(request.form)
            curr_knowledge = Knowledge.query.filter_by(id=knowledge_id).first_or_404()
            seq = json.loads(request.form['seq'])
            for x in curr_knowledge.challenges:
                x.knowledgeNum = seq[str(x.id)]
            db.session.commit()
            return jsonify(status='success')


@admin.route('/lab/<int:knowledge_id>/create/', methods=['GET', 'POST'])
@teacher_login
def lab_create(knowledge_id):
    if request.method == 'GET':
        curr_knowledge = Knowledge.query.filter_by(id=knowledge_id).first_or_404()
        materials = []
        for c in current_user.teacher_courses:
            for l in c.lessons:
                for m in l.materials:
                    materials.append(m)
        return render_template('admin/lab/knowledge_detail.html',
                               title=gettext('Lab Create'),
                               op='create',
                               knowledge=curr_knowledge,
                               materials=materials)
    elif request.method == 'POST':
        # 创建任务
        curr_knowledge = Knowledge.query.filter_by(id=knowledge_id).first_or_404()
        curr_challenge = Challenge(title=request.form['title'], content=request.form['content'],
                                   source_code=request.form['source_code'], default_code=request.form['default_code'])
        curr_challenge.knowledgeNum = curr_knowledge.challenges.count() + 1
        db.session.add(curr_challenge)
        curr_knowledge.challenges.append(curr_challenge)

        if int(request.form['material_id']) != -1:
            curr_material = Material.query.filter_by(id=request.form['material_id']).first_or_404()
            curr_material.challenges.append(curr_challenge)

        db.session.commit()
        return jsonify(status='success', challenge_id=curr_challenge.id)


@admin.route('/lab/<int:knowledge_id>/edit/<int:challenge_id>/', methods=['GET', 'POST'])
@teacher_login
def lab_edit(knowledge_id, challenge_id):
    if request.method == 'GET':
        curr_knowledge = Knowledge.query.filter_by(id=knowledge_id).first_or_404()
        curr_challenge = Challenge.query.filter_by(id=challenge_id).first_or_404()
        materials = []
        for c in current_user.teacher_courses:
            for l in c.lessons:
                for m in l.materials:
                    materials.append(m)
        return render_template('admin/lab/knowledge_detail.html',
                               title=gettext('Lab Edit'),
                               op='edit', knowledge=curr_knowledge,
                               challenge=curr_challenge,
                               materials=materials)
    elif request.method == 'POST':
        if 'op' in request.form:
            if request.form['op'] == 'get_code':
                curr_challenge = Challenge.query.filter_by(id=challenge_id).first_or_404()
                return jsonify(status='success', default_code=curr_challenge.default_code,
                               source_code=curr_challenge.source_code)
        else:
            # 编辑任务
            curr_challenge = Challenge.query.filter_by(id=challenge_id).first_or_404()
            curr_challenge.title = request.form['title']
            curr_challenge.content = request.form['content']
            curr_challenge.source_code = request.form['source_code']
            curr_challenge.default_code = request.form['default_code']

            if int(request.form['material_id']) != -1:
                curr_challenge.material.challenges.remove(curr_challenge)
                curr_material = Material.query.filter_by(id=request.form['material_id']).first_or_404()
                curr_material.challenges.append(curr_challenge)

            db.session.commit()
            return jsonify(status="success")


@admin.route('/download/paper/<int:paper_id>/')
@teacher_login
def paper_pdf(paper_id):
    path = get_paper_pdf(paper_id)
    response = make_response(send_file(path))
    response.headers["Content-Disposition"] = "attachment; filename=%s;" % path[path.rfind('/')+1:]
    return response


@admin.route("/classifies/", methods=['GET', 'POST'])
@teacher_login
def classify():
    if request.method == 'GET':
        classifies = Classify.query.all()
        return render_template('admin/classify/index.html',
                               title=gettext("Classify Admin"),
                               classifies=classifies)
    elif request.method == 'POST':
        if request.form['op'] == 'create':
            new_classify = Classify(name=request.form['cname'])
            db.session.add(new_classify)
            db.session.commit()
            return jsonify(status='success')
        elif request.form['op'] == 'edit':
            cur_classify = Classify.query.filter_by(id=request.form['cid']).first_or_404()
            cur_classify.name = request.form['cname']
            db.session.commit()
            return jsonify(status='success')
        elif request.form['op'] == 'del':
            cur_classify = Classify.query.filter_by(id=request.form['cid']).first_or_404()
            db.session.delete(cur_classify)
            db.session.commit()
            return jsonify(status='success')
