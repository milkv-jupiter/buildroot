################################################################################
#
# unrar
#
################################################################################

UNRAR_VERSION = 6.1.7
UNRAR_SOURCE = unrarsrc-$(UNRAR_VERSION).tar.gz
UNRAR_SITE = https://www.rarlab.com/rar
UNRAR_LICENSE = unrar
UNRAR_LICENSE_FILES = license.txt
UNRAR_CPE_ID_VENDOR = rarlab

define UNRAR_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) CXX="$(TARGET_CXX)" STRIP="/bin/true" \
		CXXFLAGS="$(TARGET_CXXFLAGS) -pthread" \
		LDFLAGS="$(TARGET_LDFLAGS) -pthread" -C $(@D)
endef

define UNRAR_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR)/usr install
endef

$(eval $(generic-package))
