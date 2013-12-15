import sys, os, base64

from deluge.ui.client import client
from twisted.internet import reactor

# Set up the logger to print out errors
from deluge.log import setupLogger
setupLogger()

class DelugeAdder(object):
    """
    Create a connection and add a number of torrents to deluge.
    Starts a Twisted reactor loop.
    """

    def __init__(self):
        pass

def validate_filename(f):
    """
    Ensure that the filename f is a real filename and not a directory. 
    """
    if not (os.path.exists(f) 
            and (not os.path.isdir(f))
            and f.endswith(".torrent")):
        raise ValueError("Argument must be a torrent file!")

def on_connect_fail(result):
    print "Connection failed!"
    print "result:", result

def add_torrent_on_success(filename, path):
    def on_success(rslt):
        print "Successfully connected! Adding torrent {}".format(filename)
        with open(filename, "r") as fh:
            filedump = base64.encodestring(fh.read())
            fh.close()

        def on_add_success(r):
            print "Added torrent!"
            client.disconnect()
            reactor.stop()
            
        def on_add_failure(r):
            print "Failed!"
            
        client.core.add_torrent_file(
            filename, filedump, {'download_location': path})\
                   .addCallback(on_add_success).addErrback(on_add_failure)
    return on_success

def add_torrent(filename, path):
    validate_filename(filename)

    d = client.connect()
    d.addCallback(add_torrent_on_success(filename, path))
    d.addErrback(on_connect_fail)
    reactor.run()    

if __name__ == "__main__":
    add_torrent(sys.argv[1], sys.argv[2])