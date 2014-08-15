#!/usr/bin/python

import argparse
import os

INITFILE = ".work_init"
WORKDIR = "workdir"

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("project",
                        help="The project to work on. Must be a directory in ~/Projects.")
    parser.add_argument("--track", "-t", action="store_true",
                       help="Track in hamster as <project name>@projects")

    args = parser.parse_args()
    
    print("args.project: {} track? {}".format(args.project, args.track))
    