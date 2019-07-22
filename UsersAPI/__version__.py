# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

__all__ = [
    '__title__',
    '__release_date__',
    '__version__',
    '__short_version__',
    '__description__',
    '__url__',
    '__build__',
    '__author__',
    '__author_email__',
    '__license__',
    '__copyright__',
]

###############################################################################
release_date = '2019-07-22'
release_type = 1
version = (
    0,  # Major
    2,  # Minor
    5,  # Revision
)
###############################################################################

release_types = {
    0: ('Pre Alpha', '-prealpha'),
    1: ('Alpha', '-alpha'),
    2: ('Beta', '-beta'),
    3: ('Release Candidate', '-rc'),
    4: ('General Availability', ''),
}

__title__ = 'Datasets Users API gRPC Server'
__release_date__ = release_date
__version__ = '{0}.{1}.{2}{tag}'.format(
    *version,
    tag=release_types.get(release_type, release_types.get(0))[1])
__short_version__ = '{0}.{1}'.format(*version)
__description__ = 'Datasets Users API'
__url__ = 'https://datasets.magicleap.com'
__build__ = 0x0
__author__ = 'Alan Torres'
__author_email__ = 'atorresgomez@magicleap.com'
__license__ = 'None'
__copyright__ = 'Copyright 2019 Magic Leap'
