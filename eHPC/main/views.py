from flask import render_template
from . import main
from ..models import Course, Group, Article
from flask_babel import gettext


@main.route('/')
def index():
    courses = Course.query.limit(8)
    groups = Group.query.order_by(Group.memberNum.desc()).limit(6)
    articles = Article.query.order_by(Article.createdTime.desc()).limit(5)
    return render_template('main/index.html',
                           title=gettext('Education Practice Platform'),
                           courses=courses,
                           groups=groups,
                           articles=articles)
