# --- Config ---
PLATFORMDIR   ?= $(HOME)/logue-sdk/platform
INSTALLDIR    ?= ..
PD_DIR        ?= ./pd
PDLIBDIR      ?= ./heavylib

INSTALL := INSTALLDIR=$(INSTALLDIR) install

CATS := genfx oscfx bgfx

SCRIPTS := \
  genfx:nts3kaoss_genfx \
  oscfx:nts3kaoss_oscfx \
  bgfx:nts3kaoss_bgfx

up = $(shell echo $(1) | tr '[:lower:]' '[:upper:]')

define DEF_PATCHES_UP
$(call up,$(1))_PATCHES := \
  $(notdir $(basename $(wildcard $(PD_DIR)/$(1)/*.pd)))
endef

$(foreach c,$(CATS),$(eval $(call DEF_PATCHES_UP,$(c))))

PATCHES := $(GENFX_PATCHES) $(OSCFX_PATCHES) $(BGFX_PATCHES)

ALL_PATCH_DIRS := \
  $(GENFX_PATCHES:%=genfx/%) \
  $(OSCFX_PATCHES:%=oscfx/%) \
  $(BGFX_PATCHES:%=bgfx/%)


# build rule generator
# usage: $(eval $(call GEN_RULE,<cat>,<hvcc -G>))
define GEN_RULE
$(1)/%: $(PD_DIR)/$(1)/%.pd
	@echo "Processing $$(@F) in $(1)..."
	@mkdir -p $$@
	hvcc $$< -G $(2) -o $$@ -n $$(@F) -p $(PDLIBDIR)
	$$(MAKE) -C $$@/logue_unit PLATFORMDIR=$$(PLATFORMDIR)/nts-3_kaoss $(INSTALL)

# define target for each unit
%: $(1)/%
	@:
endef

# Generate rules for all categories
$(foreach kv,$(SCRIPTS), \
  $(eval CAT := $(word 1,$(subst :, ,$(kv)))) \
  $(eval GEN := $(word 2,$(subst :, ,$(kv)))) \
  $(eval $(call GEN_RULE,$(CAT),$(GEN))) \
)

# Targets

.PHONY: all
all: $(ALL_PATCH_DIRS)

.SECONDARY: $(ALL_PATCH_DIRS)

%.zip: %
	@echo "Archiving $@..."
	$(MAKE) -C $</logue_unit clean
	cd $< && \
	  ln -s logue_unit src && \
	  zip -r $(@F) src $(@F:.zip=.nts3unit) ; \
	  rm -f src

.PHONY: zip
zip: $(ALL_PATCH_DIRS:%=%.zip)
	@echo "All patch archives have been created."

.PHONY: clean
clean:
	@set -e; for d in $(ALL_PATCH_DIRS); do \
	  if [ -d $$d/logue_unit ]; then \
	    $(MAKE) -C $$d/logue_unit clean; \
	  fi; \
	done

.PHONY: clean-all
clean-all:
	@set -e; \
	for d in $(ALL_PATCH_DIRS); do \
		rm -rf -- "$$d"; \
	done
