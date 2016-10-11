#! /usr/bin/env python
# -*- coding: utf-8 -*-

from . import filter_blueprint
import misaka as m


@filter_blueprint.app_template_filter('markdown')
def markdown(strs):
    """ Render the string into html style.
    """
    return m.html(strs)
