"""Create a timestamped ZIP of a directory without following links/junctions."""
import argparse
from datetime import datetime, timezone
import hashlib
import os
from pathlib import Path
import uuid
import zipfile
from log_cleanup import linked
from _common import run


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--destination', type=Path, required=True)
    args = parser.parse_args()
    source = args.source.resolve(strict=True)
    destination = args.destination.resolve()
    if not source.is_dir() or linked(args.source):
        parser.error('Source must be a real directory')
    if destination == source or source in destination.parents:
        parser.error('Backup destination must be outside the source directory')
    destination.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
    archive = destination / f'{source.name or "root"}-{stamp}-{uuid.uuid4().hex[:8]}.zip'
    partial = archive.with_suffix('.zip.partial')
    def scan_error(error):
        raise error
    try:
        with zipfile.ZipFile(partial, 'x', compression=zipfile.ZIP_DEFLATED) as output:
            for directory, dirs, files in os.walk(source, followlinks=False, onerror=scan_error):
                dirs[:] = [name for name in dirs if not linked(Path(directory) / name)]
                folder = Path(directory)
                relative = folder.relative_to(source)
                if relative.parts:
                    output.write(folder, relative.as_posix() + '/')
                for name in files:
                    path = folder / name
                    if linked(path) or not path.is_file():
                        print(f'Skipped link or special file: {path}')
                        continue
                    output.write(path, path.relative_to(source).as_posix())
        with zipfile.ZipFile(partial) as check:
            bad = check.testzip()
            if bad:
                raise RuntimeError(f'Archive integrity check failed: {bad}')
        partial.rename(archive)
    except Exception:
        partial.unlink(missing_ok=True)
        raise
    digest = hashlib.sha256()
    with archive.open('rb') as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b''):
            digest.update(block)
    archive.with_suffix('.zip.sha256').write_text(f'{digest.hexdigest()}  {archive.name}\n', encoding='utf-8')
    print(f'Created and verified: {archive}')


if __name__ == '__main__':
    run(main)
