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
        response = self.client.get(url_for('main.index'))
        self.assertTrue('index' in response.get_data(as_text=True))

    def test_register_and_login(self):
        response = self.client.post(url_for('user.reg', next='/'),
                                    data={
                                        'username': 'a',
                                        'email': 'a@example.com',
                                        'password': '123456',
                                        'password2': '123456'
                                    }, follow_redirects=True)
        self.assertTrue(response.status_code == 200)

    def test_system_index(self):
        # 未登录状态
        response = self.client.get(url_for('admin.index'))
        self.assertTrue(response.status_code == 302)
        # 登录状态
        self.login('admin@qq.com', 'admin')
        response = self.client.get(url_for('admin.index'))
        self.assertTrue(response.status_code == 200)

    def test_teacher_index(self):
        # 未登录状态
        response = self.client.get(url_for('admin.teacher'))
        self.assertTrue(response.status_code == 302)
        # 登录状态
        self.login('teacher@qq.com', '1')
        response = self.client.get(url_for('admin.teacher'))
        self.assertTrue(response.status_code == 200)

    def test_course_op(self):
        self.login('teacher@qq.com', '1')
        # 创建
        response = self.client.post(url_for('admin.course_create'),
                                    data={
                                        'op': 'create',
                                        'title': 'test'
                                    })
        self.assertTrue(response.status_code == 302)
        self.course_id = response.headers['Location'].split('/')[-3]
        response = self.client.get(url_for('admin.course'))
        self.assertTrue('test' in response.data)
        # 编辑
        response = self.client.post(url_for('admin.course_edit', course_id=self.course_id),
                                    data={
                                        'op': 'edit',
                                        'title': 'test_title',
                                        'subtitle': 'test_subtitle',
                                        'about': 'test_about'
                                    })
        self.assertTrue(response.status_code == 200)
        self.assertTrue(json.loads(response.data)['status'] == 'success')
        response = self.client.get(url_for('admin.course'))
        self.assertTrue('test_title' in response.data)
        # 删除
        self.login('teacher@qq.com', '1')
        response = self.client.post(url_for('admin.course'),
                                    data={
                                        'course_id': self.course_id
                                    })
        self.assertTrue('test_title' not in response.data)

    def test_case_index(self):
        response = self.client.get(url_for('case.index'))
        self.assertTrue(response.status_code == 200)

    def test_course_index(self):
        response = self.client.get(url_for('course.index'))
        self.assertTrue(response.status_code == 200)

    def test_group_index(self):
        response = self.client.get(url_for('group.index'))
        self.assertTrue(response.status_code == 200)

    def test_lab_index(self):
        # 未登录状态
        response = self.client.get(url_for('lab.index'))
        self.assertTrue(response.status_code == 302)
        # 登录状态
        self.login('1@qq.com', '1')
        response = self.client.get(url_for('lab.index'))
        self.assertTrue(response.status_code == 200)

    def test_problem_index(self):
        response = self.client.get(url_for('problem.index'))
        self.assertTrue(response.status_code == 200)

    def test_user_index(self):
        response = self.client.get(url_for('user.view', uid=1))
        self.assertTrue(response.status_code == 200)


if __name__ == '__main__':
    unittest.main()
