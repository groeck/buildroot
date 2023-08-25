################################################################################
#
# Build the exfat root filesystem image
#
################################################################################

EXFAT_SIZE = $(call qstrip,$(BR2_TARGET_ROOTFS_EXFAT_SIZE))
ifeq ($(BR2_TARGET_ROOTFS_EXFAT)-$(EXFAT_SIZE),y-)
$(error BR2_TARGET_ROOTFS_EXFAT_SIZE cannot be empty)
endif

# qstrip results in stripping consecutive spaces into a single one. So the
# variable is not qstrip-ed to preserve the integrity of the string value.
EXFAT_LABEL = $(subst ",,$(BR2_TARGET_ROOTFS_EXFAT_LABEL))
# ")

EXFAT_OPTS = \
	-f \
	-L "$(EXFAT_LABEL)"

ROOTFS_EXFAT_DEPENDENCIES = host-exfatprogs

define ROOTFS_EXFAT_CMD
	$(RM) -f $@
	truncate -s $(EXFAT_SIZE) $@
	$(HOST_DIR)/sbin/mkfs.exfat $(EXFAT_OPTS) $@
	# No idea how to copy files from $(TARGET_DIR) into $@
	# without mounting it.
	# $(HOST_DIR)/sbin/sload.exfat -f $(TARGET_DIR) $@
endef

$(eval $(rootfs))
