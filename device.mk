#
# Copyright 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
PRODUCT_PROPERTY_OVERRIDES := \
    wifi.interface=wlan0 \
    ro.opengles.version=196609

PRODUCT_PACKAGES += \
    Launcher3

#enable this for support f2fs with data partion
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
# This ensures the needed build tools are available.
# TODO: make non-linux builds happy with external/f2fs-tool; system/extras/f2fs_utils
ifeq ($(HOST_OS),linux)
TARGET_USERIMAGES_USE_F2FS := true
endif

#copy init.rc for tablet or box product
#ifeq ($(strip $(TARGET_BOARD_PLATFORM_PRODUCT)), box)
#PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rk3368_box/init.rc:root/init.rc
#else
#ifeq ($(strip $(TARGET_BOARD_PLATFORM_PRODUCT)), tablet)
#PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rk3368_32/init.rc:root/init.rc
#endif
#endif

ifneq ($(filter px5%, $(PRODUCT_BUILD_MODULE)), )
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/px5/rockchip_access_cpu_state.ko:system/lib/modules/rockchip_access_cpu_state.ko \
    $(LOCAL_PATH)/px5/init.car.rc:root/init.car.rc \
    $(LOCAL_PATH)/px5/init.connectivity.rc:root/init.connectivity.rc

PRODUCT_PACKAGES += \
    RkCarRecorder
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.${TARGET_BOARD_PLATFORM_PRODUCT}.rc:root/init.${TARGET_BOARD_PLATFORM_PRODUCT}.rc \
    $(LOCAL_PATH)/fstab.rk30board.bootmode.unknown:root/fstab.rk30board.bootmode.unknown \
    $(LOCAL_PATH)/fstab.rk30board.bootmode.emmc:root/fstab.rk30board.bootmode.emmc \
    $(LOCAL_PATH)/init.rk30board.usb.rc:root/init.rk30board.usb.rc

# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)


$(call inherit-product-if-exists, vendor/rockchip/rk3368/device-vendor.mk)

# add for Rogue 
PRODUCT_PACKAGES += libdrm

#for cts requirement
ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.adb.secure=1 \
    persist.sys.usb.config=mtp
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.adb.secure=0 \
    persist.sys.usb.config=mtp,adb
endif
