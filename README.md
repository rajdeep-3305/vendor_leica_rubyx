# Leica Camera for rubyx AOSP
### Cloning :
- Clone this repo in `vendor/leica/rubyx` in your working directory by
```
git clone https://github.com/rajdeep-3305/vendor_leica_rubyx vendor/leica/rubyx
```
- Make these changes in **device.mk**
```
# Leica Camera
$(call inherit-product-if-exists, vendor/leica/rubyx/leica-vendor.mk)
```
### Add flag to allow prebuilt ELF files in **BoardConfig.mk** :
```
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
```
