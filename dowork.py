#!/usr/bin/python

import argparse
import os
import shlex
import subprocess

INITFILE = ".work_init"
WORKDIR = "workdir"
PROJECTS = "/home/tedks/Projects"

def path(project):
    if os.path.isabs(project):
        return "random", project, project

    root_project = project.split(os.path.sep)[0]
    path = os.path.join(PROJECTS, root_project)
    base_path = path
    assert os.path.exists(path)

    if WORKDIR in os.listdir(path):
        path = os.path.join(path, WORKDIR)
        
    if os.path.sep in project:
        rest = os.path.sep.join(project.split(os.path.sep)[1:])
        path = os.path.join(path, rest)
        non_workdir_path = os.path.join(base_path, rest)
        if not os.path.exists(path) \
           and os.path.exists(non_workdir_path):
            path = non_workdir_path
            

    return root_project, base_path, path

def werk(project):
    """Project is the logical name of the project to work on and the
    Hamster task name if hamster integration is enabled.

    String is the original command string. If this contains a 

    """
    assert len(project) > 0
    launch_string = "byobu -S {}"

    project_name, base_path, work_path = path(project)
    init_path = os.path.join(base_path, INITFILE)

    os.chdir(work_path)

    if os.path.exists(init_path):
        source_script(init_path)
    
    launch_list = shlex.split(launch_string)
    os.execvp(launch_list[0], launch_list)

def source_script(scriptpath):
    assert len(scriptpath) > 0
    assert os.path.exists(scriptpath), "scriptpath doesn't exist"
    
    new_env = subprocess.check_output('bash -c "source {}"'.format(scriptpath) +
                                      ' && env',
                                      shell=True)
    
    for line in new_env.split('\n'):
        k, _, v = line.partition('=')
        os.environ[k] = v

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("project",
                        help="The project to work on. Must be a directory in ~/Projects.")
    parser.add_argument("--track", "-t", action="store_true",
                       help="Track in hamster as <project name>@projects")

    args = parser.parse_args()
    
    werk(args.project)
