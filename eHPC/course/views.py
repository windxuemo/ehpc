#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, jsonify, request
from . import course
from ..models import Course, Material, Paper, Question, Comment, User
from flask_babel import gettext
from flask_login import current_user, login_required
from ..course.course_util import student_not_in_course, student_in_course
from ..user.authorize import student_login
from .. import db
import json
from datetime import datetime


@course.route('/')
def index():
    all_courses = Course.query.all()
    return render_template('course/index.html', title=gettext('Courses'), courses=all_courses)


@course.route('/<int:cid>/')
def view(cid):
    c = Course.query.filter_by(id=cid).first()
    # 指定显示的 Tab 选项卡
    tab = request.args.get('tab', None)
    if not tab:
        tab = "about"

    paper_of_course = c.papers.all()

    return render_template('course/detail.html',
                           title=c.title,
                           tab=tab,
                           course=c,
                           user=current_user,
                           papers=paper_of_course)


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
@login_required
def material(mid):
    cur_material = Material.query.filter_by(id=mid).first()
    cur_lesson = cur_material.lesson
    cur_course = cur_lesson.course
    return render_template('course/player.html',
                           type=cur_material.m_type,
                           title=cur_material.name,
                           cur_course=cur_course,
                           cur_material=cur_material)


@course.route('/material/', methods=['POST'])
@login_required
def get_material_src():
    if request.form['op'] == "type":
        cur_material = Material.query.filter_by(id=request.form['id']).first_or_404()
        if cur_material:
            return jsonify(status='success', type=cur_material.m_type, uri=cur_material.uri)
        else:
            return jsonify(status='fail')


# API to get all lessons info contained in the course
@course.route('/<int:cid>/lessons/')
def detail_lessons(cid):
    c = Course.query.filter_by(id=cid).first()
    all_lessons = c.lessons
    html_content = render_template('course/widget_detail_lessons.html', lessons=all_lessons)
    return jsonify(data=html_content)


@course.route('/paper/<int:pid>/show/')
def paper_detail(pid):
    paper = Paper.query.filter_by(id=pid).first_or_404()
    head_id = ['head-single', 'head-multiple', 'head-uncertain', 'head-fill', 'head-judge', 'head-essay']
    name = [u'单选题', u'多选题', u'不定项选择', u'填空题', u'判断题', u'问答题']
    div_id = ['question-single-choice', 'question-multiple-choice', 'question-uncertain-choice',
              'question-fill', 'question-judge', 'question-essay']
    return render_template('course/paper_detail.html', paper=paper, head_id=head_id, name=name, div_id=div_id)


@course.route('/paper/<int:pid>/result/', methods=['POST'])
def paper_result(pid):
    result = {}
    correct_num = [0, 0, 0, 0, 0, 0]    # 分别代表6种题型的【答对数】
    solution = {}
    paper = Paper.query.filter_by(id=pid).first_or_404()
    your_solution = request.form
    for key, value in your_solution.items():
        sol = ""
        q_type = -1
        for i in paper.questions:
            if i.question_id == int(key):
                if i.questions.type == 5:   # 问答题暂时不做处理
                    solution[key] = i.questions.solution
                    q_type = 5
                else:
                    sol = i.questions.solution   # 题目答案
                    q_type = i.questions.type

                    if i.questions.type == 3:   # 填空题答案使用json格式储存，先解析再发送(0-单选 1-多选 2-不定项 3-填空 4-判断 5-问答)
                        ts = json.loads(sol)
                        temp = []
                        for j in range(ts['len']):
                            temp.append(ts[str(j)])
                        sol = ";".join(temp)
                        solution[key] = sol
                    elif i.questions.type == 4:
                        solution[key] = u"正确" if sol == 1 else u"错误"
                    else:
                        solution[key] = sol
                    break

        if q_type != 5 and value == sol:
            result[key] = 'T'
            correct_num[q_type] += 1
        elif q_type != 5:
            result[key] = 'F'
    print result
    return jsonify(status='success', result=result, correct_num=correct_num, solution=solution)


@course.route('/process/comment/', methods=['POST'])
def process_comment():
    if request.form['op'] == 'create':
        curr_course = Course.query.filter_by(id=request.form['courseId']).first_or_404()
        if current_user.is_anonymous or current_user not in curr_course.users:
            return jsonify(status='fail', info=u'用户未登录或未加入该课程')
        curr_comment = Comment(rank=request.form['rank'], content=request.form['content'])
        db.session.add(curr_comment)
        curr_course.rank = (curr_course.rank * curr_course.comments.count() + int(request.form['rank'])) / (curr_course.comments.count() + 1)
        curr_course.comments.append(curr_comment)
        current_user.comments.append(curr_comment)
        current_user.commentNum += 1
        db.session.commit()
        return jsonify(status='success', rank=curr_course.rank,
                       html=render_template('course/widget_course_comment.html', course=curr_course, user=current_user))
    elif request.form['op'] == 'edit':
        curr_course = Course.query.filter_by(id=request.form['courseId']).first_or_404()
        if current_user.is_anonymous or current_user not in curr_course.users:
            return jsonify(status='fail', info=u'用户未登录或未加入该课程')
        curr_comment = current_user.comments.filter_by(courseId=request.form['courseId']).first_or_404()
        curr_course.rank = (curr_course.rank * curr_course.comments.count() - curr_comment.rank + int(request.form['rank'])) / curr_course.comments.count()
        curr_comment.rank = request.form['rank']
        curr_comment.content = request.form['content']
        curr_comment.createdTime = datetime.now()
        db.session.commit()
        return jsonify(status='success', rank=curr_course.rank,
                       html=render_template('course/widget_course_comment.html', course=curr_course, user=current_user))
    elif request.form['op'] == 'data':
        curr_course = Course.query.filter_by(id=request.form['cid']).first_or_404()
        commented = False
        content = ""
        rank = 0
        auth = current_user.is_authenticated and current_user in curr_course.users
        if current_user.is_authenticated:
            commented = current_user.comments.filter_by(courseId=request.form['cid']).count() > 0
            content = current_user.comments.filter_by(courseId=request.form['cid']).first().content if commented else ""
            rank = current_user.comments.filter_by(courseId=request.form['cid']).first().rank if commented else 0
        return jsonify(status='success', auth=auth, commented=commented, content=content, rank=rank,
                       html=render_template('course/widget_course_comment.html', course=curr_course, user=current_user))
    else:
        return jsonify(status='fail')
