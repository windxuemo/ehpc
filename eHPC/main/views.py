from flask import render_template
from . import main
from flask_babel import gettext


@main.route('/')
def index():
    return render_template('main/index.html', title=gettext('Education Practice Platform'))
