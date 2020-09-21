#!/usr/bin/env python

import sys
import urllib2
import json

def write_stdout(s):
    # only eventlistener protocol messages may be sent to stdout
    sys.stdout.write(s)
    sys.stdout.flush()

def write_stderr(s):
    sys.stderr.write(s)
    sys.stderr.flush()

def main():
    while 1:
        # transition from ACKNOWLEDGED to READY
        write_stdout('READY\n')

        # read header line and print it to stderr
        line = sys.stdin.readline()
        write_stderr(line)

        # read event payload and print it to stderr
        headers = dict([ x.split(':') for x in line.split() ])
        content = sys.stdin.read(int(headers['len']))
        write_stderr(content)

	url = "https://oapi.dingtalk.com/robot/send?access_token=47cf171d5f983ed36042a442cc6973db05219721bec906fae94f2e18aaf70d7c"
	headers = {'Content-Type':'application/json'}
        body = {"msgtype": "text", "text": {"content": "cherry-prod warning: " + content}}
        request = urllib2.Request(url,headers=headers,data=json.dumps(body))
        response = urllib2.urlopen(request)


        # transition from READY to ACKNOWLEDGED
        write_stdout('RESULT 2\nOK')

if __name__ == '__main__':
    main()
