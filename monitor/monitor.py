#!/usr/bin/env python

import sys
import urllib2
import json


def main(content):
    headers = {}
    url = "https://oapi.dingtalk.com/robot/send?access_token=47cf171d5f983ed36042a442cc6973db05219721bec906fae94f2e18aaf70d7c"
    headers = {'Content-Type': 'application/json'}
    body = {"msgtype": "text", "text": {"content": "cherry-prod warning: " + content}}
    request = urllib2.Request(url, headers=headers, data=json.dumps(body))
    response = urllib2.urlopen(request)
    print response


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print "params error, usage is: python monitor.py xxxx(msg)"
        exit(1)
    msg = sys.argv[1]
    main(msg)
