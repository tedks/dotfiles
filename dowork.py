#!/usr/bin/python

import argparse
import os
import subprocess

INITFILE = ".work_init"
WORKDIR = "workdir"


def werk(project, path):
    os.chdir(path)
    subprocess.call("byobu")

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("project",
                        help="The project to work on. Must be a directory in ~/Projects.")
    parser.add_argument("--track", "-t", action="store_true",
                       help="Track in hamster as <project name>@projects")

    args = parser.parse_args()
    
    print("args.project: {} track? {}".format(args.project, args.track))
    if os.path.abspath(args.project) == args.project:
        print("is an abspath")
    else:
        print("is a relative path")
        print("project: {}".format(os.path.exists("/home/tedks/Projects/{}".format(args.project))))

    