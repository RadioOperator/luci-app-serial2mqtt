# 
# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-serial2mqtt
PKG_VERSION=1.0.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-serial2mqtt
SECTION:=luci
CATEGORY:=LuCI
SUBMENU:=3. Applications
TITLE:= LuCI config tools for serial2mqtt
PKGARCH:=all
#DEPENDS:=+serial2mqtt
endef

define Package/luci-app-serial2mqtt/description
	This package contains LuCI configuration pages for serial2mqtt.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-serial2mqtt/install

	$(INSTALL_DIR)  $(1)/etc/uci-defaults
	$(INSTALL_BIN)  ./files/etc/uci-defaults/serial2mqtt_def $(1)/etc/uci-defaults/serial2mqtt_def

	$(INSTALL_DIR)  $(1)/etc/config
	$(INSTALL_DIR)  $(1)/etc/init.d
	$(INSTALL_DIR)  $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DIR)  $(1)/usr/lib/lua/luci/controller

	$(INSTALL_DIR)  $(1)/usr/share/serial2mqtt/ssl
	$(CP) files/usr/share/ssl/* $(1)/usr/share/serial2mqtt/ssl/

	$(INSTALL_CONF) ./files/etc/config/serial2mqtt_cfg $(1)/etc/config/serial2mqtt_cfg
	$(INSTALL_BIN)  ./files/etc/init.d/serial2mqtt_init $(1)/etc/init.d/serial2mqtt_init
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/model/cbi/serial2mqtt_cbi.lua $(1)/usr/lib/lua/luci/model/cbi/serial2mqtt_cbi.lua
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/serial2mqtt_ctl.lua $(1)/usr/lib/lua/luci/controller/serial2mqtt_ctl.lua

endef

$(eval $(call BuildPackage,$(PKG_NAME)))
