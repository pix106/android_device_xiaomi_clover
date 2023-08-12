#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2019-2025 The OrangeFox Recovery Project
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

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

LOCAL_PATH := device/xiaomi/clover

# Exclude Apex
TW_EXCLUDE_APEX := true

# api level
PRODUCT_SHIPPING_API_LEVEL := 27

# Crypto
TW_INCLUDE_CRYPTO := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
PLATFORM_VERSION := 99.87.36
PLATFORM_SECURITY_PATCH := 2127-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)

PRODUCT_PACKAGES += \
    qcom_decrypt \
    qcom_decrypt_fbe

# OEM otacert
PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/recovery/security/miui

# Libraries
TARGET_RECOVERY_DEVICE_MODULES += \
	libion \
	vendor.display.config@1.0 \
	vendor.display.config@2.0 \
	libdisplayconfig.qti

RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@1.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@2.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/libdisplayconfig.qti.so

# retrofitted dynamic partitions?
ifeq ($(FOX_USE_DYNAMIC_PARTITIONS),1)
  PRODUCT_USE_DYNAMIC_PARTITIONS := true
  PRODUCT_RETROFIT_DYNAMIC_PARTITIONS := true
  TW_INCLUDE_FBE_METADATA_DECRYPT := true
  BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

  PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/commonsys-intf/display

  PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    android.hardware.fastboot@1.0-impl-mock.recovery \
    fastbootd

  PRODUCT_PACKAGES += \
    android.hardware.boot@1.1-impl-qti \
    android.hardware.boot@1.1-impl-qti.recovery \
    android.hardware.boot@1.1-service

  PRODUCT_PROPERTY_OVERRIDES += \
	ro.orangefox.dynamic.build=true \
	ro.fastbootd.available=true \
	ro.boot.dynamic_partitions_retrofit=true
	ro.boot.dynamic_partitions=true
else
  PRODUCT_PROPERTY_OVERRIDES += \
	ro.orangefox.dynamic.build=false
endif

# kernel 4.19, static or dynamic
ifeq ($(FOX_CLOVER_KERNEL),4.19)

# FUSE passthrough
PRODUCT_SYSTEM_PROPERTIES += \
    persist.sys.fuse.passthrough.enable=true

$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# f2fs utilities
PRODUCT_PACKAGES += \
    sg_write_buffer \
    f2fs_io \
    check_f2fs

  # --- Vibration/Haptics
  TW_SUPPORT_INPUT_AIDL_HAPTICS := true

  RECOVERY_BINARY_SOURCE_FILES += \
    $(TARGET_OUT_VENDOR_EXECUTABLES)/hw/vendor.qti.hardware.vibrator.service

  RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/vendor.qti.hardware.vibrator.impl.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/libqtivibratoreffect.so

  TARGET_RECOVERY_DEVICE_MODULES += \
	vendor.qti.hardware.vibrator.service \
	vendor.qti.hardware.vibrator.impl \
	libqtivibratoreffect

     # --- Decryption (doesn't work!)
     OF_FBE_METADATA_MOUNT_IGNORE := 1
     OF_FIX_DECRYPTION_ON_DATA_MEDIA := 1

     PRODUCT_PROPERTY_OVERRIDES += \
    	ro.crypto.dm_default_key.options_format.version=2 \
    	ro.crypto.volume.filenames_mode=aes-256-cts \
    	ro.crypto.volume.metadata.method=dm-default-key \
	ro.crypto.allow_encrypt_override=true \
    	ro.crypto.volume.options=::v2 \
    	ro.crypto.uses_fs_ioc_add_encryption_key=true
endif

# kernel
  PRODUCT_PROPERTY_OVERRIDES += \
	ro.orangefox.kernel_ver=$(FOX_CLOVER_KERNEL)

# initial prop for variant
ifneq ($(FOX_VARIANT),)
  PRODUCT_PROPERTY_OVERRIDES += \
	ro.orangefox.variant=$(FOX_VARIANT)
else
  PRODUCT_PROPERTY_OVERRIDES += \
	ro.orangefox.variant=default
endif
#
