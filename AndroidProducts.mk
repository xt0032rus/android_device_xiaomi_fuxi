#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/lineage_fuxi.mk

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/rising_fuxi.mk

COMMON_LUNCH_CHOICES := \
    lineage_fuxi-eng \
    lineage_fuxi-userdebug \
    lineage_fuxi-user

COMMON_LUNCH_CHOICES := \
    rising_fuxi-eng \
    rising_fuxi-userdebug \
    rising_fuxi-user
