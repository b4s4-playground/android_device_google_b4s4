#
# SPDX-License-Identifier: Apache-2.0
#

ifneq ($(USES_DEVICE_GOOGLE_B4S4),true)
USES_DEVICE_GOOGLE_B4S4 := true
COMMON_PATH := device/google/b4s4

TARGET_BOOTLOADER_BOARD_NAME := sdm670

MAINLINE_QCOM_COMMON_PATH := device/mainline/qcom-common
MAINLINE_QCOM_COMMON_SOC_PATH := $(MAINLINE_QCOM_COMMON_PATH)/soc/sdm670
include device/mainline/qcom-common/BoardConfigMainlineQcomCommon.mk

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    system \
    system_ext \
    vbmeta \
    vendor

# AVB
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# Boot image
BOARD_BOOT_HEADER_VERSION := 2
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_IMAGE_NAME := Image.lz4
BOARD_RAMDISK_USE_LZ4 := true
# non default offsets the recovery ramdisk is ~21mb and
# would otherwise overlap the dtb loaded at the default 0x1f00000
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET := 0x02000000
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/fstab/fstab.b4s4

# Kernel
TARGET_KERNEL_SOURCE := kernel/google/b4s4
TARGET_KERNEL_CONFIG := b4s4_android_defconfig
TARGET_AUTO_COLLECT_KERNEL_MODULE_DEPS := true
TARGET_NEEDS_DTBOIMAGE := true
BOARD_CUSTOM_DTBOIMG_MK := $(COMMON_PATH)/dtbo.mk

# Kernel cmdline
BOARD_KERNEL_CMDLINE := \
    $(MAINLINE_COMMON_ANDROIDBOOT_PARAMS) \
    $(MAINLINE_COMMON_KERNEL_PARAMS) \
    $(MAINLINE_QCOM_KERNEL_PARAMS) \
    $(MAINLINE_QCOM_SOC_ANDROIDBOOT_PARAMS) \
    androidboot.fstab_suffix=b4s4 \
    androidboot.verifiedbootstate=orange \
    console=tty0

BOARD_KERNEL_CMDLINE += \
    panic=0 \
    printk.always_kmsg_dump=1

BOARD_KERNEL_CMDLINE += \
    androidboot.selinux=permissive \
    audit=0

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_USES_METADATA_PARTITION := true

SSI_PARTITIONS := product system system_ext
TREBLE_PARTITIONS := vendor
ALL_PARTITIONS := $(SSI_PARTITIONS) $(TREBLE_PARTITIONS)

$(foreach p, $(call to-upper, $(ALL_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := ext4) \
    $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

# Dynamic partitions
BOARD_SUPER_PARTITION_SIZE := 4072669184
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := $(ALL_PARTITIONS)
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 4068474880
# BOARD_SUPER_PARTITION_SIZE - 4MiB, reserved for lpmake metadata
BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 3267362816
BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := 805306368
BOARD_SUPER_PARTITION_METADATA_DEVICE := system
BOARD_SUPER_PARTITION_BLOCK_DEVICES := system vendor

BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4

# Fastboot
TARGET_BOARD_FASTBOOT_INFO_FILE := $(COMMON_PATH)/misc/fastboot-info.txt

# Filesystem
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_USE_EXT4 := true

-include vendor/lineage/config/BoardConfigReservedSize.mk

# VINTF
DEVICE_MANIFEST_FILE := $(COMMON_PATH)/vintf/manifest.xml

# Stage1 hacks
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

ifeq ($(TARGET_DEVICE),b4s4)
include device/google/b4s4/b4s4/BoardConfigUnified.mk
endif

endif # USES_DEVICE_GOOGLE_B4S4
