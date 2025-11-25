#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/fuxi

# Inherit from sm8550-common
include device/xiaomi/sm8550-common/BoardConfigCommon.mk

# Display
TARGET_SCREEN_DENSITY := 420

# Kernel
BOOT_KERNEL_MODULES += \
	fts_touch_spi.ko

BOARD_VENDOR_KERNEL_MODULES_LOAD += \
	cs35l41_dlkm.ko \
	goodix_fod.ko \
	fts_touch_spi.ko

# Touchscreen
$(call soong_config_set, XIAOMI_TOUCH, HIGH_TOUCH_POLLING_PATH, /sys/devices/virtual/touch/touch_dev/bump_sample_rate)

# OTA
TARGET_OTA_ASSERT_DEVICE := fuxi

# Properties
TARGET_ODM_PROP += $(DEVICE_PATH)/odm.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public

include vendor/xiaomi/fuxi/BoardConfigVendor.mk
