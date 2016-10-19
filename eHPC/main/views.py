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


@main.app_errorhandler(404)
def page_404(err):
    return render_template('404.html', title='404'), 404


@main.app_errorhandler(403)
def page_403(err):
    return render_template('403.html', title='403'), 403


@main.app_errorhandler(500)
def page_500(err):
    return render_template('500.html', title='500'), 500
