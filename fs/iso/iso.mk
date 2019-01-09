################################################################################
#
# tar to archive target filesystem
#
################################################################################

ISO_OPTS := $(call qstrip,$(BR2_TARGET_ROOTFS_ISO_OPTIONS))

define ROOTFS_ISO_CMD
	(mkisofs $(ISO_OPTS) -R -o $@ $(TARGET_DIR))
endef

$(eval $(rootfs))
