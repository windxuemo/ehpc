#! /usr/bin/env python
# -*- coding: utf-8 -*-
from ..models import Question, Program


def get_question_and_type(question_id, question_type):
    question, q_type = None, None
    # 得到具体的问题实体
    if question_type in [0, 1, 2, 3, 4, 5]:
        question = Question.query.filter_by(id=question_id)
    elif question_type == 6:
        question = Program.query.filter_by(id=question_id)
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
