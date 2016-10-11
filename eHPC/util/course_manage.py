#! /usr/bin/env python
# -*- coding: utf-8 -*-

from . import filter_blueprint


@filter_blueprint.app_template_filter('is_join_course')
def is_join_course(user_id, course_id):
    """ Check if one use join in a course or not.
    """

    # TODO
    return False


@filter_blueprint.app_template_filter('get_icon_class')
def get_icon_class(resource_type="audio"):
    type_class_dict = dict()
    type_class_dict['audio'] = "es-icon es-icon-audioclass"             # 音频资料
    type_class_dict['video'] = "es-icon es-icon-videoclass"             # 视频资料
    type_class_dict['description'] = "es-icon es-icon-description"      # PPT,PDF 资料
    type_class_dict['graphic'] = "es-icon es-icon-graphicclass"         # 图文资料
    return type_class_dict[resource_type]
