export ROOT := $(shell realpath ../)
export BOX_DIR := $(dir $(abspath $(lastword $(shell echo $(MAKEFILE_LIST) | cut -d' ' -f1 ))))
export BOX_NAME := $(notdir $(patsubst %/,%,$(BOX_DIR)))
export BUILDS_DIR := $(ROOT)/builds
export COMMON_DIR := $(ROOT)/_common
export NOW := $(shell date +%s)
export PACKER_CACHE_DIR = $(ROOT)/.packer_cache
export TEST_BASEDIR = $(ROOT)/.spec


default:  clean build test copy

clean:
	rm -rf "$(BUILDS_DIR)/$(BOX_NAME)-virtualbox"
	rm -f "$(BUILDS_DIR)/$(BOX_NAME)-virtualbox.box"

build:
	../bin/packer build -var "name=$(BOX_NAME)" -var "output=$(BUILDS_DIR)/$(BOX_NAME)" ./packer.json

test:
	$(call test_box,virtualbox)

copy:
	cp -r "$(BUILDS_DIR)/$(BOX_NAME)-virtualbox" "$(BUILDS_DIR)/$(BOX_NAME)-virtualbox-$(NOW)"
	cp "$(BUILDS_DIR)/$(BOX_NAME)-virtualbox.box" "$(BUILDS_DIR)/$(BOX_NAME)-virtualbox-$(NOW).box"

define test_box
	set -ex; \
	export VAGRANT_BOX="$(BUILDS_DIR)/$(BOX_NAME)-${1}.box"; \
	export SPEC_DIR="$(BOX_DIR)spec"; \
	export TEST_DIR="$(TEST_BASEDIR)/$(BOX_NAME)-$(NOW)-${1}"; \
	mkdir -p "$${TEST_DIR}"; \
	cp "$(COMMON_DIR)/Vagrantfile" "$${TEST_DIR}/Vagrantfile"; \
	pushd "$${TEST_DIR}"; \
    vagrant up --provider=${1} || TEST_EC=$${?}; \
    vagrant destroy -f; \
    vagrant box remove --all $${VAGRANT_BOX}; \
    popd; \
	rm -rf "$${TEST_DIR}"; \
	exit $${TEST_EC}
endef
