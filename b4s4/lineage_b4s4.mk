##
## SPDX-License-Identifier: Apache-2.0
##

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit unified b4s4 device configuration
$(call inherit-product, device/google/b4s4/device.mk)
$(call inherit-product, device/google/b4s4/b4s4/device.mk)

PRODUCT_NAME := lineage_b4s4
PRODUCT_DEVICE := b4s4
PRODUCT_BRAND := google
PRODUCT_MODEL := Pixel 3a / 3a XL
PRODUCT_MANUFACTURER := Google

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi
