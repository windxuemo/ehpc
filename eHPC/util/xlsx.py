#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os
import xlsxwriter

from flask import current_app


def get_member_xlsx(data, course_id):
    uri = os.path.join(current_app.config['DOWNLOAD_FOLDER'], 'course%d.xlsx' % course_id)
    workbook = xlsxwriter.Workbook(uri)
    worksheet = workbook.add_worksheet()
    worksheet.write(0, 0, u'邮箱')
    worksheet.write(0, 1, u'姓名')
    worksheet.write(0, 2, u'学号')
    worksheet.write(0, 3, u'性别')
    worksheet.write(0, 4, u'手机')
    row = 1
    for a, b, c, d, e in data:
        worksheet.write(row, 0, a)
        worksheet.write(row, 1, b)
        worksheet.write(row, 2, c)
        worksheet.write(row, 3, d)
        worksheet.write(row, 4, e)
        row += 1
    workbook.close()
    return uri
