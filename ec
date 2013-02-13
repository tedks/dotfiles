#!/usr/bin/python

import os, sys
from time import sleep

command_output = os.popen("ps aux | grep emacs").read()

if command_output.find("emacs --daemon") == -1:
    old_pwd = os.environ["PWD"]
    os.environ["PWD"] = "/home/tedks/"
    if os.system("emacs --daemon") != 0:
        print "Error starting emacs!"
        exit(1)
    os.environ["PWD"] = old_pwd

args = ["ec", "-c"] + sys.argv[1:]
if os.fork() == 0:
    os.execvpe("emacsclient", args, os.environ)
else:
    sleep(1)
    print
