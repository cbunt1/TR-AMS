#!/bin/sh
# Copyright (c) 2015 Chris A. Bunt
# All Rights Reserved

# This is the host-side executable. It will run on the host machine and will connect to
#	client machines remotely via certificate-based ssh login (no password) and run
#	the remote script. (Currently called remote-exec.sh, but will be referenced by
#	variable most likely.)

# The plan is to run through a list of hostnames, defined in a separate file, and execute
#	the backup process. Once that loop is complete, we will again loop and drag the
#	completed backups to the host side as necessary. We may also have an option to 
#	push from the client side, but that is undetermined at this point.

#VARIABLES
# User Variables
RemoteScript="./remote-exec.sh"     # Script to execute on remotes
RemoteHosts="./remotehosts"         # File listing remote machines to backup
RemoteUserID="root"                 # Usually root, but some change this
# System Generated Variables

echo "Welcome to the BTRMS automated backup tool. This is free software, and comes with"
echo "absolutely no warranty."
echo "At this point, it hasn't even been written!"

for MachineName in `cat $RemoteHosts` ; do 
# echo "userid="${RemoteUserID}		#DEBUG
# echo "Hostname: "${MachineName}		#DEBUG
# echo ${RemoteScript}				#DEBUG
ssh ${RemoteUserID}@${MachineName} '/bin/sh' < ${RemoteScript}
done

