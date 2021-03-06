# $Id: Makefile 6726 2007-03-27 16:45:10Z nbd $

include $(TOPDIR)/rules.mk

PKG_NAME:=iptables
PKG_VERSION:=1.3.3
PKG_RELEASE:=3
PKG_MD5SUM:=86d88455520cfdc56fd7ae27897a80a4

PKG_SOURCE_URL:=http://www.netfilter.org/files \
	ftp://ftp.be.netfilter.org/pub/netfilter/iptables/ \
	ftp://ftp.de.netfilter.org/pub/netfilter/iptables/ \
	ftp://ftp.no.netfilter.org/pub/netfilter/iptables/
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_CAT:=bzcat

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

define IPKG_plugin_template

$$(IPKG_$(1)):
	install -m0755 -d $$(IDIR_$(1))/usr/lib/iptables
	for m in $(2); do \
		$(CP) $(PKG_INSTALL_DIR)/usr/lib/iptables/lib$$$${m}.so $$(IDIR_$(1))/usr/lib/iptables/ ; \
	done
	@[ -z "$(3)" ] || $(MAKE) $(3)
	$(RSTRIP) $$(IDIR_$(1))
	$(IPKG_BUILD) $$(IDIR_$(1)) $(PACKAGE_DIR)

endef

include $(TOPDIR)/package/rules.mk
include $(LINUX_DIR)/.config
include $(TOPDIR)/target/linux/netfilter.mk

$(eval $(call PKG_template,IPTABLES,iptables,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,IPTABLES_EXTRA,iptables-extra,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,IPTABLES_UTILS,iptables-utils,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,IP6TABLES,ip6tables,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))

$(eval $(call PKG_template,IPTABLES_MOD_CONNTRACK,iptables-mod-conntrack,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,IPTABLES_MOD_EXTRA,iptables-mod-extra,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,IPTABLES_MOD_FILTER,iptables-mod-filter,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,IPTABLES_MOD_IMQ,iptables-mod-imq,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,IPTABLES_MOD_IPOPT,iptables-mod-ipopt,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,IPTABLES_MOD_IPSEC,iptables-mod-ipsec,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,IPTABLES_MOD_NAT,iptables-mod-nat,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,IPTABLES_MOD_ULOG,iptables-mod-ulog,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))

$(eval $(call IPKG_plugin_template,IPTABLES_MOD_CONNTRACK,$(IPT_CONNTRACK-m)))
$(eval $(call IPKG_plugin_template,IPTABLES_MOD_EXTRA,$(IPT_EXTRA-m)))
$(eval $(call IPKG_plugin_template,IPTABLES_MOD_FILTER,$(IPT_FILTER-m),layer7-install))
$(eval $(call IPKG_plugin_template,IPTABLES_MOD_IMQ,$(IPT_IMQ-m)))
$(eval $(call IPKG_plugin_template,IPTABLES_MOD_IPOPT,$(IPT_IPOPT-m)))
$(eval $(call IPKG_plugin_template,IPTABLES_MOD_IPSEC,$(IPT_IPSEC-m)))
$(eval $(call IPKG_plugin_template,IPTABLES_MOD_NAT,$(IPT_NAT-m)))
$(eval $(call IPKG_plugin_template,IPTABLES_MOD_ULOG,$(IPT_ULOG-m)))

$(PKG_BUILD_DIR)/.configured:
	touch $@

$(PKG_BUILD_DIR)/.built:
	chmod a+x $(PKG_BUILD_DIR)/extensions/.*-test*
	mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		CC=$(TARGET_CC) COPT_FLAGS="$(TARGET_CFLAGS)" \
		KERNEL_DIR=$(LINUX_DIR) PREFIX=/usr \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		all install install-devel
	touch $@
		
$(IPKG_IPTABLES):
	install -d -m0755 $(IDIR_IPTABLES)/etc/config
	install -m0644 ./files/firewall.config $(IDIR_IPTABLES)/etc/config/firewall
	install -d -m0755 $(IDIR_IPTABLES)/etc/init.d
	install -m0755 ./files/firewall.init $(IDIR_IPTABLES)/etc/init.d/S35firewall
	install -m0755 ./files/firewall.user $(IDIR_IPTABLES)/etc/
	install -d -m0755 $(IDIR_IPTABLES)/usr/lib
	install -m0644 ./files/firewall.awk $(IDIR_IPTABLES)/usr/lib
	install -d -m0755 $(IDIR_IPTABLES)/usr/sbin
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/iptables $(IDIR_IPTABLES)/usr/sbin/
	install -d -m0755 $(IDIR_IPTABLES)/usr/lib/iptables
	(cd $(PKG_INSTALL_DIR)/usr/lib/iptables ; \
		$(CP) $(patsubst %,lib%.so,$(IPT_BUILTIN)) $(IDIR_IPTABLES)/usr/lib/iptables/ \
	)
	$(RSTRIP) $(IDIR_IPTABLES)
	$(IPKG_BUILD) $(IDIR_IPTABLES) $(PACKAGE_DIR)

$(IPKG_IPTABLES_EXTRA):
	$(IPKG_BUILD) $(IDIR_IPTABLES_EXTRA) $(PACKAGE_DIR)

$(IPKG_IPTABLES_UTILS):
	install -d -m0755 $(IDIR_IPTABLES_UTILS)/usr/sbin
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/iptables-{save,restore} $(IDIR_IPTABLES_UTILS)/usr/sbin/
	$(RSTRIP) $(IDIR_IPTABLES_UTILS)
	$(IPKG_BUILD) $(IDIR_IPTABLES_UTILS) $(PACKAGE_DIR)

$(IPKG_IP6TABLES):
	install -d -m0755 $(IDIR_IP6TABLES)/usr/sbin
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/ip6tables $(IDIR_IP6TABLES)/usr/sbin/
	install -d -m0755 $(IDIR_IP6TABLES)/usr/lib/iptables
	(cd $(PKG_INSTALL_DIR)/usr/lib/iptables ; \
		$(CP) libip6t_*.so $(IDIR_IP6TABLES)/usr/lib/iptables/ \
	)
	$(RSTRIP) $(IDIR_IP6TABLES)
	$(IPKG_BUILD) $(IDIR_IP6TABLES) $(PACKAGE_DIR)

$(STAGING_DIR)/usr/lib/libipq.a: $(PKG_BUILD_DIR)/.built
	mkdir -p $(STAGING_DIR)/usr/include
	$(CP) $(PKG_BUILD_DIR)/include/iptables{,_common}.h $(STAGING_DIR)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/include/libipq.h $(STAGING_DIR)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/include/libiptc $(STAGING_DIR)/usr/include/
	mkdir -p $(STAGING_DIR)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libipq.a $(STAGING_DIR)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libiptc.a $(STAGING_DIR)/usr/lib/
	$(SED) 's|/usr/local/lib/iptables|/usr/lib/iptables|g' $(STAGING_DIR)/usr/include/iptables.h

layer7-install:
	mkdir -p $(IDIR_IPTABLES_MOD_FILTER)/etc/l7-protocols
	cp files/l7/*.pat $(IDIR_IPTABLES_MOD_FILTER)/etc/l7-protocols/

install-dev: $(STAGING_DIR)/usr/lib/libipq.a

uninstall-dev:
	rm -rf $(STAGING_DIR)/usr/include/iptables{,_common}.h
	rm -rf $(STAGING_DIR)/usr/include/libipq.h
	rm -rf $(STAGING_DIR)/usr/include/libiptc
	rm -rf $(STAGING_DIR)/usr/lib/libipq.a
	rm -rf $(STAGING_DIR)/usr/lib/libiptc.a

compile: install-dev
clean: uninstall-dev
