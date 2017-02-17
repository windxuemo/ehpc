#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
# @Last Modified time: 2016-10-08 14:38:43
import os
from eHPC import create_app, db
from flask_script import Manager, Server
from flask_migrate import Migrate, MigrateCommand
from flask_babel import Babel
from flask_wtf.csrf import CSRFProtect
from eHPC import wechat

app = create_app(os.getenv('EHPC_CONFIG') or 'default')
manager = Manager(app)
migrate = Migrate(app, db)
babel = Babel(app)
csrf = CSRFProtect(app)
csrf.exempt(wechat.views.process)

manager.add_command('db', MigrateCommand)

if __name__ == '__main__':
    manager.run()
