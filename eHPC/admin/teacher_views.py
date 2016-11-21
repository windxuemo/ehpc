#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, request, redirect, url_for, abort, jsonify, current_app
from ..user.authorize import admin_login, teacher_login
from . import admin
from ..models import Course, Lesson, Material, User, Article
from ..models import Classify, Program, Paper, Question, PaperQuestion
from .. import db
import os, json
from flask_babel import gettext
from flask import current_app
from ..util.file_manage import upload_img, upload_file, get_file_type, custom_secure_filename
from sqlalchemy import or_


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


@admin.route('/course/<int:cid>/paper/')
@teacher_login
def course_paper(cid):
    """ 课程cid 的试卷管理入口页面 """
    curr_cour = Course.query.filter_by(id=cid).first_or_404()
    return render_template('admin/course/paper.html', cour=curr_cour,
                           papers=curr_cour.papers,
                           title=gettext('Course Paper'))


@admin.route('/course/<int:cid>/paper/<int:pid>/edit/')
@teacher_login
def paper_edit(cid, pid):
    """ 课程cid 的试卷 pid 对应的题目列表入口页面 """
    curr_cour = Course.query.filter_by(id=cid).first_or_404()
    curr_paper = curr_cour.papers.filter_by(id=pid).first_or_404()
    return render_template('admin/course/question.html', course=curr_cour, paper=curr_paper)


@admin.route('/problem/')
@teacher_login
def problem():
    return redirect(url_for("admin.question", q_type='choice'))


@admin.route('/problem/<q_type>')
@teacher_login
def question(q_type):
    if q_type == 'choice':
        choices = Question.query.filter(or_(Question.type == 0, Question.type == 1, Question.type == 2))
        return render_template('admin/problem/question.html',
                               questions=choices,
                               type='choice')

    elif q_type == 'judge':
        judges = Question.query.filter_by(type=4)
        return render_template('admin/problem/question.html',
                               questions=judges,
                               type='judge')

    elif q_type == 'fill':
        fills = Question.query.filter_by(type=3)
        return render_template('admin/problem/question.html',
                               questions=fills,
                               type='fill')

    elif q_type == 'essay':
        essays = Question.query.filter_by(type=5)
        return render_template('admin/problem/question.html',
                               questions=essays,
                               type='essay')


@admin.route('/problem/<q_type>/create/')
@teacher_login
def question_create(q_type):
    if q_type == 'choice':
        return render_template('admin/problem/question_detail.html',
                               classifies=Classify.query.all(),
                               op='create',
                               mode='practice',
                               type='choice')
    elif q_type == 'judge':
        return render_template('admin/problem/question_detail.html',
                               op='create',
                               classifies=Classify.query.all(),
                               mode='practice',
                               type='judge')

    elif q_type == 'fill':
        return render_template('admin/problem/question_detail.html',
                               op='create',
                               classifies=Classify.query.all(),
                               mode='practice',
                               type='fill')

    elif q_type == 'essay':
        return render_template('admin/problem/question_detail.html',
                               op='create',
                               classifies=Classify.query.all(),
                               mode='practice',
                               type='essay')


@admin.route('/problem/<q_type>/edit/<int:qid>')
@teacher_login
def question_edit(q_type, qid):

    curr_question = Question.query.filter_by(id=qid).first_or_404()
    curr_classifies = {}

    index = 0
    for c in curr_question.classifies:
        curr_classifies[index] = c.id
        index += 1

    if q_type == 'choice':
        return render_template('admin/problem/question_detail.html',
                               op='edit',
                               classifies=Classify.query.all(),
                               question=curr_question,
                               mode='practice',
                               type='choice',
                               curr_classifies=json.dumps(curr_classifies, ensure_ascii=False))

    elif q_type == 'judge':
        return render_template('admin/problem/question_detail.html',
                               op='edit',
                               question=curr_question,
                               classifies=Classify.query.all(),
                               mode='practice',
                               type='judge',
                               curr_classifies=json.dumps(curr_classifies, ensure_ascii=False))

    elif q_type == 'fill':
        return render_template('admin/problem/question_detail.html',
                               op='edit',
                               question=curr_question,
                               classifies=Classify.query.all(),
                               mode='practice',
                               type='fill',
                               curr_classifies=json.dumps(curr_classifies, ensure_ascii=False))

    elif q_type == 'essay':
        return render_template('admin/problem/question_detail.html',
                               op='edit',
                               question=curr_question,
                               classifies=Classify.query.all(),
                               mode='practice',
                               type='essay',
                               curr_classifies=json.dumps(curr_classifies, ensure_ascii=False))


@admin.route('/problem/program/')
@teacher_login
def program():
    """ 题库中编程题的入口页面 """
    programs = Program.query.all()
    return render_template('admin/problem/program.html', programs=programs)


@admin.route('/problem/program/create/')
@teacher_login
def program_create():
    """ 在题库添加编程题 """
    return render_template('admin/problem/program_detail.html', op='create')


@admin.route('/problem/program/edit/')
@teacher_login
def program_edit():
    """ 题库中编程题目的编辑页面 """
    program_problem = Program.query.filter_by(id=request.args['id']).first_or_404()
    return render_template('admin/problem/program_detail.html', op='edit', program_problem=program_problem)


@admin.route('/paper/<int:pid>/<q_type>/create/')
@teacher_login
def paper_question_create(pid, q_type):
    curr_paper = Paper.query.filter_by(id=pid).first_or_404()
    if q_type == 'choice':
        return render_template('admin/problem/question_detail.html',
                               op='create',
                               classifies=Classify.query.all(),
                               mode='paper',
                               curr_paper=curr_paper,
                               type='choice')
    elif q_type == 'judge':
        return render_template('admin/problem/question_detail.html',
                               op='create',
                               classifies=Classify.query.all(),
                               mode='paper',
                               curr_paper=curr_paper,
                               type='judge')

    elif q_type == 'fill':
        return render_template('admin/problem/question_detail.html',
                               op='create',
                               classifies=Classify.query.all(),
                               mode='paper',
                               curr_paper=curr_paper,
                               type='fill')

    elif q_type == 'essay':
        return render_template('admin/problem/question_detail.html',
                               op='create',
                               classifies=Classify.query.all(),
                               mode='paper',
                               curr_paper=curr_paper,
                               type='essay')


@admin.route('/paper/<int:pid>/<q_type>/edit/<qid>/')
@teacher_login
def paper_question_edit(pid, q_type, qid):
    curr_paper = Paper.query.filter_by(id=pid).first_or_404()
    curr_question = curr_paper.questions.filter_by(question_id=qid).first_or_404()

    curr_classifies = []
    for c in curr_question.classifies:
        curr_classifies.append(c.id)
    print(curr_classifies)

    if q_type == 'choice':
        return render_template('admin/problem/question_detail.html',
                               op='edit',
                               question=curr_question.questions,
                               classifies=Classify.query.all(),
                               mode='paper',
                               curr_paper=curr_paper,
                               point=curr_question.point,
                               type='choice',
                               curr_classifies=curr_classifies)

    if q_type == 'judge':
        return render_template('admin/problem/question_detail.html',
                               op='edit',
                               curr_judge=curr_question.questions,
                               classifies=Classify.query.all(),
                               mode='paper',
                               curr_paper=curr_paper,
                               point=curr_question.point,
                               type='judge',
                               curr_classifies=curr_classifies)

    if q_type == 'fill':
        return render_template('admin/problem/question_detail.html',
                               op='edit',
                               curr_fill=curr_question.questions,
                               classifies=Classify.query.all(),
                               mode='paper',
                               curr_paper=curr_paper,
                               point=curr_question.point,
                               type='fill',
                               curr_classifies=curr_classifies)

    if q_type == 'essay':
        return render_template('admin/problem/question_detail.html',
                               op='edit',
                               curr_essay=curr_question.questions,
                               classifies=Classify.query.all(),
                               mode='paper',
                               curr_paper=curr_paper,
                               point=curr_question.point,
                               type='essay',
                               curr_classifies=curr_classifies)


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
        if os.path.exists(os.path.join(current_app.config['COURSE_COVER_FOLDER'], 'cover_%d.png' % cur_course.id)):
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
        if request.form['link-type'] == "origin":
            m_link = request.form['file-link']
            m_name = request.form['file-name']
            m_type = request.form['file-type']
            m = Material(name=m_name,m_type=m_type,uri=m_link)
            cur_lesson.materials.append(m)
            db.session.commit()  # get material id
            return jsonify(status="success", id=cur_lesson.id)

        else:
            cur_material = request.files['file']
            if not cur_material:
                return jsonify(status="fail", id=cur_lesson.id, info=u"文件为空")

            filename = custom_secure_filename(cur_material.filename)
            file_type = get_file_type(cur_material.mimetype)
            m = Material(name=filename, m_type=file_type, uri="")
            cur_lesson.materials.append(m)
            db.session.commit()  # get material id
            m.uri = os.path.join("course_%d" % cur_course.id,
                             "lesson%d_material%d." % (cur_lesson.id, m.id) + cur_material.filename.rsplit('.', 1)[1])
        
            status = upload_file(cur_material, os.path.join(current_app.config['RESOURCE_FOLDER'], m.uri))
            if status[0]:
                db.session.commit()
                return jsonify(status="success", id=cur_lesson.id)
            else:
                cur_lesson.materials.remove(m)
                db.session.delete(m)
                db.session.commit()
                return jsonify(status="fail", id=cur_lesson.id, info=status[1])

    elif request.form['op'] == "del":
        cur_course = Course.query.filter_by(id=request.form['id']).first_or_404()
        cur_lesson = cur_course.lessons.filter_by(id=request.form['lid']).first_or_404()
        seq = request.form.getlist('seq[]')
        for x in seq:
            m = cur_lesson.materials.filter_by(id=x).first()
            if not m:
                return jsonify(status="fail", id=cur_lesson.id)
            # 需要在课时对象中删除该资源
            cur_lesson.materials.remove(m)
            db.session.delete(m)
            db.session.commit()

            try:
                os.remove(os.path.join(current_app.config['RESOURCE_FOLDER'], m.uri))
            except OSError:
                pass

        return jsonify(status="success", id=cur_lesson.id)

    else:
        return abort(404)


@admin.route('/process/practice/', methods=['POST'])
@teacher_login
def process_practice():
    if request.form['op'] == 'create':
        curr_question = Question(type=request.form['type'], content=request.form['content'],
                                 solution=request.form['solution'], analysis=request.form['analysis'])

        classifies = request.form.getlist('classify')
        for x in classifies:
            curr_question.classifies.append(Classify.query.filter_by(id=x).first_or_404())

        db.session.add(curr_question)
        db.session.commit()
        return redirect(url_for('admin.' + request.referrer.split('/')[-3]))
    elif request.form['op'] == 'edit':
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
        return redirect(url_for('admin.' + request.referrer.split('/')[-4]))
    elif request.form['op'] == 'del':
        curr_question = Question.query.filter_by(id=request.form['id']).first_or_404()
        db.session.delete(curr_question)
        db.session.commit()
        return jsonify(status="success", id=curr_question.id)
    else:
        return abort(404)


@admin.route('/process/paper/', methods=['POST'])
@teacher_login
def process_paper():
    if request.form['op'] == 'create':
        curr_paper = Paper(title=request.form['title'], about=request.form['content'])
        curr_course = Course.query.filter_by(id=request.form['cid']).first_or_404()
        curr_course.papers.append(curr_paper)
        db.session.add(curr_paper)
        db.session.commit()
        return jsonify(status="success", id=curr_paper.id)
    elif request.form['op'] == "del":
        curr_course = Course.query.filter_by(id=request.form['cid']).first_or_404()
        curr_paper = curr_course.papers.filter_by(id=request.form['pid']).first_or_404()
        curr_course.papers.remove(curr_paper)
        db.session.delete(curr_paper)
        db.session.commit()
        return jsonify(status="success", id=curr_paper.id)
    elif request.form['op'] == "edit":
        curr_course = Course.query.filter_by(id=request.form['cid']).first_or_404()
        curr_paper = curr_course.papers.filter_by(id=request.form['pid']).first_or_404()
        curr_paper.title = request.form['title']
        curr_paper.about = request.form['content']
        db.session.commit()
        return jsonify(status="success", id=curr_paper.id)
    elif request.form['op'] == 'data':
        curr_paper = Paper.query.filter_by(id=request.form['pid']).first_or_404()
        return jsonify(title=curr_paper.title, content=curr_paper.about)
    else:
        return abort(404)


@admin.route('/process/question/', methods=['POST'])
@teacher_login
def process_question():
    if request.form['op'] == 'create':
        curr_paper = Paper.query.filter_by(id=request.form['pid']).first_or_404()
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
        return redirect(url_for('admin.paper_edit', cid=curr_paper.course.id, pid=curr_paper.id))
    elif request.form['op'] == 'edit':
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

        return redirect(url_for('admin.paper_edit', cid=curr_paper.course.id, pid=curr_paper.id))
    elif request.form['op'] == 'del':
        curr_paper = Paper.query.filter_by(id=request.form['pid']).first_or_404()
        seq = request.form.getlist('seq[]')
        for x in seq:
            aux = curr_paper.questions.filter_by(question_id=x).first_or_404()
            curr_paper.questions.remove(aux)
            curr_question = aux.questions
            db.session.delete(curr_question)
            db.session.delete(aux)
        db.session.commit()
        return jsonify(status="success", id=curr_paper.id)
    else:
        return abort(404)


@admin.route('/process/program/', methods=['POST'])
@teacher_login
def process_program():
    if request.form['op'] == 'del':
        program_to_del = Program.query.filter_by(id=request.form['id']).first_or_404()
        db.session.delete(program_to_del)
        db.session.commit()
        return unicode(program_to_del.id)
    elif request.form['op'] == 'create':
        program_to_create = Program(title=request.form['title'], detail=request.form['content'])
        db.session.add(program_to_create)
        db.session.commit()
        return redirect(url_for('admin.program'))
    elif request.form['op'] == 'edit':
        program_to_edit = Program.query.filter_by(id=request.form['id']).first_or_404()
        program_to_edit.title = request.form['title']
        program_to_edit.detail = request.form['content']
        db.session.commit()
        return redirect(url_for('admin.program'))
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
