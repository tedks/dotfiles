#!/bin/bash
/opt/signal-cli/bin/signal-cli link -n "cli"
read
/opt/signal-cli/bin/signal-cli receive --timeout -1 --ignore-attachments --ignore-stories | tee -a /tmp/signal-log

