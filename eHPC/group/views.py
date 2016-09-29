from flask import render_template, abort
from . import group
from ..models import Group, Topic
from flask_babel import gettext
from sqlalchemy.sql.expression import func


@group.route('/')
def index():
    latest_topics = Topic.query.order_by(Topic.createdTime.desc()).limit(10)
    hot_groups = Group.query.order_by(Group.memberNum.desc())
    return render_template('group/index.html', title=gettext('Groups'),
                           groups=hot_groups, latest_topics=latest_topics)


@group.route('/all')
def all():
    all_groups = Group.query.all()
    return render_template('group/all.html', title=gettext('All Groups'), groups=all_groups)


@group.route('/topic/<int:tid>')
def topic_view(tid):
    # TODO
    abort(404)


@group.route('/<int:gid>')
def view(gid):
    # TODO
    abort(404)
