include $(TOPDIR)/rules.mk

all: install

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

linux-compile: utils-install lzma-install
linux-install: $(BIN_DIR)

prepare: 
compile: linux-compile
install: image_clean linux-install
clean: linux-clean utils-clean lzma-clean image_clean

image_clean:
	rm -f $(BIN_DIR)/openwrt-*
	rm -f $(BIN_DIR)/md5sums.txt

linux/package/%:
	$(MAKE) -C $(TOPDIR)/target/linux $(patsubst linux/%,%,$@)

%-clean:
	$(MAKE) -C $(patsubst %-clean,%,$@) clean
%-prepare:
	$(MAKE) -C $(patsubst %-prepare,%,$@) prepare
%-compile: %-prepare
	$(MAKE) -C $(patsubst %-compile,%,$@) compile
%-rebuild: 
	$(MAKE) -C $(patsubst %-rebuild,%,$@) rebuild
%-install: %-compile
	$(MAKE) -C $(patsubst %-install,%,$@) install
linux-imagebuilder:
	$(MAKE) -C linux imagebuilder

