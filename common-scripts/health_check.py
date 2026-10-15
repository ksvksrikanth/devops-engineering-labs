"""Check HTTP status or a TCP connection; optionally notify a webhook on failure."""
import argparse
import os
import socket
import urllib.error
import urllib.request
import urllib.parse
import json
from _common import positive, report, run, timestamp


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    target = parser.add_mutually_exclusive_group(required=True)
    target.add_argument('--url')
    target.add_argument('--tcp-host')
    parser.add_argument('--port', type=int)
    parser.add_argument('--expected-status', type=int, default=200)
    parser.add_argument('--timeout', type=positive, default=10)
    parser.add_argument('--log')
    parser.add_argument('--webhook-env', help='Environment variable containing a Slack-compatible webhook URL')
    args = parser.parse_args()
    if args.tcp_host and (args.port is None or not 1 <= args.port <= 65535):
        parser.error('TCP checks require --port between 1 and 65535')
    if args.url and urllib.parse.urlsplit(args.url).scheme not in ('http', 'https'):
        parser.error('URL must use HTTP or HTTPS')
    if not 100 <= args.expected_status <= 599:
        parser.error('expected status must be between 100 and 599')
    if args.url and args.port:
        parser.error('--port is only for --tcp-host')
    result = dict(timestamp=timestamp(), check='HTTP' if args.url else 'TCP', status='OK')
    try:
        if args.url:
            opener = urllib.request.build_opener(NoRedirect())
            try:
                with opener.open(args.url, timeout=args.timeout) as response:
                    code = response.status
            except urllib.error.HTTPError as exc:
                code = exc.code
                exc.close()
            result['http_status'] = code
            if code != args.expected_status:
                result['status'] = 'FAIL'
        else:
            with socket.create_connection((args.tcp_host, args.port), timeout=args.timeout):
                pass
    except (OSError, ValueError) as exc:
        # Avoid printing URLs, which can contain credentials or tokens.
        result.update(status='FAIL', error_type=type(exc).__name__)
    report(result, args.log)
    if result['status'] == 'FAIL' and args.webhook_env:
        webhook = os.environ.get(args.webhook_env)
        if not webhook or urllib.parse.urlsplit(webhook).scheme != 'https':
            raise ValueError('Webhook environment variable must contain an HTTPS URL')
        payload = json.dumps({'text': 'DevOps health check failed. Inspect the local health-check log.'}).encode()
        request = urllib.request.Request(webhook, data=payload, headers={'Content-Type': 'application/json'}, method='POST')
        try:
            with urllib.request.build_opener(NoRedirect()).open(request, timeout=args.timeout):
                pass
        except Exception:
            raise RuntimeError('Webhook delivery failed; check configuration') from None
    return 1 if result['status'] == 'FAIL' else 0


if __name__ == '__main__':
    run(main)
