# -*- coding: utf-8 -*-
"""Datasets Users API.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""


from google.appengine.ext import ndb

__all__ = [
    'KNOWN_ROLES',
    '_User',
]

KNOWN_ROLES = [
    'user',  # Legacy
    'admin',  # Legacy
    # 'datasets.user',
    'runtime.user',
    'runtime.executor',
    'runtime4.user',
    'runtime4.admin',
    'metrics.user'
]


def normalize(string):
    """Convert a `str` (likely a _User name) to lowercase.

    Args:
        string (str): Potentially mixed-caps `str` to request lowercase
            conversion of.

    Returns:
        str: Lowercase-converted `str`.
    """
    return string.lower()


class _User(ndb.Model):
    """_User Model.

    Attributes:
        disbaled (bool, optional): Whether or not a _User has been disabled.
            Defaults to False.
        avatar (str, optional): URL containing location of _User's Google
            account image. Defaults to None.
        name (str, optional): Name of _User.
        name_normalized (str, computed): Lowercase-converted _User().name.
        email (str, optional): Google-managed email account of _User. Defaults
            to "none".
        created_at (datetime.datetime, optional): Searchable field describing
            time _User was created.
        roles (list, optional): Taken from choices found at
            API_CREDENTIALS_PER_ROLE. Allows access to _Recordings and Runtime
            capabilities based on entries.
        groups (ndb.Key, optional): _UserGroup entities.
        refresh_token (str): The OAuth 2.0 refresh token. If specified,
            credentials can be refreshed.
        client_id (str): The client ID used to generate the refresh token.
    """

    disabled = ndb.BooleanProperty(default=False)
    avatar = ndb.StringProperty(default=None)
    name = ndb.StringProperty(default="User")
    name_normalized = ndb.ComputedProperty(lambda self: normalize(self.name))
    email = ndb.StringProperty(default="none")
    created_at = ndb.DateTimeProperty(auto_now_add=True)
    roles = ndb.StringProperty(choices=KNOWN_ROLES, repeated=True)
    groups = ndb.KeyProperty(repeated=True, kind='_UserGroup')
    refresh_token = ndb.StringProperty(default=None)
    client_id = ndb.StringProperty(default=None)
