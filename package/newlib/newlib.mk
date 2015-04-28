################################################################################
#
# newlib
#
################################################################################

NEWLIB_VERSION = 1.20.0
# NEWLIB_VERSION = 2.2.0-1
NEWLIB_SITE = ftp://sourceware.org/pub/newlib
NEWLIB_SOURCE=newlib-$(NEWLIB_VERSION).tar.gz
NEWLIB_LICENSE = LGPLv2.1+
NEWLIB_LICENSE_FILES = COPYING.NEWLIB

# Before newlib is configured, we must have the first stage
# cross-compiler and the kernel headers
NEWLIB_DEPENDENCIES = host-gcc-initial linux-headers

# newlib is part of the toolchain so disable the toolchain dependency
NEWLIB_ADD_TOOLCHAIN_DEPENDENCY = NO

NEWLIB_INSTALL_STAGING = YES

define NEWLIB_CONFIGURE_CMDS
	(cd $(@D); \
		echo Configuring newlib; \
		./configure \
			--target=$(GNU_TARGET_NAME) \
			--prefix=/usr \
			--libdir=/lib \
			--disable-newlib-supplied-syscalls \
			--enable-multilib)
endef

define NEWLIB_BUILD_CMDS
	echo Building newlib
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define NEWLIB_INSTALL_STAGING_CMDS
	echo Installing newlib to staging
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(STAGING_DIR) install
endef

define NEWLIB_INSTALL_TARGET_CMDS
	echo Installing newlib to target
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) install
	$(RM) $(addprefix $(TARGET_DIR)/lib/,crt1.o crtn.o crti.o Scrt1.o)
endef

$(eval $(generic-package))
