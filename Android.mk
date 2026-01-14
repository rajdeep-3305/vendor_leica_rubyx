LOCAL_PATH := $(call my-dir)

# ==========================================================
# 1. LEICA PROCESSING LIBS
#===========================================================
define define-leica-lib
include $$(CLEAR_VARS)
LOCAL_MODULE := $1
LOCAL_SRC_FILES := lib64/$1.so
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_PROPRIETARY_MODULE := false
LOCAL_MODULE_PATH := $$(TARGET_OUT_SHARED_LIBRARIES)
include $$(BUILD_PREBUILT)
endef

LEICA_LIBS := \
    libarcsoft_single_chart_calibration \
    libdoc_photo \
    libdoc_photo_c++_shared \
    libgui_shim_miuicamera \
    libmicampostproc_client \
    libmotion_photo \
    libmotion_photo_c++_shared \
    libmotion_photo_mace \
    libsymphony-cpu \
    libbarhopper_v3

$(foreach lib,$(LEICA_LIBS),$(eval $(call define-leica-lib,$(lib))))

# ==========================================================
# 2. HARDWARE INTERFACE LIBS
# ==========================================================
define define-mtk-lib
include $$(CLEAR_VARS)
LOCAL_MODULE := $1
LOCAL_SRC_FILES := system_ext/lib64/$1.so
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_SYSTEM_EXT_MODULE := true
include $$(BUILD_PREBUILT)
endef

MTK_LIBS := \
    libcamera_algoup_jni.xiaomi \
    libcamera_ispinterface_jni.xiaomi \
    libcamera_mianode_jni.xiaomi \
    libmtkisp_metadata_sys \
    vendor.mediatek.hardware.camera.isphal-V1-ndk \
    vendor.mediatek.hardware.camera.isphal@1.0

$(foreach lib,$(MTK_LIBS),$(eval $(call define-mtk-lib,$(lib))))

# ==========================================================
# 3. CONFIGURATION FILES
# ==========================================================
include $(CLEAR_VARS)
LOCAL_MODULE := public.libraries-xiaomi.txt
LOCAL_SRC_FILES := etc/public.libraries-xiaomi.txt
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)
include $(BUILD_PREBUILT)

# ==========================================================
# 4. PRIV-APP (SPLIT APK ASSEMBLY)
# ==========================================================
include $(CLEAR_VARS)
LOCAL_MODULE := MIUICamera
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_PRIVILEGED := true
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_OVERRIDES_PACKAGES := Camera2 Snap MiuiCamera Aperture
LOCAL_REQUIRED_MODULES := \
    $(LEICA_LIBS) \
    $(MTK_LIBS) \
    public.libraries-xiaomi.txt

# --- Split APK Logic ---
my_src_parts := $(sort $(wildcard $(LOCAL_PATH)/app/MIUICamera/MIUICamera.apk.part*))
my_joined_apk := $(call local-intermediates-dir)/MIUICamera.apk
$(my_joined_apk): $(my_src_parts)
	@echo "Joining split APK: $@"
	@mkdir -p $(dir $@)
	@cat $^ > $@
LOCAL_PREBUILT_MODULE_FILE := $(my_joined_apk)
# --- End Split APK Logic ---

include $(BUILD_PREBUILT)

# ==========================================================
# 5. OVERLAYS
# ==========================================================
define define-leica-overlay
include $$(CLEAR_VARS)
LOCAL_MODULE := $1
LOCAL_SRC_FILES := overlay/$1.apk
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $$(TARGET_OUT_PRODUCT)/overlay
include $$(BUILD_PREBUILT)
endef

LEICA_OVERLAYS := \
    MIUIBokehOverlay \
    MIUICameraOverlay \
    MIUIEditorOverlay \
    MIUIGalleryOverlay

$(foreach ov,$(LEICA_OVERLAYS),$(eval $(call define-leica-overlay,$(ov))))
