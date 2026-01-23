import sys, os, base64

from deluge.ui.client import client
from twisted.internet import reactor

# Set up the logger to print out errors
from deluge.log import setupLogger
setupLogger()

def validate_filename(f):
    """
    Ensure that the filename f is a real filename and not a directory. 
    """
    if not (os.path.exists(f) 
            and (not os.path.isdir(f))
            and f.endswith(".torrent")):
        raise ValueError("Argument must be a torrent file!")

class DelugeAdder(object):
    """
    Create a connection and add a number of torrents to deluge.
    Starts and stops Twisted reactor loop.
    """

    def __init__(self, default_path="/usr/share/warez/Downloads"):
        self.default_path = default_path
        self.added_success = True
        self.connect_success = True
        self.error_message = ""

    def __disabled_setattr__(self, attr, val):
        print "Setting attribute {} to {}".format(attr, val)
        return super(DelugeAdder, self).__setattr__(attr, val)
    
    def get_connect_failure_callback(self):
        def on_connect_fail(res):
            self.connect_success = False
            self.error_message = "Couldn't connect"
            # print "Couldn't connect"
        return on_connect_fail

    def get_add_success_callback(self):
        def on_add_success(r):
            self.added_success = True
            client.disconnect()
            # print "Successfully added torrent"
            reactor.stop()
        return on_add_success

    def get_add_failure_callback(self):
        def on_add_failure(r):
            self.added_success = False
            self.error_message = "Couldn't add torrent"
            # print "Failed to add torrent"
            reactor.stop()
        return on_add_failure
            
    def get_connect_success_callback(self, filename, path):
        def on_connect_success(rslt):
            self.connect_success = True
            # print "Successfully connected! Adding torrent {}".format(filename)
            with open(filename, "r") as fh:
                filedump = base64.encodestring(fh.read())
                fh.close()

            client.core.add_torrent_file(filename, filedump, 
                                         {'download_location': path})\
                       .addCallback(self.get_add_success_callback())\
                       .addErrback(self.get_add_failure_callback())
        return on_connect_success

    def add_torrent(self, filename, path=None):
        validate_filename(filename)
        # print "Trying to add torrent"
        d = client.connect()
        d.addCallbacks(self.get_connect_success_callback(filename, path),
                       self.get_connect_failure_callback())
        reactor.run()
        return self.added_success

if __name__ == "__main__":
    da = DelugeAdder()
    if not da.add_torrent(sys.argv[1], sys.argv[2]):
        print "Error adding torrent: {}".format(da.error_message)
