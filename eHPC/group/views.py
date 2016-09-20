from flask import render_template
from . import group
from ..models import Group
from flask_babel import gettext
from sqlalchemy.sql.expression import func


@group.route('/')
def index():
    hot_groups = Group.query.order_by(func.length(Group.members).desc())
    return render_template('group/index.html', title=gettext('Groups'), groups=hot_groups)
