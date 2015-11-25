#!/usr/bin/python3

import os, sys
from time import sleep
from subprocess import Popen, PIPE, check_call, DEVNULL
from contextlib import redirect_stdout

# unit -> bool
def is_emacs_running():
    return 0 == check_call(['pgrep', '-f', 'emacs --daemon'], 
                           stdout=DEVNULL,
                           stderr=DEVNULL)

def start_emacs():
    Popen(['emacs', '--daemon'], 
          stdout=-1, 
          cwd=os.environ['HOME'])

def run_emacs_client(args, console=False):
    argv = []
    if console:
        argv += ['ecc', '-nw']
    else:
        argv += ['ec']
    argv += ['--create-frame']
    argv += ['--quiet']
    argv += args
    binary = 'emacsclient'
    os.execvp(binary, argv)
    
def main(args):
    if not is_emacs_running():
        print("Emacs not found, starting...")
        start_emacs()
    # Run emacs client
    run_emacs_client(args[1:], args[0] == 'ecc')

if __name__ == "__main__":
    main(sys.argv)