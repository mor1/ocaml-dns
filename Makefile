.PHONY: all clean install build
all: build test doc

NAME=dns

-include Makefile.config

LWT ?= $(shell if ocamlfind query lwt.unix >/dev/null 2>&1; then echo --enable-lwt; fi)
ASYNC ?= $(shell if ocamlfind query async_core >/dev/null 2>&1; then echo --enable-async; fi)
MIRAGE ?= $(shell if ocamlfind query mirage-net >/dev/null 2>&1; then echo --enable-mirage; fi)

ifneq ($(MIRAGE_OS),xen)
TESTS ?= --enable-tests
endif
# disabled by default as they hang at the moment for Async
# NETTESTS ?= --enable-nettests

setup.bin: setup.ml
	ocamlopt.opt -o $@ $< || ocamlopt -o $@ $< || ocamlc -o $@ $<
	$(RM) setup.cmx setup.cmi setup.o setup.cmo

setup.data: setup.bin
	./setup.bin -configure $(LWT) $(ASYNC) $(MIRAGE) $(TESTS) $(NETTESTS)

build: setup.data setup.bin
	./setup.bin -build -j $(J) $(OFLAGS)

doc: setup.data setup.bin
	./setup.bin -doc -j $(J) $(OFLAGS)

install: 
	ocamlfind remove $(NAME) $(OFLAGS)
	./setup.bin -install

test: setup.bin build
	./setup.bin -test

clean: setup.data setup.bin
	./setup.bin -clean $(OFLAGS)
	$(RM) setup.data setup.log setup.bin

distclean: setup.data setup.bin
	./setup.bin -distclean $(OFLAGS)
	$(RM) setup.data setup.log setup.bin

oasis:
	oasis setup-clean
	oasis setup
