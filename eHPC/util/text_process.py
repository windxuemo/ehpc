#! /usr/bin/env python
# -*- coding: utf-8 -*-

from . import filter_blueprint
import re
from ..models import User
from flask import url_for
# import misaka as m

# 后台不再渲染 Markdown, 改为用 js 在前端渲染。
# @filter_blueprint.app_template_filter('markdown')
# def markdown(string):
#     """ Render the string into html style.
#
#     支持表格, 自动检测链接, 删除线等
#     http://misaka.61924.nl/
#     """
#     renderer = m.HtmlRenderer()
#     md = m.Markdown(renderer, extensions=('fenced-code', 'tables', 'autolink', 'strikethrough', 'underline'))
#     return md(string)


@filter_blueprint.app_template_filter('split')
def split(string, c, n):
    return string.split(c)[n]


def add_user_links_in_content(content):
    """ Replace the @user with the link of the user.
    """
    for at_name in re.findall(r'@(.*?)(?:\s|</\w+>)', content):
        at_u = User.query.filter_by(username=at_name).first()
        # There is no such a uer.
        if not at_u:
            continue

        # Add links to the @user field.
        content = re.sub(
            '@%s' % at_name,
            '@<a href="%s" class="mention">%s</a>' % (url_for('user.view', uid=at_u.id), at_name),
            content)

    return content
