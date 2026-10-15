"""Validate required environment variables, JSON/YAML syntax, and TCP dependencies."""
import argparse
import json
import os
from pathlib import Path
import socket
import yaml
from _common import positive, report, run, timestamp


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--env', action='append', default=[])
    parser.add_argument('--config', type=Path, action='append', default=[])
    parser.add_argument('--tcp', nargs=2, action='append', metavar=('HOST', 'PORT'), default=[])
    parser.add_argument('--timeout', type=positive, default=5)
    args = parser.parse_args()
    if not (args.env or args.config or args.tcp):
        parser.error('Provide at least one --env, --config, or --tcp check')
    failed = False
    for name in args.env:
        ok = bool(os.environ.get(name, '').strip())
        failed |= not ok
        report(dict(timestamp=timestamp(), environment_variable=name, status='OK' if ok else 'FAIL'))
    for path in args.config:
        try:
            with path.open(encoding='utf-8-sig') as handle:
                if path.suffix.lower() == '.json':
                    json.load(handle, parse_constant=lambda value: (_ for _ in ()).throw(ValueError('Invalid JSON constant')))
                elif path.suffix.lower() in ('.yaml', '.yml'):
                    list(yaml.safe_load_all(handle))
                else:
                    raise ValueError('Use .json, .yaml or .yml')
            report(dict(timestamp=timestamp(), config=str(path), status='OK'))
        except (OSError, ValueError, yaml.YAMLError) as exc:
            failed = True
            # Parser messages can contain config values, so report only the type.
            report(dict(timestamp=timestamp(), config=str(path), status='FAIL', error_type=type(exc).__name__))
    for host, port in args.tcp:
        try:
            number = int(port)
            if not 1 <= number <= 65535:
                raise ValueError('Invalid port')
            with socket.create_connection((host, number), timeout=args.timeout):
                pass
            report(dict(timestamp=timestamp(), host=host, port=number, status='OK'))
        except (OSError, ValueError):
            failed = True
            report(dict(timestamp=timestamp(), host=host, port=port, status='FAIL'))
    return 1 if failed else 0


if __name__ == '__main__':
    run(main)
