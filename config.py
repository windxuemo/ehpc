#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
# @Last Modified time: 2016-10-08 14:38:25
import os
basedir = os.path.abspath(os.path.dirname(__file__))


class Config:
    def __init__(self):
        pass

    SECRET_KEY = os.environ.get('SECRET_KEY') or '!@#$%^&*12345678'
    SQLALCHEMY_RECORD_QUERIES = True
    SQLALCHEMY_TRACK_MODIFICATIONS = True

    # If use QQ email, please see http://service.mail.qq.com/cgi-bin/help?id=28 firstly.
    MAIL_SERVER = 'smtp.sina.com'
    MAIL_PORT = 465
    MAIL_USE_SSL = True
    MAIL_USERNAME = 'milanlanlanlan@sina.com'   # os.environ.get('MAIL_USERNAME')
    MAIL_PASSWORD = '1970025901a'               # os.environ.get('MAIL_PASSWORD')
    FORUM_MAIL_SUBJECT_PREFIX = 'eHPC'
    FORUM_MAIL_SENDER = '<milanlanlanlan@sina.com>'

    BABEL_DEFAULT_LOCALE = 'zh'
    BABEL_DEFAULT_TIMEZONE = 'CST'

    PER_PAGE = 10
    UPLOAD_FOLDER = os.path.join(basedir, 'eHPC/static/upload')
    COURSE_COVER_FOLDER = os.path.join(basedir, 'eHPC/static/images/course')
    CASE_COVER_FOLDER = os.path.join(basedir, 'eHPC/static/images/case')
    RESOURCE_FOLDER = os.path.join(basedir, 'eHPC/static/resource')
    CASE_FOLDER = os.path.join(basedir, 'eHPC/static/case')

    # 这个路径用来保存 Markdown 编辑框拖拽上传的文件
    MD_UPLOAD_IMG = 'static/upload/md_images/'
    IMAGES_FOLDER = os.path.join(basedir, 'eHPC/', MD_UPLOAD_IMG)

    MAX_CONTENT_LENGTH = 512 * 1024 * 1024
    ALLOWED_RESOURCE_TYPE = {'pdf', 'video', 'audio'}

    @staticmethod
    def init_app(app):
        pass


class DevelopmentConfig(Config):
    def __init__(self):
        pass

    DEBUG = True
    SQLALCHEMY_DATABASE_URI = (os.environ.get('DEV_DATABASE_URL') or
                               'mysql://root:123456@localhost/ehpc')


class ProductionConfig(Config):
    def __init__(self):
        pass

    SQLALCHEMY_DATABASE_URI = (os.environ.get('DEV_DATABASE_URL') or
                               'mysql://root:123456@localhost/ehpc')


config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}
