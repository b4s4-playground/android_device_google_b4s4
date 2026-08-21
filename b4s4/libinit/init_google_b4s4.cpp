//
// SPDX-License-Identifier: Apache-2.0
//

#include <libinit_mainline_common.h>
#include <libinit_utils.h>

#include "vendor_init.h"

#include <android-base/file.h>
#include <android-base/logging.h>

#include <string>

using android::base::ReadFileToString;

#define kDtCompatiblePath "/sys/firmware/devicetree/base/compatible"

struct variant_info_t {
    const char* compatible;
    const char* codename;
    const char* brand;
    const char* device;
    const char* model;
    int lcd_density;
    const char* build_fingerprint;
};

static const variant_info_t kVariants[] = {
    {
        "google,bonito",
        "bonito",
        "Google",
        "bonito",
        "Pixel 3a XL",
        400,
        "google/bonito/bonito:11/RQ3A.211001.001/7641976:user/release-keys"
    },
    {
        "google,sargo",
        "sargo",
        "Google",
        "sargo",
        "Pixel 3a",
        440,
        "google/sargo/sargo:11/RQ3A.211001.001/7641976:user/release-keys"
    },
};

static const variant_info_t* detect_variant() {
    std::string dt_compatible;
    if (!ReadFileToString(kDtCompatiblePath, &dt_compatible)) return nullptr;

    // The compatible property is a NUL-separated string list
    for (const auto& variant : kVariants) {
        if (dt_compatible.find(variant.compatible) != std::string::npos) return &variant;
    }
    return nullptr;
}

void vendor_process_bootenv() {
    vendor_process_bootenv_mainline_common();
}

void vendor_load_properties() {
    // Brand/model from devicetree, insecure debugging, etc.
    vendor_load_properties_mainline_common();

    const variant_info_t* variant = detect_variant();
    if (variant == nullptr) {
        LOG(WARNING) << "Failed to detect b4s4 variant";
        return;
    }

    LOG(INFO) << "Detected b4s4 variant: " << variant->codename;

    LOG(INFO) << "Setting ro.vendor.device.codename to " << variant->codename;
    property_override("ro.vendor.device.codename", variant->codename);

    LOG(INFO) << "Setting ro.product.*.brand to " << variant->brand;
    set_ro_build_prop("brand", variant->brand, true);

    LOG(INFO) << "Setting ro.product.*.device to " << variant->device;
    set_ro_build_prop("device", variant->device, true);

    LOG(INFO) << "Setting ro.product.*.model to " << variant->model;
    set_ro_build_prop("model", variant->model, true);

    LOG(INFO) << "Setting ro.sf.lcd_density to " << variant->lcd_density;
    property_override("ro.sf.lcd_density", std::to_string(variant->lcd_density));

    LOG(INFO) << "Overriding build fingerprint properties to " << variant->build_fingerprint;
    property_override("ro.build.fingerprint", variant->build_fingerprint);
    property_override("ro.bootimage.build.fingerprint", variant->build_fingerprint);
    property_override("ro.system.build.fingerprint", variant->build_fingerprint);
    property_override("ro.vendor.build.fingerprint", variant->build_fingerprint);
    property_override("ro.odm.build.fingerprint", variant->build_fingerprint);
}
