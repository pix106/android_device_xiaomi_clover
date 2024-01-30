#!/system/bin/sh
#
#	Copyright (C) 2024 OrangeFox Recovery Project
#	This file is part of the OrangeFox Recovery Project.
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	The GNU General Public License: see <http://www.gnu.org/licenses/>
#
# 	Script to be executed  after formatting the data partition on dynamic ROMs
# 	Format the metadata partition
#

source /system/bin/lavenderfuncs.sh

# format the metadata partition using alternative methods
format_metadata() {
# the supported device(s)
local SUPPORTED_DEVICE="lavender";

	local dyn=$(rom_has_dynamic_partitions);
	[ "$dyn" != "1" ] && return;

	local META=/metadata;
	local block_base="/dev/block/bootdevice/by-name";
	local realmeta=$block_base"$META"; # real /metadata
	local mapped_partition=$block_base"/logdump"; # /logdump mounted to /metadata
	local PART="";

	# do we even have /metadata?
	[ ! -e $META ] && return;

	# ensure we have the right device, if specified
	if [ -n "$SUPPORTED_DEVICE" ]; then
		# get the name of this device
		local currdev=$(getprop "ro.product.device");
		[ -z "$currdev" ] && return; # can't get the current device

		# are we on the right device?
		local ret=$(echo "$SUPPORTED_DEVICE" | grep -w "$currdev");
		[ -z "$ret" ] && return;
	fi

	# get the block device
	PART=$(readlink -e $realmeta); # look first for a real metadata partition
	[ -z "$PART" ] && PART=$(readlink -e $mapped_partition); # then look for metadata mount on $mapped_partition
	[ -z "$PART" ] && return; # no valid block - bale out

	# now proceed
	umount $META &> /dev/null;

	LOGMSG "Formatting $META ...";
	mke2fs -t ext4 -b 4096 $PART;
	e2fsdroid -e -S /file_contexts -a $META $PART;
}

# ---
TESTING_LOG "Running $0";
format_metadata;
echo 0;
# ---
