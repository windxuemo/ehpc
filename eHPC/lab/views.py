#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os
from datetime import datetime

from flask import render_template, request, jsonify, abort, current_app
from flask_babel import gettext
from flask_login import login_required, current_user

from eHPC.util.code_process import ehpc_client
from . import lab
from .. import db
from ..models import Challenge, Knowledge, Progress
from .lab_util import get_cur_progress
import random, string
import requests


@lab.route('/')
@login_required
def index():
    knowledges = Knowledge.query.all()

    # 记录当前用户在每个knowledge上的进度百分比
    if current_user.is_authenticated:
        for k in knowledges:
            pro = Progress.query.filter_by(user_id=current_user.id).filter_by(knowledge_id=k.id).first()
            k.cur_level = pro.cur_progress if pro else 0
            k.all_levels = k.challenges.count()
            k.percentage = "{0:.0f}%".format(100.0 * k.cur_level / k.all_levels) if k.all_levels >= 1 else "100%"
    return render_template('lab/index.html',
                           title=gettext('Labs'),
                           knowledges=knowledges)


@lab.route('/detail/<int:kid>/')
@login_required
def detail(kid):
    cur_knowledge = Knowledge.query.filter_by(id=kid).first_or_404()
    cur_level = get_cur_progress(kid)

    if request.method == 'GET':
        return render_template("lab/detail.html",
                               title=cur_knowledge.title,
                               knowledge=cur_knowledge,
                               cur_level=cur_level)


@lab.route('/knowledge/<int:kid>/', methods=['POST', 'GET'])
@login_required
def knowledge(kid):
    """ 根据用户进度记录以及请求中 progress 字段来决定给用户返回哪个 challenge.

    cur_progress: 用户请求的任务进度, 如果请求中没有提供, 则返回下一个需要完成的任务的编号
    """
    cur_knowledge = Knowledge.query.filter_by(id=kid).first_or_404()
    challenges_count = cur_knowledge.challenges.count()

    if request.method == 'GET':
        cur_progress = get_cur_progress(kid)

        try:
            request_progress = int(request.args.get('progress', None))
        except ValueError:
            return abort(404)
        except TypeError:
            request_progress = cur_progress

        if request_progress < 0:
            return abort(404)
        if 0 < request_progress <= cur_progress+1:
            cur_progress = request_progress
        else:
            # 前面还有任务没有完成, 不能直接到请求的任务页面, 这里返回一个简单的提示页面
            return render_template("lab/out_progress.html",
                                   title=u"前面任务还没完成",
                                   next_progress=cur_progress+1,
                                   kid=kid)

        # 获取当前技能中顺序为 cur_progress 的 challenge, 然后获取相应的详细内容
        cur_challenge = Challenge.query.filter_by(knowledgeId=kid).filter_by(knowledgeNum=cur_progress).first()
        if cur_challenge is None:
            return render_template('lab/finish_progress.html',
                                   title=u"学习完成",
                                   kid=kid,
                                   challenges=cur_knowledge.challenges.all(),
                                   cur_level=cur_progress)

        # challenge 可能没有相应的 material 存在, cur_material 对应为空。
        return render_template('lab/knowledge.html',
                               title=cur_challenge.title,
                               c_content=cur_challenge.content,
                               cur_material=cur_challenge.material,
                               kid=kid,
                               next_progress=cur_progress+1,
                               challenges_count=challenges_count)

    elif request.method == 'POST':
        if request.form['op'] == 'run':
            source_code = request.form['code']
            k_num = request.form['k_num']

            myPath = os.environ.get("EHPC_PATH")

            job_filename = "%s_%s_%s.sh" % (str(kid), str(k_num), str(current_user.id))
            input_filename = "%s_%s_%s.c" % (str(kid), str(k_num), str(current_user.id))
            output_filename = "%s_%s_%s.o" % (str(kid), str(k_num), str(current_user.id))
            task_number = 1
            cpu_number_per_task = 1
            node_number = 1

            client = ehpc_client()
            is_success = [False]
            is_success[0] = client.login()
            if not is_success[0]:
                return jsonify(status="fail", msg="连接超算主机失败!")

            is_success[0] = client.upload(myPath, input_filename, source_code)
            if not is_success[0]:
                return jsonify(status="fail", msg="上传程序到超算主机失败!")

            compile_out = client.ehpc_compile(is_success, myPath, input_filename, output_filename, "mpicc")

            result = dict()
            result['compile_success'] = 'true'
            if is_success[0]:
                run_out = client.ehpc_run(output_filename, job_filename, myPath,
                                          task_number, cpu_number_per_task, node_number)
            else:
                result['compile_success'] = 'false'
                run_out = "编译失败，无法运行！"

            result['compile_out'] = compile_out
            result['run_out'] = run_out

            # 代码成功通过编译, 则认为已完成该知识点学习
            pro = Progress.query.filter_by(user_id=current_user.id).filter_by(knowledge_id=kid).first()
            if k_num == pro.cur_progress + 1:
                if pro.cur_progress + 1 <= challenges_count:
                    pro.cur_progress += 1
                    db.session.commit()

            return jsonify(result=result, status='success')
        elif request.form['op'] == 'get_source_code':
            cur_challenge = Challenge.query.filter_by(knowledgeId=kid).filter_by(knowledgeNum=request.form['k_num']).first()
            return jsonify(source_code=cur_challenge.source_code, status='success')
        elif request.form['op'] == 'get_default_code':
            cur_challenge = Challenge.query.filter_by(knowledgeId=kid).filter_by(knowledgeNum=request.form['k_num']).first()
            return jsonify(default_code=cur_challenge.default_code, status='success')


@lab.route('/my_progress/<int:kid>/')
@login_required
def my_progress(kid):
    cur_knowledge = Knowledge.query.filter_by(id=kid).first_or_404()
    cur_level = get_cur_progress(kid)
    all_challenges = cur_knowledge.challenges.all()
    all_challenges.sort(key=lambda k: k.knowledgeNum)
    return render_template('lab/widget_show_progress.html',
                           kid=kid,
                           title=cur_knowledge.title,
                           challenges=all_challenges,
                           cur_level=cur_level)


@lab.route('/vnc/')
@login_required
def vnc():
    status = 'repeated token'
    token = ''
    req = None
    while status == 'repeated token':
        token = ''.join(random.sample(string.ascii_letters + string.digits, 32))
        req = requests.post(current_app.config['VNC_SERVER_URL'], params={"This_is_a_very_secret_token": token,
                                                                          "user_id": current_user.id})
        status = req.json()['status']
    print status
    if status == 'success':
        return render_template('lab/vnc.html', title=gettext('vnc'), status='success', token=token)
    elif status == 'reconnect success':
        return render_template('lab/vnc.html', title=gettext('vnc'), status='success', token=req.json()['token'])
    elif status == 'no machine available':
        return render_template('lab/vnc.html', title=gettext('vnc'), status='no machine available')
    else:
        return render_template('lab/vnc.html', title=gettext('vnc'), status='error')
