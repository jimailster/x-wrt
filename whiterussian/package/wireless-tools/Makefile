# $Id: Makefile 2664 2005-12-13 20:08:53Z nbd $

include $(TOPDIR)/rules.mk

PKG_NAME:=wireless-tools
PKG_VERSION:=29.pre10
PKG_VERSION_MAJOR:=29
PKG_RELEASE:=1
PKG_MD5SUM:=d04cddba74f3d93a13a298dc1b905cc4

PKG_SOURCE_URL:=http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux
PKG_SOURCE:=wireless_tools.$(PKG_VERSION).tar.gz
PKG_CAT:=zcat

PKG_BUILD_DIR:=$(BUILD_DIR)/wireless_tools.$(PKG_VERSION_MAJOR)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(TOPDIR)/package/rules.mk

$(eval $(call PKG_template,IWLIB,iwlib,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WIRELESS_TOOLS,wireless-tools,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))

$(PKG_BUILD_DIR)/.configured: $(PKG_BUILD_DIR)/.prepared
	touch $@

$(PKG_BUILD_DIR)/.built: $(PKG_BUILD_DIR)/.configured
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS) -I." \
		all iwmulticall
	mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR) \
		PREFIX="$(PKG_INSTALL_DIR)" \
		INSTALL_DIR="$(PKG_INSTALL_DIR)/usr/sbin" \
		INSTALL_LIB="$(PKG_INSTALL_DIR)/usr/lib" \
		install install-iwmulticall
	touch $@

$(IPKG_IWLIB):
	mkdir -p $(IDIR_IWLIB)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libiw.so.$(PKG_VERSION_MAJOR) $(IDIR_IWLIB)/usr/lib/
	$(RSTRIP) $(IDIR_IWLIB)
	$(IPKG_BUILD) $(IDIR_IWLIB) $(PACKAGE_DIR)
	
$(IPKG_WIRELESS_TOOLS):
	mkdir -p $(IDIR_WIRELESS_TOOLS)/usr/sbin
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/iw{config,getid,list,priv,spy} $(IDIR_WIRELESS_TOOLS)/usr/sbin/
	$(RSTRIP) $(IDIR_WIRELESS_TOOLS)
	$(IPKG_BUILD) $(IDIR_WIRELESS_TOOLS) $(PACKAGE_DIR)

install-dev:
	mkdir -p $(STAGING_DIR)/usr/{lib,include}
	$(CP) $(PKG_BUILD_DIR)/libiw.so* $(STAGING_DIR)/usr/lib/
	ln -sf libiw.so.$(PKG_VERSION_MAJOR) $(STAGING_DIR)/usr/lib/libiw.so
	$(CP) $(PKG_BUILD_DIR)/{iwlib,wireless}.h $(STAGING_DIR)/usr/include/
	
uninstall-dev:
	rm -f $(STAGING_DIR)/usr/lib/libiw.*
	rm -f $(STAGING_DIR)/usr/include/{iwlib,wireless}.h

compile: install-dev
clean: uninstall-dev
