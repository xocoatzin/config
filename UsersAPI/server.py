# -*- coding: utf-8 -*-
"""Datasets APIs.

Style Guide:
   http://google.github.io/styleguide/pyguide.html
   http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
"""

import argparse
from concurrent import futures
import logging
import time
import os

import grpc

from ApiCommon.logging import config_logger

import UsersAPI
from UsersAPI import api_pb2_grpc as pb2_grpc
from UsersAPI.servicer.servicer import UsersServicer, TokensServicer

log = logging.getLogger(__name__)


def serve(port, shutdown_grace_duration):
    """Configure and runs the Metrics API server."""
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))

    pb2_grpc.add_UsersServicer_to_server(
        UsersServicer(
            secret=os.environ['API_SECRET'],
            datastore_project=os.environ['API_DATASTORE_PROJECT'],
            datastore_namespace=os.environ['API_DATASTORE_NAMESPACE'],
        ),
        server)
    pb2_grpc.add_TokensServicer_to_server(
        TokensServicer(
            secret=os.environ['API_SECRET'],
            datastore_project=os.environ['API_DATASTORE_PROJECT'],
            datastore_namespace=os.environ['API_DATASTORE_NAMESPACE'],
        ),
        server)

    server.add_insecure_port('[::]:{}'.format(port))
    log.info("Starting {} v{}".format(
        UsersAPI.__title__,
        UsersAPI.__version__))
    server.start()

    try:
        while True:
            time.sleep(60 * 60 * 24)  # One day, in seconds
    except KeyboardInterrupt:
        server.stop(shutdown_grace_duration)


def main():
    """.Entry point."""
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
        '--text-logs', action='store_true')
    parser.add_argument(
        '--port', type=int, default=8081, help='The port to listen on')
    parser.add_argument(
        '--shutdown_grace_duration', type=int, default=5,
        help='The shutdown grace duration, in seconds')
    args = parser.parse_args()

    config_logger(not args.text_logs)
    serve(args.port, args.shutdown_grace_duration)


if __name__ == '__main__':
    main()
