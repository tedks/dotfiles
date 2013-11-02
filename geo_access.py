#!/usr/bin/python

import sys, GeoIP

if __name__ == "__main__":
    gi = GeoIP.open("/usr/share/GeoIP/GeoIP.dat", 0)
    ips = {}
    for fn in sys.argv[1:]:
        f = open(fn, "r")
        for l in f:
            ip = l.split(' ')[0]
            if not ip in ips:
                ips[ip] = []
            ips[ip].append(l)
    items = ips.items()
    items.sort(cmp=lambda (k1,v1),(k2,v2): len(v1) - len(v2))
    for k,v in items:
        print "{} ({}): {} hits".format(k, gi.country_code_by_name(k), len(v))
