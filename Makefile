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
	rm lib/libhandlegraph.dylib

$(LIB_DIR)/libsdsl.a:
	cd $(DEP_DIR)/sdsl-lite && ./install.sh $(CWD) && cd $(CWD)

$(INC_DIR)/sparsepp/spp.h:
	cp -r $(DEP_DIR)/sparsepp/sparsepp/ $(INC_DIR)/sparsepp

$(INC_DIR)/dynamic.h:
	cp -r $(DEP_DIR)/DYNAMIC/include/* $(INC_DIR)
	# annoyingly doesn't have an install option on the cmake, so we manually move their external dependency headers
	cd $(DEP_DIR)/DYNAMIC && mkdir -p build && cd build && cmake .. && make && cp -r hopscotch_map-prefix/src/hopscotch_map/include/* $(CWD)/$(INC_DIR) && cd $(CWD)

$(INC_DIR)/BooPHF.h:
	cp $(DEP_DIR)/BBHash/BooPHF.h $(INC_DIR)

$(LIB_DIR)/libbdsg.a: $(LIB_DIR)/libhandlegraph.a $(LIB_DIR)/libsdsl.a $(INC_DIR)/sparsepp/spp.h $(INC_DIR)/dynamic.h $(INC_DIR)/BooPHF.h
	cd $(DEP_DIR)/libbdsg && CPLUS_INCLUDE_PATH=$(CWD)/$(INC_DIR):$(CPLUS_INCLUDE_PATH) LIBRARY_PATH=$(CWD)/$(LIB_DIR):$(LIBRARY_PATH) make test && cp lib/libbdsg.a $(CWD)/$(LIB_DIR) && cp -r include/* $(CWD)/$(INC_DIR) && cd $(CWD)

# run .pre-build before we make anything at all.
-include .pre-build

clean:
	rm -r $(LIB_DIR) $(INC_DIR)
	if [ -d $(DEP_DIR)/libhandlegraph/build ]; then cd $(DEP_DIR)/libhandlegraph/build && make clean && cd .. & rm -rf build & cd $(CWD); fi
	if [ -d $(DEP_DIR)/libhandlegraph/build ]; then cd $(DEP_DIR)/sdsl-lite/build && make clean && cd .. & rm -rf build & cd $(CWD); fi
	cd $(DEP_DIR)/libbdsg/ && make clean && cd $(CWD)
	

install: all
	mkdir -p $(INSTALL_LIB_DIR)
	mkdir -p $(INSTALL_INC_DIR)
	cp -r $(LIB_DIR)/* $(INSTALL_LIB_DIR)/
	cp -r $(INC_DIR)/* $(INSTALL_INC_DIR)/

.pre-build:
	@if [ ! -d $(LIB_DIR) ]; then mkdir -p $(LIB_DIR); fi
	@if [ ! -d $(INC_DIR) ]; then mkdir -p $(INC_DIR); fi


.PHONY: .pre-build all clean
