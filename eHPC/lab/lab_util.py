#! /usr/bin/env python
# -*- coding: utf-8 -*-

from datetime import datetime
from flask_login import current_user

from .. import db
from ..models import Progress


def get_progress_class(kid):
    pro = Progress.query.filter_by(user_id=current_user.id).filter_by(knowledge_id=kid).first()
    if pro is None:
        pro = Progress(user_id=current_user.id, knowledge_id=kid, update_time=datetime.now())
        db.session.add(pro)
        db.commit()
    return pro


def get_cur_progress(kid):
    """ 返回当前登录用户在 knowledge(kid) 上学习的最后一个知识点序号

    如果数据库中没有进度记录, 则在数据库中添加一条记录
    """
    pro = get_progress_class(kid)
    pro.update_time = datetime.now()
    db.session.commit()
    return pro.cur_progress


def increase_progress(kid, k_num, challenges_count):
    pro = get_progress_class(kid)
    if k_num == pro.cur_progress + 1 and pro.cur_progress + 1 <= challenges_count:
        pro.cur_progress += 1
        db.session.commit()
