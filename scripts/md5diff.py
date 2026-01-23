#!/usr/bin/python3

import sys

def run():
    #base_file_name = sys.argv[1]
    #diff_file_name = sys.argv[2]
    base_file_name = "/home/tedks/blacked.drynwyn"
    diff_file_name = "/home/tedks/blacked.sunbringer"
    kBASE = "base_hash"
    kDIFF = "diff_hash"
    
    file_to_hash = {}
    process_file(base_file_name, kBASE, file_to_hash)
    process_file(diff_file_name, kDIFF, file_to_hash)
    only_base = 0
    only_diff = 0
    diffed = 0
    okay = 0
    
    for file, hashes in file_to_hash.items():
        if kBASE not in hashes:
            print("------------------------------\n{} only exists in base".format(file))
            only_base += 1
            continue
        elif kDIFF not in hashes:
            print("------------------------------\n{} only exists in diff")
            only_diff += 1
            continue
        elif hashes[kBASE] != hashes[kDIFF]:
            diffed += 1
            print("==============================\nfile: {}\n{}: {}\n{}: {}".format(
                file, base_file_name, hashes[kBASE], diff_file_name, hashes[kDIFF]))
        else:
            okay += 1
    print("only in base: {}\nonly in diff: {}\nchecksums differ: {}\nidentical: {}".format(only_base, only_diff, diffed, okay))

def process_file(filename, key, store):
    with open(filename) as hashfile:
        for line in hashfile:
            breakspace = line.find(' ')
            md5 = line[:breakspace]
            filename = line[breakspace:]
            store.setdefault(filename, {})[key] = md5
    
if __name__ == "__main__":
    run()

