#! /usr/bin/env python
# -*- coding: utf-8 -*-

from . import filter_blueprint
from ..models import Course, User, PaperQuestion
from sqlalchemy import *
from .. import db
import json


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
    type_class_dict['audio'] = "es-icon es-icon-audioclass"         # 音频资料
    type_class_dict['video'] = "es-icon es-icon-videoclass"         # 视频资料
    type_class_dict['ppt'] = "es-icon es-icon-description"          # PPT,PDF 资料
    type_class_dict['pdf'] = "es-icon es-icon-description"          # PPT,PDF 资料
    type_class_dict['graphic'] = "es-icon es-icon-graphicclass"     # 图文资料
    return type_class_dict[resource_type]


@filter_blueprint.app_template_filter('get_substring_number')
def get_substring_number(string, c):
    return len(string.split(c))


@filter_blueprint.app_template_filter('split_fill')
def split_fill(string):
    temp = string.split('*')[0::2]
    for i in temp:
        i = '<span>' + i + '</span>'
    return '<input type="text" class="fill-input" style="margin: 0 10px;text-align:center">'.join(temp)


@filter_blueprint.app_template_filter('get_fill_solution_len')
def get_fill_solution_len(string):
    temp = json.loads(string)
    result = []
    for i in range(temp['len']):
        result.append(str(len(temp[str(i)])))
    return ';'.join(result)


@filter_blueprint.app_template_filter('get_total_point')
def get_total_point(paper_question, q_type=-1):
    result = 0
    if q_type == -1:
        for pq in paper_question:
            result += pq.point
    else:
        for pq in paper_question:
            if pq.questions.type == q_type:
                result += pq.point
    return result


@filter_blueprint.app_template_filter('get_question_number')
def get_question_number(paper_question, q_type=-1):
    result = 0
    if q_type == -1:
        for _ in paper_question:
            result += 1
    else:
        for pq in paper_question:
            if pq.questions.type == q_type:
                result += 1
    return result
