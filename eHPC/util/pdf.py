#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os
import json

from flask import current_app
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.cidfonts import UnicodeCIDFont
from ..models import Paper


def get_paper_pdf(paper_id):
    path = os.path.join(current_app.config['DOWNLOAD_FOLDER'], 'paper%d.pdf' % paper_id)
    if os.path.exists(path):
        return path

    paper = Paper.query.filter_by(id=paper_id).first_or_404()
    doc = SimpleDocTemplate(path, pagesize=A4, rightMargin=72, leftMargin=72, topMargin=72, bottomMargin=18)
    content = []
    pdfmetrics.registerFont(UnicodeCIDFont('STSong-Light'))
    ParagraphStyle.defaults['wordWrap'] = 'CJK'

    styles = getSampleStyleSheet()
    zh_style = styles['Normal']
    zh_style.fontName = 'STSong-Light'
    zh_style.leading = 18

    ptext = u'<para alignment=center fontSize=20><b>%s</b></para>' % paper.title
    content.append(Paragraph(ptext, zh_style))
    content.append(Spacer(1, 12))

    idx = 1
    for aux in paper.questions:
        content.append(Paragraph(u'%d.%s' % (idx, get_question_content(aux.questions)), zh_style))
        content.append(Spacer(1, 20))
        idx += 1

    doc.build(content)
    return path


def get_question_content(question):
    # 0:单选题 1:多选题 2:不定项选择题 3: 填空题 4: 判断题 5: 问答题
    if question.type == 0 or question.type == 1 or question.type == 2:
        content = json.loads(question.content)
        length = content['len']
        ptext = content['title']
        idx = 0
        for i in range(length):
            ptext += '<br/>%s. %s' % (chr(ord('A') + idx), content['%d' % i])
            idx += 1
        return ptext
    elif question.type == 3:
        return '____'.join(question.content.split('*')[0::2])
    else:
        return question.content
