#! /usr/bin/env python
# -*- coding: utf-8 -*-

from datetime import datetime
from flask_login import current_user

from .. import db
from ..models import Progress


def get_cur_progress(kid):
    """ 返回当前登录用户在 knowledge(kid) 上学习的最后一个知识点序号

    如果数据库中没有进度记录, 则在数据库中添加一条记录
    """
    pro = Progress.query.filter_by(user_id=current_user.id).filter_by(knowledge_id=kid).first()
    if pro is None:
        pro = Progress(user_id=current_user.id, knowledge_id=kid, update_time=datetime.now())
        db.session.add(pro)
    pro.update_time = datetime.now()
    db.session.commit()

    return pro.cur_progress
