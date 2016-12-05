from . import filter_blueprint


@filter_blueprint.app_template_filter('get_files_list')
def get_files_list(materials):
    files = []
    for m in materials:
        files.append(m.name)
    return files
