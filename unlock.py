from bottle import route, run, request, static_file
import subprocess

"""
Get DEVICE_ID by running script and connecting to the url with your mobile device


    python unlock.py 
    Bottle v0.11.2 server starting up (using WSGIRefServer())...
    Listening on http://192.168.77.102:8888/
    Hit Ctrl-C to quit.

    android-ebed2865246db.mynetwork.net

Use that device id for allowed devices.

Bottle is the only dependency
http://bottlepy.org/docs/dev/

Will probably only work on systems running Gnome desktop, tested on Ubuntu 13.04
"""


@route('/')
def hello():
    print "Remote host: [{}]".format(request.environ.get('REMOTE_HOST'))
    devices =('DEVICE_ID_HER',)
    requesting_device = request.environ.get('REMOTE_HOST')
    if requesting_device in devices:
        status = subprocess.check_output(["gnome-screensaver-command", "-t"])
        if status == 'The screensaver is not currently active.\n':
            message = "YOUR SWITCH ON HTML GOES HERE"
            subprocess.call(["gnome-screensaver-command", "-l"])
        else:
            message = "YOUR SWITCH OFF HTML GOES HERE" 
            subprocess.call(["gnome-screensaver-command", "-d"])
    else:
        message = "Unauthorized device {}".format(requesting_device)
    return message


@route('/images/<filename>')
def images(filename):
    return static_file(filename, root='/path_to_images/images')
#host must be on lan (not localhost) 
run(host='10.3.40.135', port=8888)
