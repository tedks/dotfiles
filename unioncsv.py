#!/usr/bin/python3
import csv
import sys

def union_csv(filenames, output):
    """Given a sequence of CSV file names, read the rows from each
    file, building up columns that are not shared between files. Write
    out a single CSV file with all rows from each file, filling
    columns not present in a row with empty values.

    """
    # A sequence of dicts representing rows
    rows = []
    # All columns that have been seen, but only unique columns.
    cols = set()
    for filename in filenames:
        dr = csv.DictReader(open(filename))
        rows.extend(row_dict for row_dict in dr)
        cols |= set(dr.fieldnames)
    dw = csv.DictWriter(open(output, 'w'), cols)
    dw.writeheader()
    dw.writerows(rows)
    return


if __name__ == '__main__':
    union_csv(sys.argv[2:], sys.argv[1])