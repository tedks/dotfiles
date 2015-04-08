#!/usr/bin/python
# needs to be 2.7 for hamster :-(

import argparse
import os
import shlex
import subprocess

try:
    from hamster.client import Storage as hc
    from hamster.lib.stuff import Fact
    have_hamster = True
except ImportError:
    have_hamster = False

INITFILE = ".work_init"
WORKDIR = "workdir"
PROJECTS = "{}/Projects".format(os.environ['HOME'])

def random_project(projects_dir='{}/Projects'):
    if '{}' in projects_dir:
        projects_dir = projects_dir.format(os.environ['HOME'])
    project = random.choice(os.listdir(projects_dir))
    return project

def path(project):
    if os.path.isabs(project):
        return "random", project, project

    root_project = project.split(os.path.sep)[0]
    path = os.path.join(PROJECTS, root_project)
    base_path = path
    
    if WORKDIR in os.listdir(path):
        path = os.path.join(path, WORKDIR)
        
    if os.path.sep in project:
        rest = os.path.sep.join(project.split(os.path.sep)[1:])
        path = os.path.join(path, rest)
        non_workdir_path = os.path.join(base_path, rest)
        if not os.path.exists(path) \
           and os.path.exists(non_workdir_path):
            path = non_workdir_path

    if not os.path.exists(path):
        raise ValueError("Invalid path")

    return root_project, base_path, path

def byobu_command_string():
    binary_name = 'byobu'
    session_name_flag = ''
    try:
        backend = open("{}/.byobu/backend".format(os.environ['HOME']))\
                  .read().split('=')[-1].rstrip()
        if backend == 'screen':
            session_name_flag = '-S'
        else:
            session_name_flag = '-L'
    except:
        session_name_flag = '-L' # byobu defaults to tmux
    return "{} {} {}".format(binary_name, session_name_flag, '{}')

def hamster_track(project):
    """Track activity as {project}@projects"""
    hamster = hc()
    activity = Fact(project,
                    category="projects",
                    description="auto-tracked from dowork.py")
    hamster.add_fact(activity)

def werk(project, track=False):
    """Project is the logical name of the project to work on and the
    Hamster task name if hamster integration is enabled.

    """
    assert len(project) > 0
    launch_string = byobu_command_string()
    if 'VERBOSE' in os.environ:
        print("Launching {}".format(launch_string))

    try:
        project_name, base_path, work_path = path(project)
    except ValueError:
        print("{} is not a path in the project directory.".format(project))
        exit(1)
    init_path = os.path.join(base_path, INITFILE)

    if track:
        hamster_track(project_name)

    os.chdir(work_path)

    if os.path.exists(init_path):
        source_script(init_path)
    
    launch_list = shlex.split(launch_string.format(project_name))
    if 'DEBUG' in os.environ:
        print(launch_list)
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

def main():    
    parser = argparse.ArgumentParser()
    parser.add_argument("--track", "-t", action="store_true", default=False,
                        help="Track in hamster as <project name>@projects")
    projsel = parser.add_mutually_exclusive_group(required=True)
    
    projsel.add_argument("project", nargs='?', default=None,
                        help="The project to work on. Must be a directory in ~/Projects.")
    projsel.add_argument("--random", '-r', default=False, action="store_true",
                        help="Pick a random project to work on")
    
    args = parser.parse_args()

    if args.random:
        args.project = random_project()
    
    werk(args.project, track=(args.track and have_hamster))

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        exit(1)
