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
import json

""" 用户管理模块 """


class User(UserMixin, db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), unique=True, index=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)
    email = db.Column(db.String(64), unique=True, index=True, nullable=False)

    is_password_reset_link_valid = db.Column(db.Boolean, default=True)
    last_login = db.Column(db.DateTime(), default=datetime.now)
    date_joined = db.Column(db.DateTime(), default=datetime.now)

    # 权限: 0. 管理员, 1. 学生, 2. 老师,
    permissions = db.Column(db.Integer, default=1, nullable=False)
    website = db.Column(db.String(64), nullable=True)
    avatar_url = db.Column(db.String(64),
                           default="http://www.gravatar.com/avatar/")

    # 个人信息, 包括电话号码, 身份证号码, 个人座右铭等。
    telephone = db.Column(db.String(32))
    personal_id = db.Column(db.String(32))
    personal_profile = db.Column(db.Text(), nullable=True)

    # 用户创建话题, 回复等, 一对多的关系
    topics = db.relationship('Topic', backref='user', lazy='dynamic')
    topicNum = db.Column(db.Integer, default=0, nullable=False)

    posts = db.relationship('Post', backref='user', lazy='dynamic')
    postNum = db.Column(db.Integer, default=0, nullable=False)

    comments = db.relationship('Comment', backref='user', lazy='dynamic')
    commentNum = db.Column(db.Integer, default=0, nullable=False)

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


""" 在线课堂模块
@Course: 课程实体
@Lesson: 课时实体
@Material: 课时资源实体(PDF,PPT,MP4,MP3等资源)
@course_users: 课程和用户的多对多关系
"""
course_users = db.Table('course_users',
                        db.Column('user_id', db.Integer, db.ForeignKey('users.id')),
                        db.Column('course_id', db.Integer, db.ForeignKey('courses.id')))


class Course(db.Model):
    __tablename__ = 'courses'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(64), unique=True, index=True)   # 课程标题
    subtitle = db.Column(db.String(64), default="")             # 课程副标题
    about = db.Column(db.Text(), nullable=True)                 # 课程简介
    createdTime = db.Column(db.DateTime(), default=datetime.now)

    lessonNum = db.Column(db.Integer, nullable=False)           # 课时数
    studentNum = db.Column(db.Integer, default=0)               # 学生数目

    # smallPicture, middlePicture, largePicture
    smallPicture = db.Column(db.String(64))                     # 课程小图
    middlePicture = db.Column(db.String(64))                    # 课程中图
    largePicture = db.Column(db.String(64))                     # 课程大图

    rank = db.Column(db.Float, default=0)                     # 课程评分

    # 课程包含的课时，评价，资料等， 一对多的关系
    lessons = db.relationship('Lesson', backref='course', lazy='dynamic')
    papers = db.relationship('Paper', backref='course', lazy='dynamic')
    comments = db.relationship('Comment', backref='course', lazy='dynamic')
    # 加入该课程的用户, 多对多的关系
    users = db.relationship('User', secondary=course_users,
                            backref=db.backref('courses', lazy='dynamic'))


class Lesson(db.Model):
    """ 一个课程包括多个课时, 每个课时只能属于一个课程。 课程和课时是一对多的关系。
    """
    __tablename__ = 'lessons'
    id = db.Column(db.Integer, primary_key=True)  # 课时 ID
    number = db.Column(db.Integer)                # 课时所在课程的编号
    title = db.Column(db.String(64))              # 课时标题
    content = db.Column(db.Text())                # 课时正文
    courseId = db.Column(db.Integer, db.ForeignKey('courses.id'))  # 所属课程ID

    materials = db.relationship('Material', backref='lesson', lazy='dynamic')


class Material(db.Model):
    """ 一个课时包括多种材料, 每个材料只能属于一个课时。 课时和材料是一对多的关系。
    """
    __tablename__ = 'materials'
    id = db.Column(db.Integer, primary_key=True)        # 资料 ID
    name = db.Column(db.String(64), nullable=False)     # 资料名称
    uri = db.Column(db.String(64), default="")          # 资料路径
    m_type = db.Column(db.String(64), nullable=False)   # 资料类型

    lessonId = db.Column(db.Integer, db.ForeignKey('lessons.id'))  # 所属课时ID


class Comment(db.Model):
    """ 一个课程包括多个评论, 每个评论只能属于一个课程。 课程和评论是一对多的关系。
    """
    __tablename__ = 'comments'
    id = db.Column(db.Integer, primary_key=True)  # 评论 ID
    rank = db.Column(db.Integer)                  # 评价等级
    content = db.Column(db.String(2048))          # 评价内容
    createdTime = db.Column(db.DateTime(), default=datetime.now)

    courseId = db.Column(db.Integer, db.ForeignKey('courses.id'))   # 所属课程ID
    userId = db.Column(db.Integer, db.ForeignKey('users.id'))       # 所属用户ID


""" 互动社区功能 """
group_members = db.Table('group_members',
                         db.Column('user_id', db.Integer, db.ForeignKey('users.id')),
                         db.Column('group_id', db.Integer, db.ForeignKey('groups.id')))


class Group(db.Model):
    def __init__(self, title, about):
        self.title = title
        self.about = about
        self.createdTime = datetime.now()

    __tablename__ = 'groups'
    id = db.Column(db.Integer, primary_key=True)        # 讨论组 ID
    title = db.Column(db.String(64), nullable=False)    # 讨论组名字
    about = db.Column(db.Text(), nullable=False)        # 讨论组介绍
    logo = db.Column(db.String(128))                    # 讨论组 Logo 的 URL

    memberNum = db.Column(db.Integer, default=0)        # 讨论组成员数目
    topicNum = db.Column(db.Integer, default=0)         # 讨论组话题数目
    createdTime = db.Column(db.DateTime(), default=datetime.now)

    # 小组内的话题，一对多的关系
    topics = db.relationship('Topic', backref='group', lazy='dynamic')
    # 小组内的成员, 多对多的关系
    members = db.relationship('User', secondary=group_members,
                              backref=db.backref('groups', lazy='dynamic'))


class Topic(db.Model):
    def __init__(self, user_id, title, content, group_id):
        self.userID = user_id
        self.title = title
        self.content = content
        self.createdTime = datetime.now()
        self.updatedTime = datetime.now()
        self.groupID = group_id

    __tablename__ = 'topics'
    id = db.Column(db.Integer, primary_key=True)                # 话题 ID
    title = db.Column(db.String(64), nullable=False)            # 话题标题
    content = db.Column(db.Text(), nullable=False)              # 话题内容
    visitNum = db.Column(db.Integer, default=0)                 # 话题浏览次数
    postNum = db.Column(db.Integer, default=0)                  # 评论次数
    groupID = db.Column(db.Integer, db.ForeignKey('groups.id')) # 所属群组的ID
    userID = db.Column(db.Integer, db.ForeignKey('users.id'))   # 创建用户的ID

    createdTime = db.Column(db.DateTime(), default=datetime.now)
    updatedTime = db.Column(db.DateTime(), default=datetime.now)

    # 话题的评论，一对多的关系
    posts = db.relationship('Post', backref='topic', lazy='dynamic')


class Post(db.Model):
    def __init__(self, user_id, content):
        self.content = content
        self.userID = user_id
        self.createdTime = datetime.now()

    __tablename = "posts"
    id = db.Column(db.Integer, primary_key=True)                # 评论的ID
    content = db.Column(db.String(1024), nullable=False)        # 评论内容

    topicID = db.Column(db.Integer, db.ForeignKey('topics.id')) # 所属话题的ID
    userID = db.Column(db.Integer, db.ForeignKey('users.id'))   # 回复用户的ID
    createdTime = db.Column(db.DateTime(), default=datetime.now)


""" 试题中心模块
@Program:           对应在线编程题
@SubmitProblem:     对应编程题目提交记录
@Choice:            对应选择题
@Classify:          选择题目所属的分类
@PaperQuestion:     试卷和题目是多对多的关系, 并且试卷中的题目有自己的分值, 因此需要建一个关联表
@Paper:             试卷实体
@Question:          选择题, 填空题, 判断题等题型
"""


class Program(db.Model):
    __tablename__ = "programs"
    id = db.Column(db.Integer, primary_key=True)        # 题目 ID
    title = db.Column(db.String(64), nullable=False)    # 题目标题
    detail = db.Column(db.Text(), nullable=False)       # 题目详情
    difficulty = db.Column(db.Integer, default=0)       # 题目难度
    acceptedNum = db.Column(db.Integer, default=0)      # 通过次数
    submitNum = db.Column(db.Integer, default=0)        # 提交次数

    # default_code = db.Column(db.Text(), default="")   # 预先设定的代码

    createdTime = db.Column(db.DateTime(), default=datetime.now)


class SubmitProblem(db.Model):
    # 一个题目可以有很多人提交,一个人可以提交多个题目。所以题目和用户是多对多的关系
    def __init__(self, user_id, problem_id, source_code, language):
        self.uid = user_id
        self.pid = problem_id
        self.code = source_code
        self.language = language
        self.submit_time = datetime.now()

    __tablename__ = "submit_problem"
    id = db.Column(db.Integer, primary_key=True)            # 提交记录id
    pid = db.Column(db.Integer, nullable=False)             # 本次提交的题目ID
    uid = db.Column(db.Integer, nullable=False)             # 本次提交的用户ID
    code = db.Column(db.Text(), nullable=False)             # 本次提交的提交代码
    language = db.Column(db.String(64), nullable=False)     # 本次提交的代码语言
    submit_time = db.Column(db.DateTime(), default=datetime.now)   # 本次提交的提交时间
    status = db.Column(db.String(64))                       # 本次提交的运行结果


question_classifies = db.Table('question_classifies',
                               db.Column('question_id', db.Integer, db.ForeignKey('questions.id'), primary_key=True),
                               db.Column('classify_id', db.Integer, db.ForeignKey('classifies.id'), primary_key=True))


class PaperQuestion(db.Model):
    __tablename__ = "paper_question"
    question_id = db.Column(db.Integer, db.ForeignKey('questions.id'), primary_key=True)
    paper_id = db.Column(db.Integer, db.ForeignKey('papers.id'), primary_key=True)
    point = db.Column(db.Integer, nullable=False)

    papers = db.relationship('Paper', backref=db.backref('questions',
                                                         lazy='dynamic', cascade="delete, delete-orphan"))
    questions = db.relationship('Question', backref=db.backref('papers',
                                                               lazy='dynamic', cascade="delete, delete-orphan"))


class Question(db.Model):
    __tablename__ = "questions"
    id = db.Column(db.Integer, primary_key=True)               # 题目 ID
    # 0:单选题 1:多选题 2:不定项选择题 3: 填空题 4: 判断题 5: 问答题
    type = db.Column(db.Integer, nullable=False)               # 题目类别
    content = db.Column(db.String(2048), nullable=False)       # 题干(选择题包括选项)
    solution = db.Column(db.String(512), nullable=False)       # 题目答案
    analysis = db.Column(db.String(1024), default="")          # 答案解析

    classifies = db.relationship('Classify', secondary=question_classifies,
                                 backref=db.backref('questions', lazy='dynamic'))


class Paper(db.Model):
    def __init__(self, title, about):
        self.title = title
        self.about = about

    __tablename__ = "papers"
    id = db.Column(db.Integer, primary_key=True)        # 试卷 ID
    title = db.Column(db.String(128), nullable=False)   # 试卷标题
    about = db.Column(db.String(128), nullable=False)   # 试卷简介
    courseId = db.Column(db.Integer, db.ForeignKey('courses.id'))


class Classify(db.Model):
    __tablename__ = "classifies"
    id = db.Column(db.Integer, primary_key=True)        # 分类 ID
    name = db.Column(db.String(64), nullable=False)     # 分类名字


""" 咨询信息
@Article: 用来发布站点公告或者一些资讯、新闻信息。
"""


class Article(db.Model):
    __tablename__ = "articles"
    id = db.Column(db.Integer, primary_key=True)        # 资讯 ID
    title = db.Column(db.String(64), nullable=False)    # 资讯标题
    content = db.Column(db.Text(), nullable=False)      # 资讯正文
    visitNum = db.Column(db.Integer, default=0)         # 浏览次数

    updatedTime = db.Column(db.DateTime(), default=datetime.now)


""" 虚拟实验室模块
@Knowledge: 需要练习的技能
@Challenge: 一个技能中的一个小任务模块
@Progress: 记录用户学习某个知识的进度, 多对多的一个关系
"""


class Knowledge(db.Model):
    __tablename__ = "knowledges"
    id = db.Column(db.Integer, primary_key=True)        # 技能 ID
    title = db.Column(db.String(1024), nullable=False)  # 技能标题
    content = db.Column(db.Text(), default=None)        # 技能简介

    # 一个技能对应了很多任务, 一对多的关系。
    challenges = db.relationship('Challenge', backref='knowledge', lazy='dynamic')


class Challenge(db.Model):
    __tablename__ = "challenges"
    id = db.Column(db.Integer, primary_key=True)        # 任务 ID
    title = db.Column(db.String(1024), default=None)    # 技能标题
    content = db.Column(db.Text(), default=None)        # 知识点图文内容

    # 所属技能ID以及对应技能下任务的次序, 可以用来唯一确定一个任务
    knowledgeId = db.Column(db.Integer, db.ForeignKey('knowledges.id'))
    knowledgeNum = db.Column(db.Integer, default=1)

    # 每一个任务可能有一个教学材料, 如果 materialID == -1, 则表示没有材料, 纯图文内容。
    materialID = db.Column(db.Integer, default=-1)      # 对应的教学材料的ID

    # 每一个任务有一个测试题目
    # 对应题目的类型0:单选题 1:多选题 2:不定项选择题 3: 填空题 4: 判断题 5: 问答题 6: 编程题目
    question_type = db.Column(db.Integer, nullable=False)
    questionID = db.Column(db.Integer, nullable=False)  # 对应题目的ID


class Progress(db.Model):
    __tablename__ = "progress"

    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), primary_key=True)                # 用户 ID
    knowledge_id = db.Column(db.Integer, db.ForeignKey('knowledges.id'), primary_key=True)      # 技能 ID
    cur_progress = db.Column(db.Integer, default=0)     # 用户 user_id 在知识点 knowledge_id 上已经完成的最后一个任务

    knowledge = db.relationship('Knowledge', backref=db.backref('users',
                                                                lazy='dynamic', cascade="delete, delete-orphan"))
    user = db.relationship('User', backref=db.backref('knowledges',
                                                      lazy='dynamic', cascade="delete, delete-orphan"))
