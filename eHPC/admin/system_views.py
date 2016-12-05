#! /usr/bin/env python
# -*- coding: utf-8 -*-
from flask import render_template, request, redirect, url_for, abort, jsonify, current_app
from datetime import datetime
from ..user.authorize import system_login
from . import admin
from ..models import User, Classify, Article, Group, Case
from .. import db
from flask_babel import gettext
import os
from ..util.file_manage import upload_img, upload_file, get_file_type, custom_secure_filename


@admin.route('/')
@system_login
def index():
    return render_template('admin/system.html',
                           title=gettext("System Admin"),
                           user_cnt=User.query.count(),
                           article_cnt=Article.query.count(),
                           group_cnt=Group.query.count(),
                           case_cnt=Case.query.count())


@admin.route('/users/')
@system_login
def user():
    all_users = User.query.all()
    return render_template('admin/user/index.html', users=all_users,
                           title=gettext("User Admin"))


@admin.route('/user/edit/<int:uid>/', methods=['GET', 'POST'])
@system_login
def user_edit(uid):
    u = User.query.filter_by(id=uid).first_or_404()
    if request.method == "GET":
        return render_template('admin/user/edit.html', user=u)
    elif request.method == "POST":
        u.permissions = request.form["permission"]
        db.session.commit()
        message_success = gettext('Successfully modify permission')
        return render_template('admin/user/edit.html', user=u,
                               message_success=message_success,
                               title=gettext('User Edit'))


@admin.route('/articles/')
@system_login
def article():
    articles = Article.query.all()
    return render_template('admin/article/index.html',
                           title=gettext('Articles Admin'),
                           articles=articles)


@admin.route('/article/create/', methods=['POST', 'GET'])
@system_login
def article_create():
    if request.method == 'GET':
        return render_template('admin/article/create.html', title=gettext('Create Article'))
    if request.method == 'POST':
        title = request.form['title']
        content = request.form['content']
        new_article = Article(title=title, content=content)
        db.session.add(new_article)
        db.session.commit()
        return redirect(url_for('admin.article'))


@admin.route('/article/<int:aid>/edit/', methods=['POST', 'GET'])
@system_login
def article_edit(aid):
    cur_article = Article.query.filter_by(id=aid).first_or_404()
    if request.method == "GET":
        return render_template('admin/article/edit.html',
                               title=cur_article.title,
                               article=cur_article)
    elif request.method == "POST":
        title = request.form['title']
        content = request.form['content']
        cur_article.title = title
        cur_article.content = content
        cur_article.updatedTime = datetime.now()
        db.session.commit()
        return redirect(url_for('admin.article'))


@admin.route('/article/delete/', methods=['POST', 'GET'])
@system_login
def article_delete():
    cur_article = Article.query.filter_by(id=request.form['id']).first_or_404()
    db.session.delete(cur_article)
    db.session.commit()
    return jsonify(status="success", del_article_id=cur_article.id)


@admin.route('/groups/')
@system_login
def group():
    groups = Group.query.all()
    return render_template('admin/group/index.html',
                           title=gettext('Groups Admin'),
                           groups=groups)


@admin.route('/group/create/', methods=['POST', 'GET'])
@system_login
def group_create():
    if request.method == 'GET':
        return render_template('admin/group/create.html', title=gettext('Create Group'))
    if request.method == 'POST':
        title = request.form['title']
        about = request.form['about']
        new_group = Group(title, about)
        db.session.add(new_group)
        db.session.commit()

        # 保存图片 logo, 注意 upload_img 返回的是元组: (成功或者失败, 相关信息)
        logo = request.files['logo']
        image_path = os.path.join(current_app.config['UPLOAD_FOLDER'], "group_logo", "%d.png" % new_group.id)
        status = upload_img(logo, 200, 200, image_path)
        if status[0]:
            new_group.logo = url_for('static',
                                     filename='upload/group_logo/%d.png' % new_group.id, t=status[1])
            db.session.commit()
            return redirect(url_for('group.group_view', gid=new_group.id))
        else:
            return redirect(url_for('group.group_edit', gid=new_group.id),
                            message=status[1])


@admin.route('/group/<int:gid>/edit/', methods=['POST', 'GET'])
@system_login
def group_edit(gid):
    cur_group = Group.query.filter_by(id=gid).first_or_404()
    if request.method == "GET":
        return render_template('admin/group/edit.html',
                               title=cur_group.title,
                               group=cur_group)
    elif request.method == "POST":
        cur_group.title = request.form['title']
        cur_group.about = request.form['about']
        logo = request.files['logo']
        image_path = os.path.join(current_app.config['UPLOAD_FOLDER'], "group_logo", "%d.png" % cur_group.id)
        status = upload_img(logo, 200, 200, image_path)
        if status[0]:
            cur_group.logo = url_for('static',
                                     filename='upload/group_logo/%d.png' % cur_group.id, t=status[1])
        db.session.commit()
        return redirect(url_for('group.group_view', gid=cur_group.id))


@admin.route('/group/delete/', methods=['POST', 'GET'])
@system_login
def group_delete():
    cur_group = Group.query.filter_by(id=request.form['gid']).first_or_404()
    db.session.delete(cur_group)
    db.session.commit()
    return jsonify(status="success", del_article_id=cur_group.id)


@admin.route('/cases/')
@system_login
def case():
    cases = Case.query.all()
    return render_template('admin/case/index.html',
                           title=gettext('Case Admin'),
                           cases=cases)



@admin.route('/case/create/', methods=['POST', 'GET'])
@system_login
def case_create():
    if request.method == 'GET':
        return render_template('admin/case/create.html', title=gettext('Create Case'))
    if request.method == 'POST':
        name = request.form['name']
        tags = request.form['tags']
        description = request.form['description']
        new_case = Case(name=name, description=description, tag=tags)
        db.session.add(new_case)
        db.session.commit()
        path = os.path.join(current_app.config['CASE_FOLDER'], "%d" % new_case.id)
        os.mkdir(path)
        return redirect(url_for('admin.case'))

@admin.route('/case/<int:case_id>/edit/', methods=['POST', 'GET'])
@system_login
def case_edit(case_id):
    cur_case = Case.query.filter_by(id=case_id).first_or_404()
    if request.method == "GET":
        if cur_case.tag!= "":
            tags = cur_case.tag.split(";")
            return render_template('admin/case/edit_case_info.html',
                               title=cur_case.name,
                               case=cur_case,
                               tags=tags)
        else:
            return render_template('admin/case/edit_case_info.html',
                               title=cur_case.name,
                               case=cur_case)
    elif request.method == "POST":
        cur_case.name = request.form['name']
        cur_case.description = request.form['description']
        cur_case.tag = request.form['tags']
        db.session.commit()
        return redirect(url_for('admin.case_edit',case_id=case_id))

@admin.route('/case/delete/', methods=['POST', 'GET'])
@system_login
def case_delete():
    cur_case = Case.query.filter_by(id=request.form['cid']).first_or_404()
    versions = cur_case.codes
    path = os.path.join(current_app.config['CASE_FOLDER'],"%d" % cur_case.id)
    for v in versions:
        version_path = os.path.join(current_app.config['CASE_FOLDER'], v.code_path)
        materials = list(os.walk(version_path))[0][2]
        for m in materials:
            curr_material_uri = os.path.join("%s" % version_path, "%s" % m)
            #print curr_material_uri
            try:
                os.remove(os.path.join(current_app.config['CASE_FOLDER'], curr_material_uri))
            except OSError:
                pass
        os.rmdir(version_path)
    os.rmdir(path)
    db.session.delete(cur_case)
    db.session.commit()
    return jsonify(status="success", del_case_id=cur_case.id)

@admin.route('/case/<int:case_id>/version/', methods=['GET', 'POST'])
@system_login
def case_version(case_id):
    if request.method == 'GET':
        curr_case = Case.query.filter_by(id=case_id).first_or_404()
        all_versions = CaseCode.query.filter_by(case_id=case_id).all()
        return render_template('admin/case/edit_case_version.html',
                               title=gettext('Case Version'),
                               versions=all_versions,
                               case=curr_case)
    elif request.method == 'POST':
        # 案例版本的增删查改
        if request.form['op'] == 'create':
            curr_case = Case.query.filter_by(id=case_id).first_or_404()
            all_versions = curr_case.codes
            index = 0
            for v in all_versions:
                if v.version_id > index:
                    index = v.version_id
            curr_version = CaseCode(case_id=case_id, version_id=index+1, name=request.form['name'], description=request.form['description'])
            curr_version.version_id = index+1;
            curr_version.code_path = os.path.join("%d" % case_id, "version_%d" % curr_version.version_id)
            db.session.add(curr_version)
            curr_case.codes.append(curr_version)
            db.session.commit()
            path = os.path.join(current_app.config['CASE_FOLDER'], curr_version.code_path)
            os.mkdir(path)
            return jsonify(status="success", id=curr_version.version_id)
        elif request.form['op'] == "edit":
            curr_case = Case.query.filter_by(id=case_id).first_or_404()
            curr_version = curr_case.codes.filter_by(version_id=request.form['version_id']).first_or_404()
            curr_version.name = request.form['name']
            curr_version.description = request.form['description']
            db.session.commit()
            return jsonify(status="success", id=curr_version.version_id)
        elif request.form['op'] == "del":            
            curr_case = Case.query.filter_by(id=case_id).first_or_404()
            curr_version = curr_case.codes.filter_by(case_id=case_id,version_id=request.form['version_id']).first_or_404()
            path = os.path.join(current_app.config['CASE_FOLDER'], curr_version.code_path)
            materials = list(os.walk(path))[0][2]
            for m in materials:
                curr_material_uri = os.path.join("%s" % path, "%s" % m)
                #print curr_material_uri
                try:
                    os.remove(os.path.join(current_app.config['CASE_FOLDER'], curr_material_uri))
                except OSError:
                    pass
            os.rmdir(path)
            curr_case.codes.remove(curr_version)
            db.session.delete(curr_version)
            db.session.commit()
            return jsonify(status="success", id=curr_version.version_id)
        elif request.form['op'] == 'data':
            curr_version = CaseCode.query.filter_by(case_id=case_id,version_id=request.form['version_id']).first_or_404()
            return jsonify(status="success", name=curr_version.name, description=curr_version.description)

@admin.route('/case/<int:case_id>/version/<int:version_id>/material/', methods=['GET', 'POST'])
@system_login
def case_version_material(case_id, version_id):
    if request.method == 'GET':
        curr_case = Case.query.filter_by(id=case_id).first_or_404()
        curr_version = curr_case.codes.filter_by(version_id=version_id).first_or_404()
        path = os.path.join(current_app.config['CASE_FOLDER'], curr_version.code_path)
        materials = list(os.walk(path))[0][2]
        #for m in materials:
        #    print m
        return render_template('admin/case/case_code_materials.html', case=curr_case,
                               version=curr_version,
                               materials=materials,
                               title=gettext('Case Code Material'))
    elif request.method == 'POST':
        # 课时材料的上传和删除            
        if request.form['op'] == "del":
            materials = request.form.getlist('material_name[]')
            for m in materials:
                # 需要在课时对象中删除该资源
                curr_material_uri = os.path.join("%d" % case_id, "version_%d" % version_id, "%s" % m)
                #print curr_material_uri
                try:
                    os.remove(os.path.join(current_app.config['CASE_FOLDER'], curr_material_uri))
                except OSError:
                    pass
            return jsonify(status="success", version_id=version_id)

@admin.route('/case/<int:case_id>/version/<int:version_id>/material/reload_version')
@system_login
def reload_case_material(case_id,version_id):
    """ 重载版本源文件表 """
    curr_case = Case.query.filter_by(id=case_id).first_or_404()
    curr_version = curr_case.codes.filter_by(version_id=version_id).first_or_404()
    path = os.path.join(current_app.config['CASE_FOLDER'], curr_version.code_path)
    materials = list(os.walk(path))[0][2]
    return render_template('admin/case/widget_material_list.html',materials=materials)


# 本地文件上传
@admin.route('/case/<int:case_id>/version/<int:version_id>/material/upload', methods=['POST'])
@system_login
def case_upload(case_id,version_id):
    cur_case = Case.query.filter_by(id=case_id).first_or_404()
    cur_version = cur_case.codes.filter_by(version_id=version_id).first_or_404()
    material_name=custom_secure_filename(request.form['name'])
    material=request.files['file']
    filename= material_name.encode("utf-8")
    material_uri = os.path.join("%d" % case_id, "version_%d" % version_id, "%s" % filename)
    #print m.uri
    status = upload_file(material, os.path.join(current_app.config['CASE_FOLDER'], material_uri))
    return render_template('admin/case/upload.html')