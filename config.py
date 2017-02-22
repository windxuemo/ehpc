#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
# @Last Modified time: 2016-10-08 14:38:25
import os
basedir = os.path.abspath(os.path.dirname(__file__))

"""
从环境变量中读取超算相关的接口配置

TH2_BASE_URL: 基本的请求地址
TH2_LOGIN_UR: 表示请求功能的地址
TH2_ASYNC_URL: 异步获取功能的地址
TH2_ASYNC_FIRST_WAIT_TIME: 首次转到异步获取的等待时间
TH2_ASYNC_WAIT_TIME: 异步获取的等待时间
TH2_USERNAME: 天河账户名
TH2_PASSWORD: 天河账户密码
TH2_DEBUG_ASYNC: 是否开启异步获取的DEBUG模式
TH2_MACHINE_NAME: 登录天河内部的机器名
TH2_MY_PATH: 路径

关于参数的详细信息, 请阅读
https://github.com/xuelangZF/ehpc/wiki/%E8%B6%85%E7%AE%97%E6%8E%A5%E5%8F%A3%E8%AF%B4%E6%98%8E%E6%96%87%E6%A1%A3
"""

TH2_BASE_URL = os.environ.get("EHPC_BASE_URL")
TH2_LOGIN_URL = "/auth"
TH2_ASYNC_URL = "/async"
TH2_ASYNC_FIRST_WAIT_TIME = 1
TH2_ASYNC_WAIT_TIME = 5
TH2_USERNAME = os.environ.get("EHPC_USERNAME")
TH2_PASSWORD = os.environ.get("EHPC_PASSWORD")
TH2_LOGIN_DATA = {"username": TH2_USERNAME, "password": TH2_PASSWORD}
TH2_DEBUG_ASYNC = True
TH2_MACHINE_NAME = os.environ.get("EHPC_MACHINE")
TH2_MY_PATH = os.environ.get("EHPC_PATH")


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
    MAIL_USERNAME = os.environ.get('MAIL_USERNAME') or 'milanlanlanlan@sina.com'
    MAIL_PASSWORD = os.environ.get('MAIL_PASSWORD') or '1970025901a'
    FORUM_MAIL_SUBJECT_PREFIX = 'eHPC'
    FORUM_MAIL_SENDER = '<milanlanlanlan@sina.com>'

    BABEL_DEFAULT_LOCALE = 'zh'
    BABEL_DEFAULT_TIMEZONE = 'CST'

    PER_PAGE = 10
    UPLOAD_FOLDER = os.path.join(basedir, 'eHPC/static/upload')

    HOMEWORK_FOLDER = os.path.join(basedir, 'eHPC/static/homework')
    COURSE_COVER_FOLDER = os.path.join(basedir, 'eHPC/static/images/course')
    CASE_COVER_FOLDER = os.path.join(basedir, 'eHPC/static/images/case')
    RESOURCE_FOLDER = os.path.join(basedir, 'eHPC/static/resource')
    CASE_FOLDER = os.path.join(basedir, 'eHPC/static/case')
    DOWNLOAD_FOLDER = os.path.join(basedir, 'eHPC/static/download')
    QRCODE_FOLDER = os.path.join(basedir, 'eHPC/static/images/QRcode')

    # 这个路径用来保存 Markdown 编辑框拖拽上传的文件
    MD_UPLOAD_IMG = 'static/upload/md_images/'
    IMAGES_FOLDER = os.path.join(basedir, 'eHPC/', MD_UPLOAD_IMG)
    # 用户头像保存的地址
    AVATAR_PATH = "static/upload/avatar/"
    AVATAR_FOLDER = os.path.join(basedir, 'eHPC/', AVATAR_PATH)

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
