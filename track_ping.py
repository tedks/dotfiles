import csv
import socket
import sys

"""
A utility that measures the ping time to various servers and tracks them in a CSV file.
"""

def main():
    if len(sys.argv) < 2:
        print("Usage: {} <outfile> [hosts]".format(sys.argv[0]))

    csv_path = sys.argv[1]
    ips = sys.argv[2:]
    cols = ["timestamp"]
    for ip in ips:
        cols.append(ip)
        cols.append(ip + "_ping")
              
    if os.path.isfile(csv_path):
        print("overwriting previous file")

    csv = csv.DictWriter(open(csv_path), cols)
    csv.writeheader()
    while True:
        # this is probably impossible in python
        # project abandoned here