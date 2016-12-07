# -*- coding: utf-8 -*-

from PIL import Image
import time
import os
from flask import jsonify
from ..util.file_manage import upload_img

# path: 图片文件储存路径
# uri_to_return: 需返回给前端的图片地址(例如static/upload/case)
# img: 图片文件
# height_coe: 图片高度resize系数，默认0.2
# width_coe: 图片宽度resize系数，默认0.2


def receive_img(path, uri_to_return, img, height_coe=0.2, width_coe=0.2):
    cur_time = time.strftime("%Y%m%d%H%M%S", time.localtime()) + ".png"
    path = os.path.join(path, cur_time)
    temp = Image.open(img)
    status = upload_img(img, int(temp.height*height_coe), int(temp.width*width_coe), path)
    return status, os.path.join(uri_to_return, cur_time)
