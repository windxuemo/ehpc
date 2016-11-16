#! /usr/bin/env python
# -*- coding: utf-8 -*-

from flask import render_template, request
from . import lab
from flask_babel import gettext
from flask_login import login_required, current_user
from ..models import Challenge, Question, Knowledge, Progress, Material
from ..lab.lab_util import get_question_and_type


@lab.route('/')
def index():
    return render_template('lab/index.html', title=gettext('Labs'))


@lab.route('/knowledge/<int:kid>/')
@login_required
def knowledge(kid):
    """ 根据用户进度记录以及请求中 progress 字段来决定给用户返回哪个 challenge.

    cur_progress: 用户请求的任务进度, 如果请求中没有提供, 则返回下一个需要完成的任务的编号
    """
    pro = Progress.query.filter_by(user_id=current_user.id).filter_by(knowledge_id=kid).first()
    cur_progress = pro.cur_progress + 1 if pro else 1

    request_progress = request.args.get('progress', None)
    if not request_progress:
        pass
    elif int(request_progress) <= cur_progress:
        cur_progress = int(request_progress)
    else:
        # 前面还有任务没有完成, 不能直接到请求的任务页面, 这里返回一个简单的提示页面
        return render_template("", )

    # 获取当前技能中顺序为 cur_progress 的 challenge, 然后获取相应的详细内容
    cur_challenge = Challenge.query.filter_by(knowledgeId=kid).filter_by(knowledgeNum=cur_progress).first_or_404()
    m_id = cur_challenge.materialID
    material = Material.query.filter_by(id=m_id).first_or_404()

    # 保证每个challenge都有一个题目, 可以是一般的选择题、填空题等或者在线编程题目
    question, q_type = get_question_and_type(cur_challenge.questionID, cur_challenge.question_type)

    return render_template('lab/knowledge.html',
                           title=cur_challenge.title,
                           c_content=cur_challenge.content,
                           cur_material=material,
                           practices=question,
                           q_type=q_type)
