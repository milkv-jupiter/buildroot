################################################################################
#
# weston
#
################################################################################

WESTON_VERSION = 10.0.3
WESTON_SITE = https://gitlab.freedesktop.org/wayland/weston/-/archive/$(WESTON_VERSION)
WESTON_SOURCE = weston-$(WESTON_VERSION).tar.bz2
WESTON_LICENSE = MIT
WESTON_LICENSE_FILES = COPYING
WESTON_CPE_ID_VENDOR = wayland
WESTON_INSTALL_STAGING = YES

WESTON_DEPENDENCIES = host-pkgconf wayland wayland-protocols \
	libxkbcommon pixman libpng udev cairo libinput libdrm

WESTON_CONF_OPTS = \
	-Dbackend-headless=false \
	-Dcolor-management-colord=false \
	-Ddoc=false \
	-Dremoting=false \
	-Dtools=calibrator,debug,info,terminal,touch-calibrator

# Uses VIDIOC_EXPBUF, only available from 3.8+
ifeq ($(BR2_TOOLCHAIN_HEADERS_AT_LEAST_3_8),y)
WESTON_CONF_OPTS += -Dsimple-clients=dmabuf-v4l
else
WESTON_CONF_OPTS += -Dsimple-clients=
endif

ifeq ($(BR2_PACKAGE_DBUS)$(BR2_PACKAGE_SYSTEMD),yy)
WESTON_CONF_OPTS += -Dlauncher-logind=true
WESTON_DEPENDENCIES += dbus systemd
else
WESTON_CONF_OPTS += -Dlauncher-logind=false
endif

ifeq ($(BR2_PACKAGE_SEATD),y)
WESTON_CONF_OPTS += -Dlauncher-libseat=true
WESTON_DEPENDENCIES += seatd
else
WESTON_CONF_OPTS += -Dlauncher-libseat=false
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
WESTON_CONF_OPTS += -Dimage-jpeg=true
WESTON_DEPENDENCIES += jpeg
else
WESTON_CONF_OPTS += -Dimage-jpeg=false
endif

ifeq ($(BR2_PACKAGE_WEBP),y)
WESTON_CONF_OPTS += -Dimage-webp=true
WESTON_DEPENDENCIES += webp
else
WESTON_CONF_OPTS += -Dimage-webp=false
endif

# weston-launch must be u+s root in order to work properly
ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
define WESTON_PERMISSIONS
	/usr/bin/weston-launch f 4755 0 0 - - - - -
endef
define WESTON_USERS
	- - weston-launch -1 - - - - Weston launcher group
endef
WESTON_CONF_OPTS += -Ddeprecated-weston-launch=true
WESTON_DEPENDENCIES += linux-pam
else
WESTON_CONF_OPTS += -Ddeprecated-weston-launch=false
endif

ifeq ($(BR2_PACKAGE_HAS_LIBEGL_WAYLAND)$(BR2_PACKAGE_HAS_LIBGLES),yy)
WESTON_CONF_OPTS += -Drenderer-gl=true
WESTON_DEPENDENCIES += libegl libgles
ifeq ($(BR2_PACKAGE_PIPEWIRE)$(BR2_PACKAGE_WESTON_DRM),yy)
WESTON_CONF_OPTS += -Dpipewire=true
WESTON_DEPENDENCIES += pipewire
else
WESTON_CONF_OPTS += -Dpipewire=false
endif
else
WESTON_CONF_OPTS += \
	-Drenderer-gl=false \
	-Dpipewire=false
endif

ifeq ($(BR2_PACKAGE_WESTON_RDP),y)
WESTON_DEPENDENCIES += freerdp
WESTON_CONF_OPTS += -Dbackend-rdp=true
else
WESTON_CONF_OPTS += -Dbackend-rdp=false
endif

ifeq ($(BR2_PACKAGE_WESTON_DRM),y)
WESTON_CONF_OPTS += -Dbackend-drm=true
else
WESTON_CONF_OPTS += -Dbackend-drm=false
endif

ifeq ($(BR2_PACKAGE_WESTON_HEADLESS),y)
WESTON_CONF_OPTS += -Dbackend-headless=true
else
WESTON_CONF_OPTS += -Dbackend-headless=false
endif

ifeq ($(BR2_PACKAGE_WESTON_WAYLAND),y)
WESTON_CONF_OPTS += -Dbackend-wayland=true
else
WESTON_CONF_OPTS += -Dbackend-wayland=false
endif

ifeq ($(BR2_PACKAGE_WESTON_X11),y)
WESTON_CONF_OPTS += -Dbackend-x11=true
WESTON_DEPENDENCIES += libxcb xlib_libX11
else
WESTON_CONF_OPTS += -Dbackend-x11=false
endif

# We're guaranteed to have at least one backend
WESTON_CONF_OPTS += -Dbackend-default=$(call qstrip,$(BR2_PACKAGE_WESTON_DEFAULT_COMPOSITOR))

ifeq ($(BR2_PACKAGE_WESTON_XWAYLAND),y)
WESTON_CONF_OPTS += -Dxwayland=true
WESTON_DEPENDENCIES += cairo libepoxy libxcb xlib_libX11 xlib_libXcursor xwayland
else
WESTON_CONF_OPTS += -Dxwayland=false
endif

ifeq ($(BR2_PACKAGE_LIBVA),y)
WESTON_CONF_OPTS += -Dbackend-drm-screencast-vaapi=true
WESTON_DEPENDENCIES += libva
else
WESTON_CONF_OPTS += -Dbackend-drm-screencast-vaapi=false
endif

ifeq ($(BR2_PACKAGE_LCMS2),y)
WESTON_CONF_OPTS += -Dcolor-management-lcms=true
WESTON_DEPENDENCIES += lcms2
else
WESTON_CONF_OPTS += -Dcolor-management-lcms=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
WESTON_CONF_OPTS += -Dsystemd=true
WESTON_DEPENDENCIES += systemd
else
WESTON_CONF_OPTS += -Dsystemd=false
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
WESTON_CONF_OPTS += -Dtest-junit-xml=true
WESTON_DEPENDENCIES += libxml2
else
WESTON_CONF_OPTS += -Dtest-junit-xml=false
endif

ifeq ($(BR2_PACKAGE_WESTON_SHELL_DESKTOP),y)
WESTON_CONF_OPTS += -Dshell-desktop=true
else
WESTON_CONF_OPTS += -Dshell-desktop=false
endif

ifeq ($(BR2_PACKAGE_WESTON_SHELL_FULLSCREEN),y)
WESTON_CONF_OPTS += -Dshell-fullscreen=true
else
WESTON_CONF_OPTS += -Dshell-fullscreen=false
endif

ifeq ($(BR2_PACKAGE_WESTON_SHELL_IVI),y)
WESTON_CONF_OPTS += -Dshell-ivi=true
else
WESTON_CONF_OPTS += -Dshell-ivi=false
endif

ifeq ($(BR2_PACKAGE_WESTON_SHELL_KIOSK),y)
WESTON_CONF_OPTS += -Dshell-kiosk=true
else
WESTON_CONF_OPTS += -Dshell-kiosk=false
endif

ifeq ($(BR2_PACKAGE_WESTON_DEMO_CLIENTS),y)
WESTON_CONF_OPTS += -Ddemo-clients=true
WESTON_DEPENDENCIES += pango
else
WESTON_CONF_OPTS += -Ddemo-clients=false
endif

define WESTON_INSTALL_CONF_ON_TARGET
	mkdir -p $(TARGET_DIR)/etc/xdg
	$(INSTALL) -D -m 0644 package/weston/weston.ini $(TARGET_DIR)/etc/xdg/weston/weston.ini
	$(INSTALL) -D -m 0755 package/weston/run_weston.sh $(TARGET_DIR)/root/run_weston.sh
endef

WESTON_POST_INSTALL_TARGET_HOOKS += WESTON_INSTALL_CONF_ON_TARGET

$(eval $(meson-package))
