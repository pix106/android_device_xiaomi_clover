#
# Copyright (C) 2018 The LineageOS Project
# Copyright (C) 2018-2021 Xioami-SDM660 Project
#
# SPDX-License-Identifier: Apache-2.0
#

include device/xiaomi/sdm660-common/BoardConfigCommon.mk

# Device Path
DEVICE_PATH := device/xiaomi/clover

# DT2W
TARGET_TAP_TO_WAKE_NODE := "/proc/touchscreen/enable_dt2w"

# Density
TARGET_SCREEN_DENSITY := 320

# Kernel
TARGET_KERNEL_CONFIG := clover_defconfig

# Manifest
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml

# Platform
BOARD_VENDOR_PLATFORM := xiaomi-sdm660

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private

# Vendor Security patch level
VENDOR_SECURITY_PATCH := 2020-08-05

# WLAN MAC
WLAN_MAC_SYMLINK := true

