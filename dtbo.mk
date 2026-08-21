#
# SPDX-License-Identifier: Apache-2.0
#

MKDTBOIMG := $(HOST_OUT_EXECUTABLES)/mkdtboimg$(HOST_EXECUTABLE_SUFFIX)

$(DTBO_OUT):
	mkdir -p $(DTBO_OUT)

$(BOARD_PREBUILT_DTBOIMAGE): $(DTBO_OUT) $(DTC) $(MKDTBOIMG)
	@echo "Building dtbo.img"
	$(hide) find $(DTBO_OUT)/arch/$(KERNEL_ARCH)/boot/dts -type f -name "*.dtbo" | xargs rm -f
	$(call make-dtbo-target,$(KERNEL_DEFCONFIG))
	$(call make-dtbo-target,$(TARGET_KERNEL_DTB))
	$(hide) $(MKDTBOIMG) create $@ --page_size=$(BOARD_KERNEL_PAGESIZE) \
	    `find $(DTBO_OUT)/arch/$(KERNEL_ARCH)/boot/dts/$(dir $(TARGET_DTBO_LIST_WILDCARD)) -type f -name "$(notdir $(TARGET_DTBO_LIST_WILDCARD)).dtbo" | sort`
	$(hide) touch -c $(DTBO_OUT)
