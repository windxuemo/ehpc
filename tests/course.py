#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os
import unittest
import json

from eHPC import create_app, db
from flask import url_for
from flask_script import Manager
from flask_migrate import Migrate
from flask_babel import Babel
from flask_wtf.csrf import CSRFProtect


class EHpcTestCase(unittest.TestCase):

    def setUp(self):
        self.app = create_app(os.getenv('EHPC_CONFIG') or 'default')
        self.app.config['TESTING'] = True
        self.app.config['WTF_CSRF_ENABLED'] = False
        self.app.config['SERVER_NAME'] = "127.0.0.1:6666"
        self.app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:123456@localhost/ehpc'
        manager = Manager(self.app)
        migrate = Migrate(self.app, db)
        babel = Babel(self.app)
        csrf = CSRFProtect(self.app)
        self.app_context = self.app.app_context()
        self.app_context.push()
        # db.create_all()
        self.client = self.app.test_client(use_cookies=True)

    def tearDown(self):
        db.session.remove()
        # db.drop_all()
        self.app_context.pop()

    def login(self, email, password):
        response = self.client.post(url_for('user.signin', next='/'),
                                    data={
                                        'email': email,
                                        'password': password
                                    }, follow_redirects=True)
        self.assertTrue(response.status_code == 200)
        return response.status_code == 200

    def test_index(self):
        response = self.client.get(url_for('course.index'))
        self.assertTrue(response.status_code == 200)

    def test_view(self):
        response = self.client.get(url_for('course.view', cid=1))
        self.assertTrue(response.status_code == 200)

    def test_join(self):
        self.login('1@qq.com', '1')
        response = self.client.get(url_for('course.join', cid=2))
        self.assertTrue(response.status_code == 200)
        self.assertTrue(json.loads(response.data)['status'] == 'success')

    def test_exit(self):
        self.login('1@qq.com', '1')
        response = self.client.get(url_for('course.exit_out', cid=2))
        self.assertTrue(response.status_code == 200)
        self.assertTrue(json.loads(response.data)['status'] == 'success')

    def test_material(self):
        self.login('1@qq.com', '1')
        response = self.client.get(url_for('course.material', mid=133))
        self.assertTrue(response.status_code == 200)

    def test_detail_lessons(self):
        self.login('1@qq.com', '1')
        response = self.client.get(url_for('course.detail_lessons', cid=2))
        self.assertTrue(response.status_code == 200)

    def test_homework_list(self):
        self.login('1@qq.com', '1')
        response = self.client.get(url_for('course.homework_list', cid=2))
        self.assertTrue(response.status_code == 200)

    def test_paper_detail(self):
        self.login('1@qq.com', '1')
        response = self.client.get(url_for('course.paper_detail', pid=1))
        self.assertTrue(response.status_code == 200)

    def test_process_comment(self):
        self.login('1@qq.com', '1')
        response = self.client.post(url_for('course.process_comment'),
                                    data={
                                        'op': 'create',
                                        'rank': '5',
                                        'content': 'test',
                                        'courseId': '2'
                                    })
        self.assertTrue(response.status_code == 200)
        self.assertTrue(json.loads(response.data)['status'] == 'success')

if __name__ == '__main__':
    unittest.main()
