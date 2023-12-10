#
# Copyright (C) 2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from karnak device
$(call inherit-product, device/amazon/karnak/device.mk)

PRODUCT_DEVICE := karnak
PRODUCT_NAME := lineage_karnak
PRODUCT_BRAND := Amazon
PRODUCT_MODEL := KFKAWI
PRODUCT_MANUFACTURER := amazon

PRODUCT_GMS_CLIENTID_BASE := android-amazon

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="karnak-user 9 PS7329.3836N 0029294001152 amz-p,release-keys"

BUILD_FINGERPRINT := Amazon/karnak/karnak:9/PS7329.3836N/0029294001152:user/amz-p,release-keys
