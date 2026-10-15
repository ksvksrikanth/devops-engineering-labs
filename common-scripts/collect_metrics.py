"""Sample CPU utilization and RAM into timestamped CSV records."""
import argparse
import csv
import socket
from pathlib import Path
import psutil
from _common import positive, run, timestamp

FIELDS = ['timestamp_utc', 'hostname', 'cpu_percent', 'memory_percent', 'memory_total_bytes', 'memory_available_bytes', 'memory_used_bytes']


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--samples', type=int, default=1)
    parser.add_argument('--interval', type=positive, default=1)
    args = parser.parse_args()
    if args.samples < 1:
        parser.error('samples must be at least 1')
    existing = args.output.exists() and args.output.stat().st_size > 0
    if existing:
        with args.output.open(newline='', encoding='utf-8') as handle:
            if next(csv.reader(handle), None) != FIELDS:
                raise ValueError('Existing CSV has an incompatible header')
    with args.output.open('a', newline='', encoding='utf-8') as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDS)
        if not existing:
            writer.writeheader()
        for _ in range(args.samples):
            cpu = psutil.cpu_percent(interval=args.interval)
            memory = psutil.virtual_memory()
            writer.writerow(dict(timestamp_utc=timestamp(), hostname=socket.gethostname(), cpu_percent=cpu,
                                 memory_percent=memory.percent, memory_total_bytes=memory.total,
                                 memory_available_bytes=memory.available, memory_used_bytes=memory.total-memory.available))
            handle.flush()
    print(f'Wrote {args.samples} samples to {args.output}')


if __name__ == '__main__':
    run(main)
