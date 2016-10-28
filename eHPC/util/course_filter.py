#! /usr/bin/env python
# -*- coding: utf-8 -*-

from . import filter_blueprint
from ..models import Course, User


@filter_blueprint.app_template_filter('is_join_course')
def is_join_course(user_id, course_id):
    """ Check if one use join in a course or not.
    """
    cur_course = Course.query.filter_by(id=course_id).first()
    cur_user = User.query.filter_by(id=user_id).first()
    if cur_user in cur_course.users:
        return True
    else:
        return False


@filter_blueprint.app_template_filter('get_icon_class')
def get_icon_class(resource_type="audio"):
    type_class_dict = dict()
    type_class_dict['audio'] = "es-icon es-icon-audioclass"  # 音频资料
    type_class_dict['video'] = "es-icon es-icon-videoclass"  # 视频资料
    type_class_dict['ppt'] = "es-icon es-icon-description"  # PPT,PDF 资料
    type_class_dict['pdf'] = "es-icon es-icon-description"  # PPT,PDF 资料
    type_class_dict['graphic'] = "es-icon es-icon-graphicclass"  # 图文资料
    return type_class_dict[resource_type]
