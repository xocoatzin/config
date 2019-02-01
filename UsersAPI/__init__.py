# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import os
import sys

from UsersAPI.__version__ import *  # noqa

# Add vendor directory to module search path
parent_dir = os.path.abspath(os.path.dirname(__file__))
vendor_dir = os.path.join(parent_dir, 'vendor')

vendored_libs = [
    os.path.join(vendor_dir, 'datasets-apis-common'),
]

for lib in vendored_libs:
    sys.path.append(lib)
