#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
# @Last Modified time: 2016-10-08 14:38:25
import os
basedir = os.path.abspath(os.path.dirname(__file__))

# 天河接口参数设置

# 基本的请求地址
TH2_base_url = os.environ.get("EHPC_BASE_URL")
# 表示请求功能的地址
TH2_login_url = "/auth"
# 异步获取功能的地址
TH2_async_url = "/async"
# 首次转到异步获取的等待时间
TH2_async_first_wait_time = 1
# 异步获取的等待时间
TH2_async_wait_time = 5
# 天河账户名
TH2_username = os.environ.get("EHPC_USERNAME")
# 天河账户密码
TH2_password = os.environ.get("EHPC_PASSWORD")
# 登录数据
TH2_login_data = {"username": TH2_username, "password": TH2_password}
# 是否开启异步获取的DEBUG模式
TH2_DEBUG_ASYNC = True
# 登录天河内部的机器名，联系超算中心获取
TH2_machine_name = os.environ.get("EHPC_MACHINE")
# 路径
TH2_myPath = os.environ.get("EHPC_PATH")


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
