"""Shared CLI helpers. Python 3.10+."""
import argparse
import json
import sys
from datetime import datetime, timezone


def timestamp():
    return datetime.now(timezone.utc).isoformat()


def positive(value):
    number = float(value)
    if not 0 < number < float('inf'):
        raise argparse.ArgumentTypeError('must be a finite positive number')
    return number


def report(data, log=None):
    line = json.dumps(data)
    print(line)
    if log:
        with open(log, 'a', encoding='utf-8') as handle:
            handle.write(line + '\n')


def run(main):
    try:
        sys.exit(main() or 0)
    except KeyboardInterrupt:
        sys.exit(130)
    except Exception as exc:
        print(f'ERROR: {exc}', file=sys.stderr)
        sys.exit(2)
