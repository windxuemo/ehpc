#! /usr/bin/env python
# -*- coding: utf-8 -*-
from . import filter_blueprint
from ..models import User, Group


@filter_blueprint.app_template_filter('is_user_in_group')
def is_user_in_group(user_id, group_id):
    """ 判断某人是否加入了某个群组
    """
    cur_group = Group.query.filter_by(id=group_id).first()
    cur_user = User.query.filter_by(id=user_id).first()
    if cur_user in cur_group.members:
        return True
    else:
        return False
