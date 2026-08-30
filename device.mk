#
# SPDX-License-Identifier: Apache-2.0
#
COMMON_PATH := device/google/b4s4

AB_OTA_UPDATER := true

TARGET_QCOM_SOC := sdm670
TARGET_QCOM_SOC_FAMILY := sdm670
TARGET_GRAPHICS := mesa
TARGET_AUDIO_HAL := default-aidl
TARGET_SUPPORTS_SUSPEND := false
include device/mainline/qcom-common/optional/options.mk

$(call inherit-product, device/mainline/qcom-common/mainline_qcom-common.mk)

PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_RETROFIT_DYNAMIC_PARTITIONS := true

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 28

# A/B
PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

# fastbootd
PRODUCT_PACKAGES += fastbootd

PRODUCT_PACKAGES += \
    cgroups.b4s4

PRODUCT_PACKAGES += \
    fstab.b4s4 \
    fstab.b4s4.ramdisk \
    init.b4s4.rc \
    init.sargo.rc \
    init.bonito.rc \
    init.recovery.b4s4.rc \
    init.recovery.sargo.rc \
    init.recovery.bonito.rc \
    ueventd.b4s4.rc \
    ueventd.sargo.rc \
    ueventd.bonito.rc \
    modules.blocklist \
    modules.load.normal

# Firmware
PRODUCT_PACKAGES += \
    firmware_b4s4_bundle \
    firmware_b4s4_ipa_fws.mbn

# GPU zap shader
PRODUCT_COPY_FILES += \
    vendor/google/b4s4/proprietary/vendor/firmware/a615_zap.elf:$(TARGET_COPY_OUT_VENDOR)/firmware/qcom/sdm670/a615_zap.mbn

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(COMMON_PATH)/overlays/overlay

PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

PRODUCT_SOONG_NAMESPACES += $(COMMON_PATH)
PRODUCT_SOONG_NAMESPACES += vendor/google/b4s4
