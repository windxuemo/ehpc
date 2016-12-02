#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, request, redirect, url_for, abort, jsonify, current_app
from ..user.authorize import admin_login, teacher_login
from . import admin
from ..models import Course, Lesson, Material, User, Article
from ..models import Classify, Program, Paper, Question, PaperQuestion
from ..models import Knowledge, Challenge
from .. import db
import os, json
from flask_babel import gettext
from ..util.file_manage import upload_img, upload_file, get_file_type, custom_secure_filename
from sqlalchemy import or_


@admin.route('/course/', methods=['GET', 'POST'])
@teacher_login
def course():
    if request.method == 'GET':
        return render_template('admin/course/index.html',
                               title=gettext('Course Admin'),
                               courses=Course.query.all())
    elif request.method == 'POST':
        # 删除课程
        curr_course = Course.query.filter_by(id=request.form['course_id']).first_or_404()
        for l in curr_course.lessons:
            for m in l.materials:
                os.remove(os.path.join(current_app.config['RESOURCE_FOLDER'], m.uri))
                db.session.delete(m)
            db.session.delete(l)
        if os.path.exists(os.path.join(current_app.config['RESOURCE_FOLDER'], 'course_%d' % curr_course.id)):
            os.rmdir(os.path.join(current_app.config['RESOURCE_FOLDER'], 'course_%d' % curr_course.id))
        if os.path.exists(os.path.join(current_app.config['COURSE_COVER_FOLDER'], 'cover_%d.png' % curr_course.id)):
            os.remove(os.path.join(current_app.config['COURSE_COVER_FOLDER'], 'cover_%d.png' % curr_course.id))
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
                             lessonNum=0, smallPicture='images/course/noImg.jpg')
        db.session.add(curr_course)
        db.session.commit()
        os.makedirs(os.path.join(current_app.config['RESOURCE_FOLDER'], 'course_%d' % curr_course.id))
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
        if request.form['op'] == 'save':
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_course.smallPicture = os.path.join('images/course', "cover_%d.png" % curr_course.id)
            db.session.commit()
            return jsonify(status='success', id=curr_course.id)
        elif request.form['op'] == 'upload':
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            filename = "cover_%d.png" % curr_course.id
            cover_path = os.path.join(current_app.config['COURSE_COVER_FOLDER'], filename)
            status = upload_img(request.files['pic'], 171, 304, cover_path)
            if status[0]:
                return jsonify(status='success', uri=os.path.join('/static/images/course', filename))
            else:
                return jsonify(status="fail", id=curr_course.id)


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


@admin.route('/course/<int:course_id>/lesson/<int:lesson_id>/material/reload_lesson')
@teacher_login
def reload_material(course_id,lesson_id):
    """ 重载课时表 """
    materials=Material.query.filter_by(lessonId=lesson_id).all()
    return render_template('admin/course/widget_material_list.html',materials=materials)


# 本地文件上传
@admin.route('/course/<int:course_id>/lesson/<int:lesson_id>/material/upload', methods=['POST'])
@teacher_login
def upload(course_id,lesson_id):
    cur_course = Course.query.filter_by(id=course_id).first_or_404()
    cur_lesson = cur_course.lessons.filter_by(id=lesson_id).first_or_404()
    filename=custom_secure_filename(request.form['name'])
    file=request.files['file']
    file_type = get_file_type(file.mimetype)  
    filename= filename.encode("utf-8")
    m = Material(name=filename, m_type=file_type, uri="")
    cur_lesson.materials.append(m)
    db.session.commit()  # get material id
    m.uri = os.path.join("course_%d" % course_id,
                             "lesson%d_material%d." % (lesson_id, m.id) + file.filename.rsplit('.', 1)[1])
    status = upload_file(file, os.path.join(current_app.config['RESOURCE_FOLDER'], m.uri))
    if status[0]:
        db.session.commit()
    else:
        cur_lesson.materials.remove(m)
        db.session.delete(m)
        db.session.commit()

    return render_template('admin/course/upload.html')


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
        if request.form['op'] == "upload":
            curr_course = Course.query.filter_by(id=course_id).first_or_404()
            curr_lesson = curr_course.lessons.filter_by(id=lesson_id).first_or_404()
            if request.form['link-type'] == "origin":
                m_link = request.form['file-link']
                m_name = request.form['file-name']
                m_type = request.form['file-type']
                curr_material = Material(name=m_name, m_type=m_type, uri=m_link)
                db.session.add(curr_material)
                curr_lesson.materials.append(curr_material)
                db.session.commit()  # get material id
                return jsonify(status="success", id=curr_lesson.id)
            
        elif request.form['op'] == "del":
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
    return redirect(url_for("admin.question", question_type='choice'))


@admin.route('/problem/<question_type>/', methods=['GET', 'POST'])
@teacher_login
def question(question_type):
    if request.method == 'GET':
        questions = None
        if question_type == 'choice':
            questions = Question.query.filter(or_(Question.type == 0, Question.type == 1, Question.type == 2))
        elif question_type == 'judge':
            questions = Question.query.filter_by(type=4)
        elif question_type == 'fill':
            questions = Question.query.filter_by(type=3)
        elif question_type == 'essay':
            questions = Question.query.filter_by(type=5)
        return render_template('admin/problem/question.html',
                               questions=questions,
                               type=question_type)
    elif request.method == 'POST':
        # 删除练习题目
        curr_question = Question.query.filter_by(id=request.form['id']).first_or_404()
        db.session.delete(curr_question)
        db.session.commit()
        return jsonify(status="success", question_id=curr_question.id)


@admin.route('/problem/<question_type>/create/', methods=['GET', 'POST'])
@teacher_login
def question_create(question_type):
    if request.method == 'GET':
        return render_template('admin/problem/question_detail.html',
                               op='create',
                               classifies=Classify.query.all(),
                               mode='practice',
                               type=question_type)
    elif request.method == 'POST':
        # 添加练习题目
        curr_question = Question(type=request.form['type'], content=request.form['content'],
                                 solution=request.form['solution'], analysis=request.form['analysis'])
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
        return render_template('admin/problem/program.html', programs=Program.query.all())
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
        return render_template('admin/problem/program_detail.html', op='create')
    elif request.method == 'POST':
        # 添加编程题
        curr_program = Program(title=request.form['title'], detail=request.form['content'])
        db.session.add(curr_program)
        db.session.commit()
        return redirect(url_for('admin.program'))


@admin.route('/problem/program/edit/', methods=['GET', 'POST'])
@teacher_login
def program_edit():
    """ 题库中编程题目的编辑页面 """
    if request.method == 'GET':
        curr_program = Program.query.filter_by(id=request.args['id']).first_or_404()
        return render_template('admin/problem/program_detail.html', op='edit', program_problem=curr_program)
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
    curr_knowledge = Knowledge.query.first_or_404()
    return redirect(url_for('admin.lab_view', knowledge_id=curr_knowledge.id))


@admin.route('/lab/<int:knowledge_id>/', methods=['GET', 'POST'])
@teacher_login
def lab_view(knowledge_id):
    if request.method == 'GET':
        curr_knowledge = Knowledge.query.filter_by(id=knowledge_id).first_or_404()
        knows = Knowledge.query.all()
        return render_template('admin/lab/index.html', knowledge=curr_knowledge, knows=knows)
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
        materials = Material.query.all()
        questions = Question.query.all()
        programs = Program.query.all()
        return render_template('admin/lab/detail.html', op='create', knowledge=curr_knowledge,
                               materials=materials, questions=questions, programs=programs)
    elif request.method == 'POST':
        # 创建任务
        curr_knowledge = Knowledge.query.filter_by(id=knowledge_id).first_or_404()
        curr_challenge = Challenge(title=request.form['title'], content=request.form['content'])
        curr_challenge.question_type = int(request.form['question_type'])
        curr_challenge.knowledgeNum = curr_knowledge.challenges.count() + 1
        db.session.add(curr_challenge)
        curr_knowledge.challenges.append(curr_challenge)

        if int(request.form['question_type']) != 6:
            curr_question = Question.query.filter_by(id=request.form['question_id']).first_or_404()
            curr_question.challenges.append(curr_challenge)
        else:
            curr_program = Program.query.filter_by(id=request.form['question_id']).first_or_404()
            curr_program.challenges.append(curr_challenge)

        if request.form['material_id'] != -1:
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
        materials = Material.query.all()
        questions = Question.query.all()
        programs = Program.query.all()
        return render_template('admin/lab/detail.html', op='edit', knowledge=curr_knowledge, challenge=curr_challenge,
                               materials=materials, questions=questions, programs=programs)
    elif request.method == 'POST':
        # 编辑任务
        curr_challenge = Challenge.query.filter_by(id=challenge_id).first_or_404()
        curr_challenge.title = request.form['title']
        curr_challenge.content = request.form['content']
        curr_challenge.question_type = int(request.form['question_type'])

        if curr_challenge.question_type != 6:
            curr_challenge.question.challenges.remove(curr_challenge)
        else:
            curr_challenge.program.challenges.remove(curr_challenge)
        if int(request.form['question_type']) != 6:
            curr_question = Question.query.filter_by(id=request.form['question_id']).first_or_404()
            curr_question.challenges.append(curr_challenge)
        else:
            curr_program = Program.query.filter_by(id=request.form['question_id']).first_or_404()
            curr_program.challenges.append(curr_challenge)

        if request.form['material_id'] != -1:
            curr_challenge.material.challenges.remove(curr_challenge)
            curr_material = Material.query.filter_by(id=request.form['material_id']).first_or_404()
            curr_material.challenges.append(curr_challenge)

        db.session.commit()
        return jsonify(status="success")
