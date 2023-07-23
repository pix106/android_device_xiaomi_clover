#
# Copyright (C) 2018 The LineageOS Project
# Copyright (C) 2018-2021 Xioami-SDM660 Project
#
# SPDX-License-Identifier: Apache-2.0
#

include device/xiaomi/sdm660-common/BoardConfigCommon.mk

# Device Path
DEVICE_PATH := device/xiaomi/clover

# Camera
TARGET_TS_MAKEUP := true
TARGET_USES_QTI_CAMERA_DEVICE := true
BOARD_QTI_CAMERA_32BIT_ONLY := true
MALLOC_SVELTE_FOR_LIBC32 := true
USE_DEVICE_SPECIFIC_CAMERA := true
$(call project-set-path,qcom-camera,$(DEVICE_PATH)/camera)

# DT2W
TARGET_TAP_TO_WAKE_NODE := "/proc/touchscreen/enable_dt2w"

# Density
TARGET_SCREEN_DENSITY := 320

# Kernel
TARGET_KERNEL_CONFIG := clover_defconfig

# Manifest
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += $(DEVICE_PATH)/framework_compatibility_matrix.xml

# WLAN MAC
WLAN_MAC_SYMLINK := true

