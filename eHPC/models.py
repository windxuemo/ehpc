#! /usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: xuezaigds@gmail.com
# @Last Modified time: 2016-09-19 23:06:09
from datetime import datetime
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer
from flask import current_app
from . import db, login_manager

""" 用户管理模块 """


class User(UserMixin, db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), unique=True, index=True)
    password_hash = db.Column(db.String(128))
    email = db.Column(db.String(64), unique=True, index=True)

    is_password_reset_link_valid = db.Column(db.Boolean, default=True)
    last_login = db.Column(db.DateTime(), default=datetime.utcnow)
    date_joined = db.Column(db.DateTime(), default=datetime.utcnow)

    is_superuser = db.Column(db.Boolean, default=False)  # 是否是管理员

    # Personal info
    website = db.Column(db.String(64), nullable=True)
    signature = db.Column(db.Text(), nullable=True)
    avatar_url = db.Column(db.String(64),
                           default="http://www.gravatar.com/avatar/")

    # Third part acount
    # TODO
    # weibo = db.Column(db.String(64), nullable=True)
    # qq = db.Column(db.String(64), nullable=True)
    # weixin = db.Column(db.String(64), nullable=True)

    @property
    def password(self):
        raise AttributeError('password is not a readable attribute')

    @password.setter
    def password(self, password):
        self.password_hash = generate_password_hash(password)

    def verify_password(self, password):
        return check_password_hash(self.password_hash, password)

    def generate_reset_token(self, expiration=600):
        s = Serializer(current_app.config['SECRET_KEY'], expiration)
        return s.dumps({'id': self.id})

    @staticmethod
    def verify_token(token):
        s = Serializer(current_app.config['SECRET_KEY'])
        try:
            data = s.loads(token)
        except:
            return None
        uid = data.get('id')
        if uid:
            return User.query.get(uid)
        return None


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


class Student(db.Model):
    __tablename__ = 'students'
    id = db.Column(db.Integer, primary_key=True)


""" 在线课堂模块 """


class Course(db.Model):
    __tablename__ = 'courses'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(64), unique=True, index=True)  # 课程标题
    subtitle = db.Column(db.String(64), default="")  # 课程副标题
    about = db.Column(db.Text(), nullable=True)  # 课程简介
    createdTime = db.Column(db.DateTime(), default=datetime.utcnow)

    lessonNum = db.Column(db.Integer, nullable=False)  # 课时数
    studentNum = db.Column(db.Integer, default=0)  # 学生数目
    # voteNum = db.Column(db.Integer, default=0)

    # smallPicture, middlePicture, largePicture
    smallPicture = db.Column(db.String(64))  # 课程小图
    middlePicture = db.Column(db.String(64))  # 课程中图
    largePicture = db.Column(db.String(64))  # 课程大图

    # 课程包含的课时，评价，资料等， 一对多的关系
    lessons = db.relationship('Lesson', backref='course', lazy='dynamic')
    # rates = db.relationship('Rate', backref='course', lazy='dynamic')


'''
class Teachers(db.Model):
    __tablename__ = 'teachers'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), unique=True, index=True)    # 教师名称
'''


class Lesson(db.Model):
    """ Every course may have more than one lessons.  One lesson belongs to only one course.
    """
    __tablename__ = 'lessons'
    id = db.Column(db.Integer, primary_key=True)  # 课时 ID
    number = db.Column(db.Integer)  # 课时编号
    title = db.Column(db.String(64))  # 课时标题
    content = db.Column(db.Text())  # 课时正文
    courseId = db.Column(db.Integer, db.ForeignKey('courses.id'))  # 所属课程ID

    materials = db.relationship('Material', backref='lesson', lazy='dynamic')


class Material(db.Model):
    """ Every lesson may have more than one materials.  One material belongs to only one course.
    """
    __tablename__ = 'materials'
    id = db.Column(db.Integer, primary_key=True)        # 资料 ID
    name = db.Column(db.String(64), nullable=False)     # 资料名称
    uri = db.Column(db.String(64), default="")          # 资料路径
    size = db.Column(db.Integer)                        # 资料大小
    lessonId = db.Column(db.Integer, db.ForeignKey('lessons.id'))  # 所属课时ID


# class Rate(db.Model):
#     """ Every course may have more than one rates.  One rate belongs to only one course.
#     """
#     __tablename__ = 'rates'
#     id = db.Column(db.Integer, primary_key=True)  # 评价 ID
#     rating = db.Column(db.Integer, default=0)  # 评分
#     content = db.Column(db.String(64), nullable=False)  # 评论内容
#     createdTime = db.Column(db.DateTime(), default=datetime.utcnow)
#     courseId = db.Column(db.Integer, db.ForeignKey('courses.id'))  # 所属课程ID


""" 互动社区功能 """

group_members = db.Table('group_members',
                         db.Column('group_id', db.Integer, db.ForeignKey('users.id')),
                         db.Column('user_id', db.Integer, db.ForeignKey('groups.id')))


class Group(db.Model):
    __tablename__ = 'groups'
    id = db.Column(db.Integer, primary_key=True)  # 讨论组 ID
    title = db.Column(db.String(64), nullable=False)  # 讨论组名字
    about = db.Column(db.Text(), nullable=False)  # 讨论组介绍
    logo = db.Column(db.String(128))  # 讨论组 Logo

    memberNum = db.Column(db.Integer, default=0)  # 讨论组成员数目
    topicNum = db.Column(db.Integer, default=0)  # 讨论组话题数目
    createdTime = db.Column(db.DateTime(), default=datetime.utcnow)

    # 小组内的话题，一对多的关系
    topics = db.relationship('Topic', backref='group', lazy='dynamic')
    # 小组内的成员, 多对多的关系
    members = db.relationship('User', secondary=group_members,
                              backref=db.backref('groups', lazy='dynamic'))


class Topic(db.Model):
    __tablename__ = 'topics'
    id = db.Column(db.Integer, primary_key=True)  # 话题 ID
    title = db.Column(db.String(64), nullable=False)  # 话题标题
    content = db.Column(db.String(1024), nullable=False)  # 话题内容
    visitNum = db.Column(db.Integer, default=0)  # 话题浏览次数
    postNum = db.Column(db.Integer, default=0)  # 评论次数
    groupID = db.Column(db.Integer, db.ForeignKey('groups.id'))  # 所属群组的ID
    userID = db.Column(db.Integer, db.ForeignKey('users.id'))  # 创建用户的ID

    createdTime = db.Column(db.DateTime(), default=datetime.utcnow)
    updatedTime = db.Column(db.DateTime(), default=datetime.utcnow)

    # 话题的评论，一对多的关系
    posts = db.relationship('Post', backref='topic', lazy='dynamic')


class Post(db.Model):
    __tablename = "posts"
    id = db.Column(db.Integer, primary_key=True)  # 评论的ID
    content = db.Column(db.String(1024), nullable=False)  # 评论内容

    topicID = db.Column(db.Integer, db.ForeignKey('topics.id'))  # 所属话题的ID
    userID = db.Column(db.Integer, db.ForeignKey('users.id'))  # 回复用户的ID
    createdTime = db.Column(db.DateTime(), default=datetime.utcnow)


""" 虚拟实验室模块 """

""" 竞赛平台(OJ) """


class Problem(db.Model):
    __tablename__ = "problems"
    id = db.Column(db.Integer, primary_key=True)  # 题目 ID
    title = db.Column(db.String(64), nullable=False)  # 题目标题
    detail = db.Column(db.Text(), nullable=False)  # 题目详情
    difficulty = db.Column(db.Integer, default=0)  # 题目难度
    acceptedNum = db.Column(db.Integer, default=0)  # 通过次数
    submitNum = db.Column(db.Integer, default=0)  # 提交次数

    # default_code = db.Column(db.Text(), default="")             # 预先设定的代码

    createdTime = db.Column(db.DateTime(), default=datetime.utcnow)

    # 一个题目可以有很多人提交,一个人可以提交多个题目。所以题目和用户是多对多的关系
    # TODO


""" 其他: 咨询信息 """


class Article(db.Model):
    __tablename__ = "articles"
    id = db.Column(db.Integer, primary_key=True)  # 资讯 ID
    title = db.Column(db.String(64), nullable=False)  # 资讯标题
    content = db.Column(db.Text(), nullable=False)  # 资讯正文
    visitNum = db.Column(db.Integer, default=0)  # 浏览次数

    createdTime = db.Column(db.DateTime(), default=datetime.utcnow)
