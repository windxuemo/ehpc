#! /usr/bin/env python
# -*- coding: utf-8 -*-
from ..models import Question, Program
import json


def get_question_and_type(question_id, question_type):
    question, q_type = None, None
    # 得到具体的问题实体
    if question_type in [0, 1, 2, 3, 4, 5]:
        question = Question.query.filter_by(id=question_id).first_or_404()
    elif question_type == 6:
        question = Program.query.filter_by(id=question_id).first_or_404()
    else:
        return None, None

    # 将问题的类型转换为字符串
    if question_type in [0, 1, 2]:
        q_type = "choice"
    elif question_type == 3:
        q_type = "fill"
    elif question_type == 4:
        q_type = "judge"
    elif question_type == 5:
        q_type = "essay"
    elif question_type == 6:
        q_type = "program"
    else:
        pass

    return question, q_type


def check_if_correct(cur_question, user_sol):       # 不包含编程题
    transfer = {0: 'choice', 1: 'choice', 2: 'choice', 3: 'fill', 4: 'judge', 5: 'essay'}
    if transfer[cur_question.type] == 'choice':     # 选择题，直接比较即可
        if cur_question.solution != user_sol:
            return False
    elif transfer[cur_question.type] == 'fill':     # 填空题json格式
        user_sol = json.loads(user_sol)
        for i in range(user_sol['len']):
            if user_sol[unicode(i)] != json.loads(cur_question.solution)[unicode(i)]:
                return False
    elif transfer[cur_question.type] == 'judge':    # 判断题，0-错误，1-正确
        if cur_question.solution != user_sol:
            return False
    elif transfer[cur_question.type] == 'essay':
        pass
    return True
