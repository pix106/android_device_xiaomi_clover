#
# Copyright (C) 2020 The Android Open Source Project
# Copyright (C) 2020 The TWRP Open Source Project
# Copyright (C) 2020 SebaUbuntu's TWRP device tree generator
#
# Copyright (C) 2019-2024 The OrangeFox Recovery Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEVICE_PATH := device/xiaomi/lavender

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a73

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53
TARGET_BOARD_SUFFIX := _64

TARGET_SUPPORTS_64_BIT_APPS := true
TARGET_IS_64_BIT := true
ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := sdm660
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# Platform
TARGET_BOARD_PLATFORM := sdm660
TARGET_BOARD_PLATFORM_GPU := qcom-adreno512
ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Assert
TARGET_OTA_ASSERT_DEVICE := lavender

# Kernel
BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200,n8 androidboot.console=ttyMSM0 earlycon=msm_serial_dm,0xc170000
BOARD_KERNEL_CMDLINE += androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3
BOARD_KERNEL_CMDLINE += lpm_levels.sleep_disabled=1 sched_enable_hmp=1 sched_enable_power_aware=1
BOARD_KERNEL_CMDLINE += service_locator.enable=1 swiotlb=2048 androidboot.configfs=true
BOARD_KERNEL_CMDLINE += androidboot.usbcontroller=a800000.dwc3 firmware_class.path=/vendor/firmware_mnt/image loop.max_part=7
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
TARGET_KERNEL_ARCH := arm64
BOARD_BOOTIMG_HEADER_VERSION := 1
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_KERNEL_TAGS_OFFSET := 0x00000100

# kernel 4.19 or 4.4? - locations of stuff
ifeq ($(FOX_LAVENDER_KERNEL),4.19)
  KERNEL_STUFF_LOCATION := kernel_419
else
  KERNEL_STUFF_LOCATION := kernel_44
endif

# kernel to use
ifeq ($(FOX_BUILD_FULL_KERNEL_SOURCES),1)
  TARGET_KERNEL_SOURCE := kernel/xiaomi/lavender
  TARGET_KERNEL_CONFIG := lavender-fox_defconfig
else
  KERNEL_DIRECTORY := $(DEVICE_PATH)/prebuilt/$(KERNEL_STUFF_LOCATION)
  TARGET_PREBUILT_KERNEL := $(KERNEL_DIRECTORY)/Image.gz-dtb
endif

# fstab
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3758096384
BOARD_USERDATAIMAGE_PARTITION_SIZE := 23349673472
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 2147483648

# File systems
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Workaround for error copying vendor files to recovery ramdisk
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_SUPPRESS_SECURE_ERASE := true
RECOVERY_SDCARD_ON_DATA := true

# TWRP Configuration
TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := en
TW_SCREEN_BLANK_ON_BOOT := true
TW_FRAMERATE := 60
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_INCLUDE_NTFS_3G := true
TW_USE_TOOLBOX := true

# Debugging
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true

#AVB
BOARD_AVB_ENABLE := true
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_VBMETA_SYSTEM := system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

# other flags
TARGET_RECOVERY_QCOM_RTC_FIX := true
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_NO_LEGACY_PROPS := true
TW_MAX_BRIGHTNESS := 4095
TW_DEFAULT_BRIGHTNESS := 1950

# ---- various build issues ---- #
ALLOW_MISSING_DEPENDENCIES := true
SOONG_ALLOW_MISSING_DEPENDENCIES := true

# cure for "ELF binaries" problems
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# deal with "error: overriding commands for target" problems
BUILD_BROKEN_DUP_RULES := true

# retrofitted dynamic partitions?
ifeq ($(FOX_USE_DYNAMIC_PARTITIONS),1)

  BOARD_USES_QCOM_HARDWARE := true

  BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc/c0c4000.sdhci androidboot.super_partition=system buildvariant=eng

  OF_QUICK_BACKUP_LIST := /boot;/data;
  TW_INCLUDE_FASTBOOTD := true
  BOARD_USES_METADATA_PARTITION := true
  BOARD_BUILD_SYSTEM_ROOT_IMAGE :=

  BOARD_SUPER_PARTITION_GROUPS := xiaomi_dynamic_partitions
  BOARD_SUPER_PARTITION_SIZE := 6773800960
  BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := $(shell expr $(BOARD_SUPER_PARTITION_SIZE) - 4194304 )
  BOARD_XIAOMI_DYNAMIC_PARTITION_LIST := system system_ext product vendor odm

  BOARD_SUPER_PARTITION_BLOCK_DEVICES := system vendor cust
  BOARD_SUPER_PARTITION_BLOCK_DEVICES := system vendor
  BOARD_SUPER_PARTITION_METADATA_DEVICE := system

  BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 611975168
  BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 2061152256
  BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 1452175360

  BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := 328368128
  BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := 675061760

  BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
  BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096

  # source directory for variants
  ifeq ($(FOX_LAVENDER_KERNEL),4.19)
  	BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
	BOARD_AVB_VBMETA_SYSTEM := product system system_ext
  endif

else
  OF_QUICK_BACKUP_LIST := /boot;/data;/system_image;/vendor_image;
  BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3758096384
  BOARD_VENDORIMAGE_PARTITION_SIZE := 2147483648
endif

VARIANT_SRC_DIR := $(DEVICE_PATH)/recovery/$(KERNEL_STUFF_LOCATION)

# fstab
TARGET_RECOVERY_FSTAB := $(VARIANT_SRC_DIR)/recovery.fstab

# .rc files
PRODUCT_COPY_FILES += $(VARIANT_SRC_DIR)/init.recovery.qcom.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.qcom.rc
#PRODUCT_COPY_FILES += $(VARIANT_SRC_DIR)/init.recovery.usb.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.usb.rc

# extra stuff for 4.4
ifeq ($(FOX_LAVENDER_KERNEL),4.4)
	PRODUCT_COPY_FILES += $(VARIANT_SRC_DIR)/recovery-dynamic-44-flags.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/recovery-dynamic-44-flags.fstab
endif

# resetprop
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true

# drift/offset
TW_QCOM_ATS_OFFSET := 1617714502203
#
