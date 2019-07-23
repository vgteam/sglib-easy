DEP_DIR:=deps/
INC_DIR:=include/
LIB_DIR:=lib/

CWD:=$(shell pwd)

INSTALL_PREFIX?=/usr/local/
INSTALL_LIB_DIR=$(INSTALL_PREFIX)/lib
INSTALL_INC_DIR=$(INSTALL_PREFIX)/include

all: $(LIB_DIR)/libbdsg.a;

$(LIB_DIR)/libhandlegraph.a:
	cd $(DEP_DIR)/libhandlegraph && mkdir -p build && cd build && cmake -DCMAKE_INSTALL_PREFIX=$(CWD) .. && make install && cd $(CWD)

$(LIB_DIR)/libsdsl.a:
	cd $(DEP_DIR)/sdsl-lite && ./install.sh $(CWD) && cd $(CWD)

$(INC_DIR)/sparsepp/spp.h:
	cp -r $(DEP_DIR)/sparsepp/sparsepp/ $(INC_DIR)/sparsepp

$(INC_DIR)/dynamic.h
	cp -r $(DEP_DIR)/DYNAMIC/include/* $(INC_DIR)

$(LIB_DIR)/libbdsg.a: $(LIB_DIR)/libhandlegraph.a $(LIB_DIR)/libsdsl.a $(INC_DIR)/sparsepp/spp.h $(INC_DIR)/dynamic.h
	cd $(DEP_DIR)/libbdsg && CPLUS_INCLUDE_PATH=$(CWD)/$(INC_DIR) make && cp lib/libbdsg.a $(CWD)/$(LIB_DIR) && cp -r include/* $(CWD)/$(INC_DIR) && cd $(CWD)

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
	@if [ ! -d $(LIB_DIR) ]; then mkdir -p $(LIB_DIR); fi
	@if [ ! -d $(INC_DIR) ]; then mkdir -p $(INC_DIR); fi


.PHONY: .pre-build all clean