#!/usr/bin/python

import sys, GeoIP
from itertools import chain

def ips_of_stream(strm):
    if type(strm) == str:
        strm = open(strm, "r")
    ret = {}
    for l in strm:
        ip = l.split(' ')[0]
        if not ip in ret:
            ret[ip] = []
        ret[ip].append(l)
    strm.close()
    return ret

def list_concat(l1, l2):
    if l1 is None:
        l1 = []
    if l2 is None:
        l2 = []
    return l1 + l2

def dict_extend(d1, d2, combine):
    ret = {}
    for k in chain(d1.iterkeys(), d2.iterkeys()):
        v1 = d1[k] if k in d1 else None
        v2 = d2[k] if k in d2 else None
        ret[k] = combine(v1, v2)
    return ret

if __name__ == "__main__":
    gi = GeoIP.open("/usr/share/GeoIP/GeoIP.dat", 0)
    ips = reduce(lambda acc, s: dict_extend(acc, ips_of_stream(s), list_concat),
                 sys.argv[1:], {})
    items = ips.items()
    items.sort(cmp=lambda (k1,v1),(k2,v2): len(v1) - len(v2))
    for k,v in items:
        print "{} ({}): {} hits".format(k, gi.country_code_by_name(k), len(v))
