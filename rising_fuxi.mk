#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Configure core_64_bit.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit common LineageOS configurations
$(call inherit-product, vendor/rising/config/rising.mk)

# Inherit device configurations
$(call inherit-product, device/xiaomi/fuxi/device.mk)

## Device identifier
PRODUCT_DEVICE := fuxi
PRODUCT_NAME := rising_fuxi
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := Mi 13
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_SYSTEM_NAME := Mi 13
PRODUCT_SYSTEM_DEVICE := Mi 13

TARGET_BOOT_ANIMATION_RES := 1080
TARGET_INCLUDE_PIXEL_CHARGER := true
TARGET_SUPPORTS_QUICK_TAP := true
TARGET_SUPPORTS_CALL_RECORDING := true

# Rising flags
RISING_MAINTAINER := xt0032rus
RISING_CHIPSET := SM8550-AB
RISING_BATTERY := 4500mah
RISING_STORAGE := 512gb
RISING_RAM := 12gb
WITH_GMS := true
TARGET_ENABLE_BLUR := true

# GMS
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
