# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import datetime
import logging
import os

from google.cloud import datastore

log = logging.getLogger(__name__)


def bootstrap():
    """Bootstrap the datastore entities."""
    datastore_project = os.environ['API_DATASTORE_PROJECT']
    datastore_namespace = os.environ['API_DATASTORE_NAMESPACE']

    now = datetime.datetime.utcnow()
    user_info = {
        'last_seen': now,
        'sub': '100000000000000',
        'email': 'someone@magicleap.com',
        'full_name': 'Someone',
        'picture': '',
        'locale': 'en',
        'given_name': 'Someone',
        'family_name': 'Someone',
    }

    log.warn('Bootstraping {}@{}'.format(
        datastore_namespace, datastore_project))

    dsclient = datastore.Client(
        project=datastore_project,
        namespace=datastore_namespace
    )

    user_key = dsclient.key('User', user_info.get('email'))
    user_entity = dsclient.get(user_key)

    # The user was found
    if user_entity:
        user_entity.update(user_info)
        dsclient.put(user_entity)
        log.info("Updated user: {}".format(user_info.get('email')))

    else:
        user_entity = datastore.Entity(key=user_key)
        user_info['created_at'] = now
        user_info['disabled'] = False
        user_entity.update(user_info)
        dsclient.put(user_entity)
        log.info(
            "Registered user: {}".format(user_info.get('email')))

    role_key = dsclient.key(
        'UserRole', 'users.admin',
        parent=user_key)
    role_entity = datastore.Entity(key=role_key)
    role_entity.update({
        'granted_by': 'bootstrap@users.datasets.magicleap.com',
        'granted_at': now
    })
    dsclient.put(role_entity)

    log.warn('Bootstrap complete')
