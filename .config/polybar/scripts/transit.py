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

kappeli = '8591222'
altstetten = '8503001'
oerlikon = '8503006'

connections = []
for dest in (altstetten, kappeli):
    dest_data = json.loads(subprocess.check_output([
        'curl',
        '-s',
        'http://transport.opendata.ch/v1/connections?from={from_}&to={dest}&limit=4'.format( # noqa
            from_=oerlikon,
            dest=dest,
        )
    ]).decode())
    connections += dest_data.get("connections", [])

info = [
    (
        connection.get('from', {}).get('departure', ''),
        connection.get('from', {}).get('platform', ''),
        connection.get('duration', ''),
        connection.get('products', ''),
        " ".join(connection.get('sections', [])[0].get('arrival', {}).get('location', {}).get('name', '').split()[1:])
    )
    for connection in sorted(connections, key=lambda x: x['from']['departure'])
]

records = [
    "{} ({} min) {} Pl {} - Via {}".format(
        t[11:16],
        d[6:8],
        "/".join(c),
        p,
        via,
    )
    for t, p, d, c, via in info
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
