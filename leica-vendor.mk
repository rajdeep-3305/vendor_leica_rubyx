cat << 'EOF' > leica-vendor.mk
$(call inherit-product-if-exists, vendor/leica/rubyx/Android.mk)

PRODUCT_PACKAGES += \
    MIUICamera \
    libdisplayconfig.system.qti \
    MIUIBokehOverlay \
    MIUICameraOverlay \
    MIUIEditorOverlay \
    MIUIGalleryOverlay

PRODUCT_COPY_FILES += \
    vendor/leica/rubyx/etc/permissions/privapp-permissions-miuicamera.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-miuicamera.xml \
    vendor/leica/rubyx/etc/sysconfig/miuicamera-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/miuicamera-hiddenapi-package-whitelist.xml

PRODUCT_PROPERTY_OVERRIDES += \
    ro.miui.notch=1 \
    persist.vendor.camera.privapp.list=com.android.camera \
    ro.com.google.lens.feature=true
EOF
