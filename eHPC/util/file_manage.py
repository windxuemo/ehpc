#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask_babel import gettext
from flask import current_app
from PIL import Image
import time
import os
import re


def upload_img(file_src, des_height, des_width, des_path):
    """ 保存 form 表单获取的上传图片到目标地址 des_path

    图片大小为 des_height * des_width,
    成功返回 True 和 图片携带的特征戳
    失败返回 False, 同时 message 里面携带失败信息.
    """
    if file_src.filename == '':
        message = gettext('No selected file')
        return False, message

    file_type = get_file_type(file_src.mimetype)

    if file_src and '.' in file_src.filename and file_type=="img":
        im = Image.open(file_src)
        # 比例会有问题
        im = im.resize((des_width, des_height), Image.ANTIALIAS)
        im.save(des_path, 'PNG')

        unique_uri = os.stat(des_path).st_mtime
        return True, unique_uri
    else:
        message = gettext("Invalid file")
        return False, message


def receive_img(path, uri_to_return, img, height_coe=1, width_coe=1):
    """ Markdown 编辑框上传图片后台处理核心函数。

    后台将图片文件 img , 按照 height_code * width_core (默认存放原尺寸)进行处理,
    然后保存到 path 路径指定的位置。
    返回值为一个元组:
        0. 也是一个元组: (是否上传成功的状态, 如果成功对应文件唯一的字符串或者失败对应反馈信息)
        1. 图片路径(返回给前端用)
    """
    cur_time = time.strftime("%Y%m%d%H%M%S", time.localtime()) + ".png"
    path = os.path.join(path, cur_time)
    temp = Image.open(img)
    status = upload_img(img, int(temp.height*height_coe), int(temp.width*width_coe), path)
    return status, os.path.join(uri_to_return, cur_time)


def upload_file(file_src, des_path):
    """ 保存 form 表单获取的文件到目标地址 des_path

    成功返回 True, 同时 unique_uri 里面携带文件信息(用于更新资源链接, 防止缓存)
    失败返回 False, 同时 message 里面携带失败信息.
    """
    if file_src.filename == '':
        message = gettext('No selected file')
        return False, message

    allowed_extensions = current_app.config['ALLOWED_RESOURCE_EXTENSIONS']
    file_type = get_file_type(file_src.mimetype)

    folder = des_path[:des_path.rfind('/')]

    if file_src and '.' in file_src.filename and file_type in allowed_extensions:
        if not os.path.exists(folder):
            os.mkdir(folder)
        file_src.save(des_path)
        unique_uri = os.stat(des_path).st_mtime
        return True, unique_uri
    else:
        message = gettext("Invalid file")
        return False, message


def get_file_type(form_file_type):
    """ 获取 form 表单上传文件的类型

    @from_file_type: Flask 获取到的 mimetype 类型
    """

    file_type_dict = {
        # "application/msword": "doc",
        "application/pdf": "pdf",
        "video/mp4": "video",
        "audio/mp3": "audio",
        # "application/vnd.ms-powerpoint": "ppt",
        # "application/vnd.openxmlformats-officedocument.presentationml.presentation": "ppt",
        "video/x-matroska": "video",
        "audio/mpeg": "audio",
        "image/png": "img",
        "image/jpeg": "img",
        "image/bmp": "img",
        "text/plain": "code",
        "text/css": "code",
        "text/html": "code",
        "text/javascript": "code",
        "application/javascript": "code",
        "text/x-python-script": 'code',
    }

    return file_type_dict.get(form_file_type, "Unknown")


def custom_secure_filename(filename):
    """ 将不安全的文件名转换为安全的可以在文件系统实用的安全文件名

    print custom_secure_filename('a/a/a/a.com')
    print custom_secure_filename('My cool movie.mov')
    print custom_secure_filename('../../中文测试.pdf')

    https://github.com/pallets/werkzeug/blob/0bc61df6e1ae9f2ffdf5d066aa3cd9d5ebcb307d/werkzeug/utils.py
    """
    filename = filename.encode('utf-8')

    for sep in os.path.sep, os.path.altsep:
        if sep:
            filename = filename.replace(sep, ' ')

    # unicode 中文编码范围为 /u4e00-/u9fa5
    _filename_zh_ascii_strip_re = re.compile(u"[^A-Za-z0-9_.-\u4e00-\u9fa5]")
    _windows_device_files = ('CON', 'AUX', 'COM1', 'COM2', 'COM3', 'COM4', 'LPT1',
                             'LPT2', 'LPT3', 'PRN', 'NUL')

    filename = str(_filename_zh_ascii_strip_re.sub('', '_'.join(filename.split()))).strip('._')

    # on nt a couple of special files are present in each folder.  We
    # have to ensure that the target file is not such a filename.  In
    # this case we prepend an underline
    if os.name == 'nt' and filename and filename.split('.')[0].upper() in _windows_device_files:
        filename = '_' + filename

    return filename
