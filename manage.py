#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
# @Last Modified time: 2016-10-08 14:38:43
import os
from eHPC import create_app, db
from flask_script import Manager
from flask_migrate import Migrate, MigrateCommand
from flask_babel import Babel

app = create_app(os.getenv('EHPC_CONFIG') or 'default')
manager = Manager(app)
migrate = Migrate(app, db)
babel = Babel(app)

manager.add_command('db', MigrateCommand)


@app.template_filter('split')
def split(string, c, n):
    return string.split(c)[n]


if __name__ == '__main__':
    manager.run()
