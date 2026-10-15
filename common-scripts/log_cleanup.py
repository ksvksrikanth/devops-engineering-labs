"""Preview old log files; delete only when --apply is explicitly provided."""
import argparse
import os
from pathlib import Path
import stat
import time
from _common import positive, report, run, timestamp


def linked(path):
    info = path.lstat()
    return stat.S_ISLNK(info.st_mode) or bool(getattr(info, 'st_file_attributes', 0) & 0x400)


def candidates(root, pattern, cutoff):
    def scan_error(error):
        raise error
    for directory, dirs, files in os.walk(root, followlinks=False, onerror=scan_error):
        dirs[:] = [name for name in dirs if not linked(Path(directory) / name)]
        for name in files:
            path = Path(directory) / name
            if path.match(pattern) and not linked(path):
                info = path.stat()
                if stat.S_ISREG(info.st_mode) and info.st_mtime < cutoff:
                    yield path, info


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory', type=Path)
    parser.add_argument('--days', type=positive, default=30)
    parser.add_argument('--pattern', default='*.log', help='Filename glob, e.g. *.log or *.log.*')
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    if linked(args.directory):
        parser.error('A symlink/junction cannot be the cleanup directory')
    root = args.directory.resolve(strict=True)
    if not root.is_dir() or root == Path(root.anchor) or root == Path.home().resolve():
        parser.error('Choose a dedicated log directory, not a drive root or home directory')
    if '/' in args.pattern or '\\' in args.pattern:
        parser.error('pattern must be a filename glob, not a path')
    cutoff = time.time() - args.days * 86400
    count = 0
    for path, original in candidates(root, args.pattern, cutoff):
        if args.apply:
            # Re-check containment, link status, and modification before deleting.
            path.resolve(strict=True).relative_to(root)
            current = path.lstat()
            if linked(path) or (current.st_ino, current.st_mtime_ns, current.st_size) != (original.st_ino, original.st_mtime_ns, original.st_size):
                raise RuntimeError(f'File changed since scan: {path}')
            path.unlink()
        report(dict(timestamp=timestamp(), action='deleted' if args.apply else 'would_delete', path=str(path)))
        count += 1
    report(dict(timestamp=timestamp(), matching_files=count, applied=args.apply))


if __name__ == '__main__':
    run(main)
