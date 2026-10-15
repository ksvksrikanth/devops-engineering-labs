"""Report mounted local volumes and alert when disk use meets a threshold."""
import argparse
import shutil
import psutil
from _common import report, run, timestamp


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--threshold', type=float, default=80)
    parser.add_argument('--path', action='append', help='Check this path instead of discovering volumes; repeatable')
    parser.add_argument('--log', help='Append JSON lines to this existing parent directory')
    args = parser.parse_args()
    if not 0 < args.threshold <= 100:
        parser.error('threshold must be greater than zero and at most 100')
    paths = args.path or list(dict.fromkeys(p.mountpoint for p in psutil.disk_partitions(all=False)))
    if not paths:
        raise RuntimeError('No local volumes discovered; specify --path')
    warning = False
    error = False
    for path in paths:
        try:
            usage = shutil.disk_usage(path)
            percent = usage.used / usage.total * 100
            alert = percent >= args.threshold
            warning |= alert
            report(dict(timestamp=timestamp(), path=path, total_bytes=usage.total,
                        free_bytes=usage.free, used_percent=round(percent, 2),
                        status='WARNING' if alert else 'OK'), args.log)
        except OSError as exc:
            error = True
            report(dict(timestamp=timestamp(), path=path, status='ERROR', error=str(exc)), args.log)
    return 2 if error else 1 if warning else 0


if __name__ == '__main__':
    run(main)
