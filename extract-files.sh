#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# If XML files don't have comments before the XML header, use this flag
# Can still be used with broken XML files by using blob_fixup
export TARGET_DISABLE_XML_FIXING=true

set -e

DEVICE=fuxi
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_COMMON=
ONLY_FIRMWARE=
ONLY_TARGET=
KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
    --only-common)
            ONLY_COMMON=true
            ;;
        --only-firmware)
            ONLY_FIRMWARE=true
            ;;
        --only-target)
            ONLY_TARGET=true
            ;;
        -n | --no-cleanup)
            CLEAN_VENDOR=false
            ;;
        -k | --kang)
            KANG="--kang"
            ;;
        -s | --section)
            SECTION="${2}"
            shift
            CLEAN_VENDOR=false
            ;;
        *)
            SRC="${1}"
            ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        odm/etc/camera/enhance_motiontuning.xml|odm/etc/camera/enhance_motiontuning.xml)
            [ "$2" = "" ] && return 0
            sed -i 's/xml=version/xml version/g' "${2}"
            ;;
        odm/etc/camera/motiontuning.xml|odm/etc/camera/motiontuning.xml)
            [ "$2" = "" ] && return 0
            sed -i 's/xml=version/xml version/g' "${2}"
            ;;
        odm/etc/camera/night_motiontuning.xml|odm/etc/camera/night_motiontuning.xml)
            [ "$2" = "" ] && return 0
            sed -i 's/xml=version/xml version/g' "${2}"
            ;;
        odm/lib64/hw/vendor.xiaomi.sensor.citsensorservice@2.0-impl.so)
            [ "$2" = "" ] && return 0
            sed -i 's/_ZN13DisplayConfig10ClientImpl13ClientImplGetENSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEEPNS_14ConfigCallbackE/_ZN13DisplayConfig10ClientImpl4InitENSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEEPNS_14ConfigCallbackE\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0/g' "${2}"
            ;;
        odm/lib64/hw/displayfeature.default.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libstagefright_foundation.so" "libstagefright_foundation-v33.so" "${2}"
            ;;
        odm/lib64/libmt@1.3.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libcrypto.so" "libcrypto-v33.so" "${2}"
            ;;
        odm/etc/init/vendor.xiaomi.sensor.citsensorservice@2.0-service.rc)
            [ "$2" = "" ] && return 0
            sed -i 's/group system input/group system input\n    task_profiles ServiceCapacityLow/' "${2}"
            ;;
        vendor/bin/hw/android.hardware.security.keymint-service-qti | vendor/lib64/libqtikeymint.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --add-needed android.hardware.security.rkp-V3-ndk.so "${2}"
            ;;
        vendor/bin/hw/dolbycodec2 | vendor/bin/hw/vendor.dolby.hardware.dms@2.0-service | vendor/bin/hw/vendor.dolby.media.c2@1.0-service | vendor/lib64/hw/audio.primary.kalama.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --add-needed "libstagefright_foundation-v33.so" "${2}"
            patchelf --add-needed "libshim.so" "${2}"
            ;;
        vendor/etc/seccomp_policy/qwesd@2.0.policy)
            [ "$2" = "" ] && return 0
            echo "pipe2: 1" >> "${2}"
            ;;
        vendor/etc/seccomp_policy/c2audio.vendor.ext-arm64.policy)
            [ "$2" = "" ] && return 0
            grep -q "setsockopt: 1" "${2}" || echo "setsockopt: 1" >> "${2}"
            ;;
        vendor/etc/media_codecs_c2_audio.xml)
            [ "$2" = "" ] && return 0
            sed -i '/media_codecs_dolby_audio/d' "${2}"
            ;;
        vendor/bin/hw/vendor.qti.media.c2@1.0-service|vendor/bin/hw/vendor.dolby.media.c2@1.0-service|vendor/bin/hw/vendor.qti.media.c2audio@1.0-service)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libcodec2_hidl@1.0.so" "${2}"
            "${PATCHELF}" --add-needed "libshim.so" "${2}"
            ;;
        vendor/bin/vendor.dpmd)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "vendor.libdpmframework.so" "${2}"
            "${PATCHELF}" --add-needed "libshim.so" "${2}"
            ;;
        vendor/etc/media_codecs_cape.xml|vendor/etc/media_codecs_diwali_v0.xml|vendor/etc/media_codecs_diwali_v1.xml|vendor/etc/media_codecs_diwali_v2.xml|vendor/etc/media_codecs_taro.xml|vendor/etc/media_codecs_ukee.xml)
            [ "$2" = "" ] && return 0
            sed -i -E '/media_codecs_(google_audio|google_c2|google_telephony|vendor_audio)/d' "${2}"
            ;;
        vendor/etc/media_codecs_kalama.xml|vendor/etc/media_codecs_kalama_vendor.xml)
            [ "$2" = "" ] && return 0
            sed -Ei "/media_codecs_(google_audio|google_c2|google_telephony|vendor_audio)/d" "${2}"
        vendor/etc/vintf/manifest/c2_manifest_vendor.xml)
            sed -ni '/dolby/!p' "${2}"
            ;;
        odm/lib64/libwvhidl.so)
	    [ "$2" = "" ] && return 0
        "${PATCHELF}" --replace-needed "libcrypto.so" "libcrypto-v33.so" "${2}"
	    ;;
        *)
            return 1
            ;;
    esac
    
    return 0
}
function blob_fixup_dry() {
    blob_fixup "$1" ""
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
