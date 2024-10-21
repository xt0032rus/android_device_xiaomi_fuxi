#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Configure core_64_bit.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit common LineageOS configurations
$(call inherit-product, vendor/everest/config/common_full_phone.mk)

# Inherit device configurations
$(call inherit-product, device/xiaomi/fuxi/device.mk)

# Device identifier
PRODUCT_DEVICE := fuxi
PRODUCT_NAME := everest_fuxi
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := Xiaomi13
PRODUCT_MANUFACTURER := Xiaomi

TARGET_BOOT_ANIMATION_RES := 1080

# GApps flags
WITH_GAPPS := true
TARGET_PREBUILT_LAWNCHAIR_LAUNCHER := true
TARGET_DEFAULT_PIXEL_LAUNCHER := true

# EverestOS official flags
EVEREST_MAINTAINER := ♦️xt0032rus♦️
EVEREST_BUILD_TYPE := OFFICIAL

# UDFPS FLAGS
TARGET_HAS_UDFPS := true
EXTRA_UDFPS_ANIMATIONS := true

# Pixel laucher blur
TARGET_USES_BLUR_RECENT := false

# Flags
TARGET_SUPPORTS_BLUR := true
TARGET_SUPPORTS_QUICK_TAP := true

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="fuxi_global-user 13 TKQ1.221114.001 V816.0.5.0.UMCMIXM release-keys"

BUILD_FINGERPRINT := Xiaomi/fuxi_global/fuxi:13/TKQ1.221114.001/V816.0.5.0.UMCMIXM:user/release-keys

# GMS
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
