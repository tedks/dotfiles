"""
Suspend action for Kupfer
"""

__kupfer_name__ = _("Suspend")
__kupfer_sources__ = ("SuspendSource",)
__description__ = _("Suspend the system")
__version__ = "1.0"
__author__ = ""

import subprocess
from kupfer.objects import Source, Leaf, Action


class SuspendLeaf(Leaf):
    """Represents the suspend action"""

    def __init__(self):
        super().__init__(obj="suspend", name=_("Suspend"))

    def get_description(self):
        return _("Suspend the system")

    def get_icon_name(self):
        return "system-suspend"

    def get_actions(self):
        yield SuspendAction()


class SuspendAction(Action):
    """Action to suspend the system"""

    def __init__(self):
        super().__init__(name=_("Suspend"))

    def activate(self, leaf):
        subprocess.Popen(["systemctl", "suspend"])

    def get_description(self):
        return _("Suspend the system")

    def get_icon_name(self):
        return "system-suspend"


class SuspendSource(Source):
    """Source providing suspend action"""

    def __init__(self):
        super().__init__(name=_("Suspend"))

    def get_items(self):
        yield SuspendLeaf()

    def get_icon_name(self):
        return "system-suspend"

    def provides(self):
        yield SuspendLeaf
