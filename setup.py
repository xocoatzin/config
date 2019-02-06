#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import os

from setuptools import find_packages, setup


class Colors:
    """."""

    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

print(Colors.BOLD)
print(Colors.OKBLUE)
print(r"""
+----------------------------------------------------------------------+
| {0}                                                                    {1} |
| {0}  ██╗   ██╗███████╗███████╗██████╗ ███████╗     █████╗ ██████╗ ██╗  {1} |
| {0}  ██║   ██║██╔════╝██╔════╝██╔══██╗██╔════╝    ██╔══██╗██╔══██╗██║  {1} |
| {0}  ██║   ██║███████╗█████╗  ██████╔╝███████╗    ███████║██████╔╝██║  {1} |
| {0}  ██║   ██║╚════██║██╔══╝  ██╔══██╗╚════██║    ██╔══██║██╔═══╝ ██║  {1} |
| {0}  ╚██████╔╝███████║███████╗██║  ██║███████║    ██║  ██║██║     ██║  {1} |
| {0}   ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═╝╚═╝     ╚═╝  {1} |
| {0}                                                                    {1} |
+----------------------------------------------------------------------+
""".format(
    Colors.OKGREEN,
    Colors.OKBLUE,
))
print(Colors.ENDC)

here = os.path.abspath(os.path.dirname(__file__))
packages = find_packages()

about = {}
with open(os.path.join(here, 'UsersAPI', '__version__.py'), 'r') as f:
    exec(f.read(), about)

extras_require = {
    'dev': [
        'flake8',
        'flake8-junit-report',
    ]
}

all_extras = []
for dep in extras_require:
    if dep not in ['dev']:
        all_extras += extras_require[dep]
extras_require['all'] = all_extras

setup(
    name=about['__title__'],
    version=about['__version__'],
    description=about['__description__'],
    author=about['__author__'],
    author_email=about['__author_email__'],
    url=about['__url__'],
    license=about['__license__'],
    keywords='datasets development',
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'Topic :: Software Development :: Tools',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
    ],
    packages=packages,

    # KEEP THIS LIST AS SMALL AS POSSIBLE!!
    install_requires=[
        'grpcio>=1.10.0',
        'grpcio-tools>=1.10.0',
        'google-auth>=1.4.1',
        'googleapis-common-protos>=1.5.3',
        'six>=1.11',
        'future~=0.16',
        'requests>=2,<3',
        'requests[security]',
        'google-auth>=1.6,<2',
        'google-cloud-datastore>=1.7,<2',
        'arrow',
        # 'redis~=2.10',
        # 'jsonschema~=3.0.0a3 ',
        # 'arrow>=0.4.0,<1.0',
        # 'PyJWT~=1.6',
    ],
    extras_require=extras_require,
    entry_points={
        'console_scripts': [
            'users-server=UsersAPI.server:main'
        ]
    }
)
