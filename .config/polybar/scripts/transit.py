"""Get next tram times."""

import datetime
import json
import subprocess
import sys

lines = False
if len(sys.argv) >= 2:
    if sys.argv[1] == '-l':
        lines = True

if not lines and not 17 <= datetime.datetime.now().hour < 19:
    exit(1)

data = json.loads(subprocess.check_output([
    'curl',
    '-s',
    'http://transport.opendata.ch/v1/connections?from=8503006&to=8503610&limit=4&via=8503020'  # noqa
]).decode())

info = [
    (
        connection.get('from', {}).get('departure', ''),
        connection.get('from', {}).get('platform', ''),
        connection.get('duration', ''),
        connection.get('products', ''),
    )
    for connection in data.get('connections', [])
]

records = [
    "{} ({} min) {} Pl {}".format(
        t[11:16],
        d[6:8],
        "/".join(c),
        p,
    )
    for t, p, d, c in info
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
