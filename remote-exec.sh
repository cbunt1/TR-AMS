#!/bin/sh
# Copyright (c) 2015 Chris A. Bunt
# All rights reserved

# BTRMS remote executable. Backs up a router's configuration for offline
#	storage. Designed to be run remotely, but will run locally just fine.
#	Execute this script with a crontab entry or similar for an automated
#	backup that self-resolves all dependencies.

# This script will remove optware, install entware, add diffutils, wget, and
#	the BTRMS main tool if they don't already exist.

# Variables
# For directories, use no trailing slashes.
# USER VARIABLES
VerTag="v-1.2.1"
RootDir=/jffs
BinDir="$RootDir/BTRMS-$VerTag"
OutputRoot=$BinDir			# Default. Can be changed at leisure.
ScriptName="transfersettings.sh"

# System-generated/operating variables
HostName=`nvram get router_name`

# Do we have our core tools? Verify and install if necessary.
if [[ ! -x "/opt/bin/opkg" ]] ; then
	# First clean out from Optware/old installs
	for folder in bin etc include lib sbin share tmp usr var
	do rm -Rf "/opt/$folder"
	done
	/usr/sbin/entware-install.sh
	# Go ahead and update to entware-ng until upgrade is built-into firmware.
	# Should add a firmware version check to reduce a step.
	wget -O - http://entware.zyxmon.org/binaries/mipsel/installer/upgrade.sh | sh
fi
# Verify presence of a functional wget, if not, install it.
if [[ ! -x "/opt/bin/wget" ]] ; then
	opkg install wget
fi
# Verify presence of diff, if not, install it.
if [[ ! -x "/opt/bin/diff" ]] ; then
	opkg install diffutils
fi
# Verify the chosen $RootDir is writable, if not, use /tmp
if [[ ! -w "$RootDir" ]] ; then
	RootDir="/tmp"
fi
# Verify the chosen $OutputRoot is writable, if not use /tmp
if [[ ! -w "$OutputRoot" ]] ; then
	OutputRoot="/tmp"
fi
# Test whether we have the software, if not, install it.
if [[ ! -x "$BinDir/$ScriptName" ]] ; then
	/opt/bin/wget --no-check-certificate https://github.com/cbunt1/BTRMS/archive/"$VerTag".tar.gz -O /tmp/BTRMS-"$VerTag".tar.gz
	tar -C "$RootDir" -xzf /tmp/BTRMS-"$VerTag".tar.gz
	rm "/tmp/BTRMS-$VerTag.tar.gz"
	chmod +x "$BinDir/$ScriptName"
fi
# Now let's do what we came here to do.
cd $OutputRoot
$BinDir/$ScriptName export
logger "NVRAM Configuration backed up to $OutputRoot/$HostName"
echo "Your backup file is located in $OutputRoot/$HostName"
exit
