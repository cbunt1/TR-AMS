#!/bin/sh
# Copyright (C) 2015  Chris A. Bunt
# All rights reserved.
# This program comes with ABSOLUTELY NO WARRANTY.
# This is free software, and you are welcome to redistribute it.
# See the file LICENSE for details.

# This is the host-side executable. It will run on the host machine and will 
#   connect to client machines remotely via certificate-based ssh login (no 
#   password) and run the remote script.

# The script loops through a list of hostnames, defined in the file remotehosts
#   (Configurable as a variable below) and execute the backup process via the
#   remote-exec.sh script. It then loops through the remotehosts file and uses
#   scp to collect the backup files and store them in the $BackupStorageDir.

###  USER CONFIGURABLE VARIABLES  ###
RemoteScript="./remote-exec.sh"     # Script to execute on remotes
RemoteHosts="./remotehosts"         # File listing remote machines to backup
RemoteUserID="root"                 # Usually root, but some change this
BackupStorageDir="./RouterBackups"  # Dir where we store the backups
#####################################
# System Generated Variables
TempFile=/tmp/btrmstmp

echo "BTRMS automated backup tool. Copyright (c) 2015 Chris A. Bunt"
echo "Copyright (C) 2014, 2015  Chris A. Bunt"
echo "All rights reserved."
echo "This program comes with ABSOLUTELY NO WARRANTY."
echo "This is free software, and you are welcome to redistribute it."
echo "See the file LICENSE for details."
echo "At this point, most of it hasn't even been written!"

# This section would be a good spot to MOUNT a remote directory for your
#   BackupStorageDir should you be so inclined. I mount a cifs directory
#   and symlink it to my homedir.

# Initialize our temp file
if [[ -a ${TempFile} ]] ; then
    rm -f ${TempFile} ; else
    touch ${TempFile}
fi

for MachineName in `cat $RemoteHosts` ; do 
    [[ $MachineName = \#* ]] && continue        # This processing doesn't work on zsh.
        echo -n "Backing up $MachineName.."
        ssh ${RemoteUserID}@${MachineName} '/bin/sh' < ${RemoteScript} >> ${TempFile}
        echo ".done!"
done

# Now to get the backups to thier main storage...
# Is the target directory writable, if not, create it.
# TODO: Need to add a secondary check that the dir was created.
if [[ ! -w "$BackupStorageDir" ]] ; then
    echo "BackupStorageDir=$BackupStorageDir"
    mkdir "$BackupStorageDir"
fi

# Now loop through our output file and put the backups to $BackupStorageDir
for RemoteFile in `cat ${TempFile}` ; do
    scp -Cpr ${RemoteUserID}@${RemoteFile} ${BackupStorageDir}
done

# Clean up after ourselves
rm -f ${TempFile}

# This would be a good spot to UNMOUNT any remote directories for 
#   BackupStorageDir you mounted above. This might also be a good place to copy
#   files on a post-processing basis. Many ways to use this tool to automate
#   remote backups.