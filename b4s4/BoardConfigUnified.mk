##
## SPDX-License-Identifier: Apache-2.0
##

# Boot parameters
BOARD_KERNEL_CMDLINE += androidboot.hardware=b4s4

TARGET_DTB_LIST_WILDCARD := \
    qcom/sdm670-google-bonito-b4s4 \
    qcom/sdm670-google-sargo-b4s4
TARGET_DTBO_LIST_WILDCARD := qcom/sdm670-google-*

# OTA
TARGET_OTA_ASSERT_DEVICE := bonito,sargo,b4s4

# Graphics: qcom-common sets TARGET_MINIGBM_PLATFORM=msm, but the TARGET_INITIAL_BRINGUP
# fallback in minigbm-upstream/board.mk force-overrides the soong config to "all",
# which compiles x86-only drivers (i915/xe) and breaks on arm64
SOONG_CONFIG_minigbm_upstream_platform := msm
