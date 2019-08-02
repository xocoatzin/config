# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import datetime
import itertools
import time

from google.protobuf.timestamp_pb2 import Timestamp

from UsersAPI.lib.magicleap.datasets import users_pb2 as pb2


def parse_name(name):
    """."""
    # TODO: What if null
    return {
        item[0]: item[1]
        for item in itertools.zip_longest(*(iter(name.split('/')),) * 2)
    }


def to_pb2_timestamp(d):
    """Convert a timestamp to a protobuf."""
    timestamp = Timestamp()
    timestamp.FromDatetime(datetime.datetime.fromtimestamp(
        time.mktime(d.timetuple())))
    return timestamp


def group_to_pb2(entity):
    """Convert a datastore entity to protobuf."""
    return pb2.Group(
        name='groups/{}'.format(entity.key.name),
        title=entity.get('title'),
        description=entity.get('title'),
        creation_time=to_pb2_timestamp(entity.get('created_at')),
        created_by=entity.get('created_by'),
    )


def user_to_pb2(entity, admin_view=False):
    """Convert a datastore entity to protobuf."""
    # Display full details only to admins.
    if admin_view:
        return pb2.User(
            name='users/{}'.format(entity.get('email')),
            email=entity.get('email'),
            full_name=entity.get('full_name'),
            given_name=entity.get('given_name'),
            family_name=entity.get('family_name'),
            picture=entity.get('picture'),
            locale=entity.get('locale'),
            disabled=entity.get('disabled', False),
            creation_time=to_pb2_timestamp(entity.get('created_at')),
            last_seen_time=to_pb2_timestamp(entity.get('last_seen')),
        )
    return pb2.User(
        name='users/{}'.format(entity.get('email')),
        email=entity.get('email'),
        full_name=entity.get('full_name'),
        picture=entity.get('picture'),
    )
