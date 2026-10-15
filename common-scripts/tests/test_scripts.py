import csv
import hashlib
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import threading
import time
import unittest
import zipfile

ROOT = Path(__file__).resolve().parents[1]


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200 if self.path == '/health' else 503)
        self.end_headers()
        self.wfile.write(b'local test')

    def log_message(self, *args):
        pass


class ScriptsTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.directory = Path(self.temp.name)

    def tearDown(self):
        self.temp.cleanup()

    def cli(self, script, *args, expected=0):
        result = subprocess.run([sys.executable, str(ROOT / script), *map(str, args)],
                                capture_output=True, text=True, timeout=20)
        self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
        return result

    def test_disk_threshold_and_missing_path(self):
        self.cli('disk_monitor.py', '--path', self.directory, '--threshold', '100')
        self.cli('disk_monitor.py', '--path', self.directory, '--threshold', '0.000001', expected=1)
        self.cli('disk_monitor.py', '--path', self.directory / 'missing', expected=2)

    def test_http_and_tcp(self):
        server = ThreadingHTTPServer(('127.0.0.1', 0), Handler)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        try:
            url = f'http://127.0.0.1:{server.server_port}'
            self.cli('health_check.py', '--url', url + '/health')
            self.cli('health_check.py', '--url', url + '/fail', expected=1)
            self.cli('health_check.py', '--url', url + '/health', '--expected-status', '204', expected=1)
            self.cli('health_check.py', '--tcp-host', '127.0.0.1', '--port', server.server_port)
        finally:
            server.shutdown()
            server.server_close()
            thread.join()

    def test_cleanup_preview_apply_and_empty_directories(self):
        old = self.directory / 'old.log'
        old.write_text('old')
        stale = time.time() - 40 * 86400
        os.utime(old, (stale, stale))
        fresh = self.directory / 'fresh.log'
        fresh.write_text('fresh')
        other = self.directory / 'keep.txt'
        other.write_text('keep')
        os.utime(other, (stale, stale))
        (self.directory / 'empty').mkdir()
        self.cli('log_cleanup.py', self.directory)
        self.assertTrue(old.exists())
        self.cli('log_cleanup.py', self.directory, '--apply')
        self.assertFalse(old.exists())
        self.assertTrue(fresh.exists() and other.exists() and (self.directory / 'empty').is_dir())

    def test_cleanup_rejects_root(self):
        self.cli('log_cleanup.py', Path(self.directory.anchor), expected=2)

    def test_metrics_appends_one_header(self):
        output = self.directory / 'metrics.csv'
        for _ in range(2):
            self.cli('collect_metrics.py', '--output', output, '--interval', '0.01')
        with output.open(newline='') as handle:
            rows = list(csv.DictReader(handle))
        self.assertEqual(len(rows), 2)
        self.assertTrue(0 <= float(rows[0]['cpu_percent']) <= 100)
        output.write_text('wrong,header\n')
        self.cli('collect_metrics.py', '--output', output, expected=2)

    def test_config_validation(self):
        self.cli('validate_environment.py', '--config', ROOT / 'examples/app.json', '--config', ROOT / 'examples/app.yaml')
        bad = self.directory / 'bad.json'
        bad.write_text('{broken')
        self.cli('validate_environment.py', '--config', bad, expected=1)
        bad.write_text('{"value":NaN}')
        self.cli('validate_environment.py', '--config', bad, expected=1)
        self.cli('validate_environment.py', '--env', 'DEVOPS_TEST_UNSET_7A358C', expected=1)

    def test_backup_contents_checksum_and_destination(self):
        source = self.directory / 'source'
        source.mkdir()
        (source / 'config.txt').write_text('test content')
        (source / 'empty').mkdir()
        destination = self.directory / 'backups'
        self.cli('backup_archive.py', source, '--destination', destination)
        archive = next(destination.glob('*.zip'))
        with zipfile.ZipFile(archive) as handle:
            self.assertEqual(handle.read('config.txt'), b'test content')
            self.assertIn('empty/', handle.namelist())
            self.assertIsNone(handle.testzip())
        expected = hashlib.sha256(archive.read_bytes()).hexdigest()
        self.assertEqual(archive.with_suffix('.zip.sha256').read_text().split()[0], expected)
        self.cli('backup_archive.py', source, '--destination', source / 'nested', expected=2)


if __name__ == '__main__':
    unittest.main()
