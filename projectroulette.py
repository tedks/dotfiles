#!/usr/bin/env python

import os
import random
import subprocess
import sys

def random_project(projects_dir='{}/Projects'):
    if '{}' in projects_dir:
        projects_dir = projects_dir.format(os.environ['HOME'])
    project = random.choice(os.listdir(projects_dir))
    return project

if __name__ == "__main__":
    subprocess.call("dowork {}".format(random_project()), shell=True)