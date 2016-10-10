#! /usr/bin/env python
# -*- coding: utf-8 -*-

from . import filter_blueprint


@filter_blueprint.app_template_filter('is_join_course')
def is_join_course(user_id, course_id):
    """ Check if one use join in a course or not.
    """

    # TODO
    return False
