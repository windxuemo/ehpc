from flask import render_template
from . import problem
from flask_babel import gettext


@problem.route('/')
def index():
    return render_template('problem/index.html', title=gettext('Petition Problem List'))
