from flask import request, jsonify, abort, current_app
from . import markdown_files
from ..util.file_manage import receive_img


@markdown_files.route("/markdown/images", methods=['GET', 'POST'])
def images():
    if request.method == "POST":
        status, uri = receive_img(current_app.config['IMAGES_FOLDER'], request.files['img'], 600)
        if status:
            return jsonify(status='success', uri=uri)
        else:
            return jsonify(status="fail")
    return abort(404)

