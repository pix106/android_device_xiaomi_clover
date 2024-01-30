#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2023-2024 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

# OrangeFox-specific settings #

OF_SCREEN_H := 2340
OF_STATUS_H := 80
OF_STATUS_INDENT_LEFT := 64
OF_STATUS_INDENT_RIGHT := 64
OF_HIDE_NOTCH := 1
OF_CLOCK_POS := 1

OF_USE_GREEN_LED := 0

OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
OF_SKIP_MULTIUSER_FOLDERS_BACKUP := 1
OF_UNBIND_SDCARD_F2FS := 1

OF_QUICK_BACKUP_LIST := /boot;/data;/system_image;/vendor_image;

# keymaster
OF_DEFAULT_KEYMASTER_VERSION := 4.0

# patch avb20 - some ROM recoveries try to overwrite custom recoveries
OF_PATCH_AVB20 := 1

# no additional check for MIUI props
OF_NO_ADDITIONAL_MIUI_PROPS_CHECK := 1

# dispense with the entire OTA menu
OF_DISABLE_OTA_MENU := 1

# run a process after formatting data to work-around MTP issues
OF_RUN_POST_FORMAT_PROCESS := 1

# encryption stiff
OF_KEEP_FORCED_ENCRYPTION := 1
OF_DONT_PATCH_ENCRYPTED_DEVICE := 1

# don't save historic logs
OF_DONT_KEEP_LOG_HISTORY := 1
#
