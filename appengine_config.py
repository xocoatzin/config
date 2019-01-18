# -*- coding: utf-8 -*-
"""Datasets Users API.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import os

from google.appengine.ext import vendor

# Add any libraries installed in the `lib` folder.
vendor.add('lib')


def namespace_manager_default_namespace_for_request():
    """Configure the default namespace for App Engine services.

    See:
        https://cloud.google.com/appengine/docs/python/multitenancy/multitenancy
    """
    return os.environ.get('GAE_NAMESPACE', '')
