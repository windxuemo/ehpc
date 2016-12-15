from flask import request, jsonify, current_app, abort
from . import markdown_files
import os
from ..util.file_manage import receive_img


@markdown_files.route("/markdown/images", methods=['GET', 'POST'])
def images():
    if request.method == "POST":
        uri = '/static/upload/markdown/images'
        status, uri = receive_img(current_app.config['IMAGES_FOLDER'], uri, request.files['img'], 200)
        if status[0]:
            return jsonify(status='success', uri=uri)
        else:
            return jsonify(status="fail")
    return abort(404)

