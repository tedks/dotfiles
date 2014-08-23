#!/usr/bin/python

import argparse
import os
import subprocess

INITFILE = ".work_init"
WORKDIR = "workdir"


def werk(project, path):
    assert len(project) > 0
    assert len(path) > 0
    assert os.path.exists(project)
    assert os.path.isdir(project)
    os.chdir(path)
    if WORKDIR in os.listdir():
        os.chdir(os.path.join(path, WORKDIR))
    subprocess.call("byobu -S {}".format(project))
    exit(0)

def project(project):
    if os.path.abspath(project) == project:
        return os.path.split(project)[-1]
    else:
        return project    

def path(project):
    if os.path.abspath(project) == project:
        return project
    else:
        # pick up here

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

    project = project(args.project)
    path = path(args.project)









    