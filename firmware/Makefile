ROOT_DIR := .

##################################################
GHDL_DIR := $(ROOT_DIR)/ghdl

SHARED_DIR     := $(ROOT_DIR)/shared
SHARED_RTL     := $(SHARED_DIR)/rtl
SHARED_TB      := $(SHARED_DIR)/tb
SHARED_PKG_DIR := $(SHARED_RTL)/pkg

SURF_DIR     := $(SHARED_RTL)/surf
SURF_PKG_DIR := $(SURF_DIR)/pkg

SURF_SUBMODULE_DIR := $(ROOT_DIR)/submodules/surf

SURF_FILES     := $(wildcard $(SURF_DIR)/*.vhd)
SURF_PKG_FILES := $(wildcard $(SURF_PKG_DIR)/*.vhd)
GHDL_FILES     := $(wildcard $(GHDL_DIR)/*.cf $(GHDL_DIR)/*.ghw $(GHDL_DIR)/*.vcd $(GHDL_DIR)/*.fst $(GHDL_DIR)/*.o $(GHDL_DIR)/*tb)

define create_link
    ln -sf $(shell readlink -f $(1)) $(2)/
endef
##################################################


# Targets
.PHONY: all clean prepareSurf

all: prepareSurf

clean:
	@echo "[INFO]: Cleaning up..."
	rm -f $(SURF_FILES)
	rm -f $(SURF_PKG_FILES)
	rm -f $(GHDL_FILES)
	@echo "[INFO]: Clean complete."

prepareSurf:
	@echo "[INFO]: Preparing surf directories..."
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/base/general/rtl/TextUtilPkg.vhd) $(SURF_PKG_DIR)/TextUtilPkg.vhd
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/base/general/rtl/StdRtlPkg.vhd)   $(SURF_PKG_DIR)/StdRtlPkg.vhd

	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/base/delay/rtl/SlvDelay.vhd)      $(SURF_DIR)/SlvDelay.vhd
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/base/general/tb/ClkRst.vhd)       $(SURF_DIR)/ClkRst.vhd
	@echo "[INFO]: surf preparation complete."
