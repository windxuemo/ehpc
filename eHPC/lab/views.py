from flask import render_template
from . import lab
from flask_babel import gettext


@lab.route('/')
def index():
    return render_template('lab/index.html', title=gettext('Labs'))
