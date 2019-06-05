BOXES = $(wildcard ubuntu-*)

.PHONY: $(BOXES)

default: all

all: ubuntu-18.04 ubuntu-18.04-vvv

ubuntu-18.04:
	$(MAKE) -C ubuntu-18.04

ubuntu-18.04-vvv:
	$(MAKE) -C ubuntu-18.04-vvv