##
## SPDX-License-Identifier: Apache-2.0
##

DEVICE_PATH := device/google/b4s4/b4s4

$(call soong_config_set,libinit,vendor_init_lib,//$(DEVICE_PATH)/libinit:init_google_b4s4)
$(call soong_config_set,mainline_common_libinit,set_properties_from,devicetree)
