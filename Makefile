DEP_DIR:=deps/
INC_DIR:=include/
LIB_DIR:=lib/

CWD:=$(shell pwd)

INSTALL_PREFIX?=/usr/local/
INSTALL_LIB_DIR=$(INSTALL_PREFIX)/lib
INSTALL_INC_DIR=$(INSTALL_PREFIX)/include

.PHONY: .pre-build all clean

all: $(LIB_DIR)/libhandlegraph.a $(LIB_DIR)/libsdsl.a $(INC_DIR)/sparsepp/spp.h $(LIB_DIR)/libsglib.a;

$(LIB_DIR)/libhandlegraph.a:
	cd $(DEP_DIR)/libhandlegraph && mkdir -p build && cd build && cmake -DCMAKE_INSTALL_PREFIX=$(CWD) .. && make install && cd $(CWD)

$(LIB_DIR)/libsdsl.a:
	cd $(DEP_DIR)/sdsl-lite && ./install.sh $(CWD) && cd $(CWD)

$(INC_DIR)/sparsepp/spp.h:
	cp -r $(DEP_DIR)/sparsepp/sparsepp $(INC_DIR)/

$(LIB_DIR)/libsglib.a:
	cd $(DEP_DIR)/sglib && CPLUS_INCLUDE_PATH=$(CWD)/$(INC_DIR) make && cp lib/libsglib.a $(CWD)/$(LIB_DIR) && cp -r inc/* $(CWD)/$(INC_DIR) && cd $(CWD)

# run .pre-build before we make anything at all.
-include .pre-build

#TODO: clean dependencies
clean:
	rm -r $(LIB_DIR) $(INC_DIR)

install: all
	mkdir -p $(INSTALL_LIB_DIR)
	mkdir -p $(INSTALL_INC_DIR)
	cp -r $(LIB_DIR)/* $(INSTALL_LIB_DIR)/
	cp -r $(INC_DIR)/* $(INSTALL_INC_DIR)/

.pre-build:
	@if [ ! -d $(INSTALL_LIB_DIR) ]; then mkdir -p $(INSTALL_LIB_DIR); fi
	@if [ ! -d $(INSTALL_INC_DIR) ]; then mkdir -p $(INSTALL_INC_DIR); fi