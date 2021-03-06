# $Id: Makefile 4284 2006-07-25 19:07:23Z nbd $

include $(TOPDIR)/rules.mk

PKG_NAME:=webif
PKG_VERSION:=0.3
PKG_RELEASE:=11

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

# for whiterussian only:
NVRAM_OPTS=-DNVRAM -lnvram -I$(STAGING_DIR)/usr/include -L$(STAGING_DIR)/usr/lib

include $(TOPDIR)/package/rules.mk

define PKG_mod_template

$$(IPKG_$(1)):
	[ -z "$(2)" ] || install -d -m0755 $$(IDIR_$(1))/usr/lib/webif/lang/$(2)
	$(CP) ./files/usr/lib/webif/lang/$(2)/common.txt $$(IDIR_$(1))/usr/lib/webif/lang/$(2)/
	$(RSTRIP) $$(IDIR_$(1))
	$(IPKG_BUILD) $$(IDIR_$(1)) $(PACKAGE_DIR)

endef

define PKG_theme_template

$$(IPKG_$(1)):
	[ -z "$(2)" ] || install -d -m0755 $$(IDIR_$(1))/www/themes/$(2)
	$(CP) -r ./files/www/themes/$(2)/* $$(IDIR_$(1))/www/themes/$(2)/
	$(RSTRIP) $$(IDIR_$(1))
	$(IPKG_BUILD) $$(IDIR_$(1)) $(PACKAGE_DIR)

endef

$(eval $(call PKG_template,WEBIF,$(PKG_NAME),$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_THEME_XWRT,webif-theme-xwrt,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_THEME_ZEPHYR,webif-theme-zephyr,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_CA,webif-lang-ca,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_CS,webif-lang-cs,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_DA,webif-lang-da,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_DE,webif-lang-de,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_EE,webif-lang-ee,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_ES,webif-lang-es,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_FR,webif-lang-fr,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_HE,webif-lang-he,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_HR,webif-lang-hr,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_HU,webif-lang-hu,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_IT,webif-lang-it,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_NL,webif-lang-nl,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_NO,webif-lang-no,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_PL,webif-lang-pl,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_PT,webif-lang-pt,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_RO,webif-lang-ro,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_RU,webif-lang-ru,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_SQ,webif-lang-sq,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_SV,webif-lang-sv,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_UK,webif-lang-uk,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))
$(eval $(call PKG_template,WEBIF_LANG_ZH,webif-lang-zh,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))

$(eval $(call PKG_theme_template,WEBIF_THEME_XWRT,xwrt))
$(eval $(call PKG_theme_template,WEBIF_THEME_ZEPHYR,zephyr))

$(eval $(call PKG_mod_template,WEBIF_LANG_CA,ca))
$(eval $(call PKG_mod_template,WEBIF_LANG_CS,cs))
$(eval $(call PKG_mod_template,WEBIF_LANG_DA,da))
$(eval $(call PKG_mod_template,WEBIF_LANG_DE,de))
$(eval $(call PKG_mod_template,WEBIF_LANG_EE,ee))
$(eval $(call PKG_mod_template,WEBIF_LANG_ES,es))
$(eval $(call PKG_mod_template,WEBIF_LANG_FR,fr))
$(eval $(call PKG_mod_template,WEBIF_LANG_HE,he))
$(eval $(call PKG_mod_template,WEBIF_LANG_HR,hr))
$(eval $(call PKG_mod_template,WEBIF_LANG_HU,hu))
$(eval $(call PKG_mod_template,WEBIF_LANG_IT,it))
$(eval $(call PKG_mod_template,WEBIF_LANG_NL,nl))
$(eval $(call PKG_mod_template,WEBIF_LANG_NO,no))
$(eval $(call PKG_mod_template,WEBIF_LANG_PL,pl))
$(eval $(call PKG_mod_template,WEBIF_LANG_PT,pt))
$(eval $(call PKG_mod_template,WEBIF_LANG_RO,ro))
$(eval $(call PKG_mod_template,WEBIF_LANG_RU,ru))
$(eval $(call PKG_mod_template,WEBIF_LANG_SQ,sq))
$(eval $(call PKG_mod_template,WEBIF_LANG_SV,sv))
$(eval $(call PKG_mod_template,WEBIF_LANG_UK,uk))
$(eval $(call PKG_mod_template,WEBIF_LANG_ZH,zh))

$(PKG_BUILD_DIR)/.prepared:
	mkdir -p $(PKG_BUILD_DIR)
	touch $@
	
$(PKG_BUILD_DIR)/.configured:
	touch $@

$(PKG_BUILD_DIR)/.built:
	$(TARGET_CC) $(TARGET_CFLAGS) \
		-D_METAPACK \
		$(TARGET_CFLAGS_EXTRA) \
		$(TARGET_LDFLAGS) \
		-o $(PKG_BUILD_DIR)/webifmetabin \
		src/int2human/main.c src/int2human/human_readable.c \
		src/wepkeygen/keygen.c src/wepkeygen/md5.c \
		src/webif-page.c src/bstrip.c src/webifmetabin.c
	$(STRIP) $(PKG_BUILD_DIR)/webifmetabin
	touch $@

$(IPKG_WEBIF): 
	$(CP) -a ./files/* $(IDIR_WEBIF)/
	./create_lang_list.sh . $(IDIR_WEBIF)
	chmod -R 755 $(IDIR_WEBIF)/*
	rm -rf $(IDIR_WEBIF)/usr/lib/webif/lang/	
	rm -rf $(IDIR_WEBIF)/www/themes/zephyr
	rm -f $(IDIR_WEBIF)/www/cgi-bin/webif/*.wip
	./embed_rev.sh $(IDIR_WEBIF)
	install -d $(IDIR_WEBIF)/usr/bin
	install -m0755 $(PKG_BUILD_DIR)/webifmetabin $(IDIR_WEBIF)/usr/bin/webifmetabin
	find $(IDIR_WEBIF) -name CVS | xargs rm -rf
	find $(IDIR_WEBIF) -name .svn | xargs rm -rf
	find $(IDIR_WEBIF) -name *~ | xargs rm -rf
	$(IPKG_BUILD) $(IDIR_WEBIF) $(PACKAGE_DIR)
