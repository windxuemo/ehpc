#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os
import xlsxwriter

from flask import current_app


def get_member_xlsx(members, required_field, course_id):
    uri = os.path.join(current_app.config['DOWNLOAD_FOLDER'], 'course%d.xlsx' % course_id)
    workbook = xlsxwriter.Workbook(uri)
    worksheet = workbook.add_worksheet()
    cnt = 0
    for f in required_field:
        worksheet.write(0, cnt, f)
        cnt += 1
    row = 1
    for m in members:
        cnt = 0
        if u"姓名" in required_field:
            worksheet.write(row, cnt, m.name)
            cnt += 1
        if u"学号" in required_field:
            worksheet.write(row, cnt, m.student_id)
            cnt += 1
        if u"性别" in required_field:
            if m.gender:
                worksheet.write(row, cnt, u'男')
            else:
                worksheet.write(row, cnt, u'女')
            cnt += 1
        if u"电话" in required_field:
            worksheet.write(row, cnt, m.phone)
            cnt += 1
        if u"邮箱" in required_field:
            worksheet.write(row, cnt, m.email)
            cnt += 1
        row += 1

    workbook.close()
    return uri
