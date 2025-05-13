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

SHARED_PKG_FILES       := $(wildcard $(SHARED_PKG_DIR)/*.vhd)
SHARED_TB_FILES        := $(wildcard $(SHARED_TB)/*.vhd)
SURF_FILES             := $(wildcard $(SURF_DIR)/*.vhd)
SURF_PKG_FILES         := $(wildcard $(SURF_PKG_DIR)/*.vhd)
GHDL_FILES             := $(wildcard $(GHDL_DIR)/*.cf $(GHDL_DIR)/*.ghw $(GHDL_DIR)/*.vcd $(GHDL_DIR)/*.fst $(GHDL_DIR)/*.o)

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
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/base/general/rtl/TextUtilPkg.vhd)                     $(SURF_PKG_DIR)/TextUtilPkg.vhd
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/base/general/rtl/StdRtlPkg.vhd)                       $(SURF_PKG_DIR)/StdRtlPkg.vhd
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/protocols/pgp/pgp4/core/rtl/Pgp4Pkg.vhd)              $(SURF_PKG_DIR)/Pgp4Pkg.vhd
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/base/crc/rtl/CrcPkg.vhd)                              $(SURF_PKG_DIR)/CrcPkg.vhd
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/protocols/ssi/rtl/SsiPkg.vhd)                         $(SURF_PKG_DIR)/SsiPkg.vhd
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/axi/axi-stream/rtl/AxiStreamPkg.vhd)                  $(SURF_PKG_DIR)/AxiStreamPkg.vhd
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/axi/axi-lite/rtl/AxiLitePkg.vhd)                      $(SURF_PKG_DIR)/AxiLitePkg.vhd
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/protocols/packetizer/rtl/AxiStreamPacketizer2Pkg.vhd) $(SURF_PKG_DIR)/AxiStreamPacketizer2Pkg.vhd
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/base/general/rtl/ArbiterPkg.vhd)                      $(SURF_PKG_DIR)/ArbiterPkg.vhd

	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/base/delay/rtl/SlvDelay.vhd)                          $(SURF_DIR)/SlvDelay.vhd
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/base/sync/rtl/RstSync.vhd)                            $(SURF_DIR)/RstSync.vhd
	ln -sf $(shell readlink -f $(SURF_SUBMODULE_DIR)/base/sync/rtl/Synchronizer.vhd)                       $(SURF_DIR)/Synchronizer.vhd
	@echo "[INFO]: surf preparation complete."
