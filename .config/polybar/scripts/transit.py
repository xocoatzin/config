"""Get next tram times."""

import datetime
import json
import subprocess
import sys

if not 17 <= datetime.datetime.now().hour < 19:
    exit(1)

data = json.loads(subprocess.check_output([
    'curl',
    '-s',
    'http://transport.opendata.ch/v1/connections?from=8591093&to=8503610&limit=3'  # noqa
]).decode())

info = [
    (
        connection.get('from', {}).get('departure', ''),
        connection.get('duration', ''),
        connection.get('products', ''),
    )
    for connection in data.get('connections', [])
]

lines = False
if len(sys.argv) >= 2:
    if sys.argv[1] == '-l':
        lines = True

records = [
    "{} via {}, {} min".format(
        t[11:16],
        "/".join(c),
        d[6:8],
    )
    for t, d, c in info
]

if lines:
    print(
        "\n".join(["\ufa2c " + r for r in records])
    )
else:
    print(
        "\ufa2c " +
        " | ".join(records)
    )
