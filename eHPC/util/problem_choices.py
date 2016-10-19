from . import filter_blueprint


@filter_blueprint.app_template_filter('split')
def split(string, c, n):
    return string.split(c)[n]
