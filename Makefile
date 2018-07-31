MAIN_PROG := main

COPYRIGHT := Copyright (C) Lambda Cloud Software 2018

STD = c++98

CC = gcc
CXX = gcc -std=$(STD)
CPP = gcc -E
LINK = gcc

SHELL = /bin/sh

LD_LIBS += -lz
LD_LIBS += -lstdc++

SYS_INC += /usr/local/include \
	/usr/include

CFLAGS += -O -Wall -g
CPPFLAGS += -O -Wall -g

LDFLAGS += -Dall
LDDFLAGS += -Dall

SELF := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR := $(dir $(SELF))
#ROOT_DIR := $(notdir $(patsubst %/,%,$(dir $(SELF))))

OBJ_DIR := obj
SRC_DIR := src

CONFIG_H := config.h
CONFIG_DIR := build

BUILD_CONFIG := $(ROOT_DIR)$(OBJ_DIR)/$(CONFIG_DIR)/$(CONFIG_H)

SRC := $(shell find $(SRC_DIR) -type f -name "*.cpp")
HEADERS := $(shell find $(SRC_DIR) -type f -name "*.hpp")

OBJ := $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%,$(patsubst %.cpp,%.o,$(SRC)))
DEFS := $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%,$(patsubst %.cpp,%.cpp.d,$(SRC)))

SRC_DIRS = $(sort $(dir $(SRC)))
OBJ_DIRS = $(sort $(dir $(OBJ)))

SYS_DATE := $(shell date -R -u)
OS_VERSION := $(shell uname -a)
CC_VERSION := $(shell $(CC) --version | head -n 1)
CPP_VERSION := $(shell $(CXX) --version | head -n 1)
REPO_VERSION := $(lastword $(shell git log | grep commit | head -n1))

LOCAL_INC += $(sort $(dir $(addprefix -I,$(HEADERS))))

LOCAL_INC += -I$(ROOT_DIR)obj/lib/include

LD_LIBS += -L$(ROOT_DIR)obj/lib/lib

CONFIG_INC += -include $(BUILD_CONFIG)

ALL_INC += $(CONFIG_INC)
ALL_INC += $(LOCAL_INC)
ALL_INC += $(addprefix -I,$(SYS_INC))

CFLAGS += $(ALL_INC)
CPPFLAGS += $(ALL_INC)
CXXFLAGS += $(ALL_INC)

LDFLAGS += $(LD_LIBS)

default: all

all: clean build strip
	@echo Make done

blib: init_submodules b_boost_libs
	@echo Building libs

init_submodules:
	@echo Initializing submodules
	git submodule update --init --recursive

b_boost_libs: i_boost_libs
	@echo Building boost
	( cd $(ROOT_DIR)vendor/boost && $(ROOT_DIR)vendor/boost/bootstrap.sh --prefix=$(ROOT_DIR)obj/lib && $(ROOT_DIR)vendor/boost/b2 --prefix=$(ROOT_DIR)obj/lib )

i_boost_libs:
	@echo Installing boost
	( cd $(ROOT_DIR)vendor/boost && $(ROOT_DIR)vendor/boost/b2 --prefix=$(ROOT_DIR)obj/lib install )

prepare:
	@echo Prepare environment
	@echo Needed Object dirs: $(OBJ_DIRS)
	@echo Expected Object files: $(OBJ)
	@echo Expected Source defs: $(DEFS)
	@echo Available Source files: $(SRC)
	@echo Available Source headers: $(HEADERS)
	mkdir -p $(OBJ_DIRS)
	mkdir -p $(dir $(BUILD_CONFIG))

strip:
	strip $(OBJ_DIR)/$(MAIN_PROG)

build: prepare configure define_code compile link
	@echo Build done

configure: $(BUILD_CONFIG)
	@echo Configure done

define_code: $(DEFS)
	@echo Code define done

compile: $(OBJ)
	@echo Compilation done

$(BUILD_CONFIG):
	@echo Generating $(CONFIG_H) in $(BUILD_CONFIG)
	echo "#ifndef _BUILD_CONFIG_H_INCLUDED_" >> $(BUILD_CONFIG)
	echo "#define _BUILD_CONFIG_H_INCLUDED_" >> $(BUILD_CONFIG)
	echo "#define _BUILD_OS_VERSION_ \"$(OS_VERSION)\"" >> $(BUILD_CONFIG)
	echo "#define _BUILD_CC_VERSION_ \"$(CC_VERSION)\"" >> $(BUILD_CONFIG)
	echo "#define _BUILD_CPP_VERSION_ \"$(CPP_VERSION)\"" >> $(BUILD_CONFIG)
	echo "#define _BUILD_CC_CPPFLAGS_ \"$(CPPFLAGS)\"" >> $(BUILD_CONFIG)
	echo "#define _BUILD_CC_LDDFLAGS_ \"$(LDDFLAGS)\"" >> $(BUILD_CONFIG)
	echo "#define _BUILD_CC_CFLAGS_ \"$(CFLAGS)\"" >> $(BUILD_CONFIG)
	echo "#define _BUILD_CC_LDFLAGS_ \"$(LDFLAGS)\"" >> $(BUILD_CONFIG)
	echo "#define _BUILD_REPO_VERSION_ \"$(REPO_VERSION)\"" >> $(BUILD_CONFIG)
	echo "#define _BUILD_SYS_DATE_ \"$(SYS_DATE)\"" >> $(BUILD_CONFIG)
	echo "#define _BUILD_COPYRIGHT_ \"$(COPYRIGHT)\"" >> $(BUILD_CONFIG)
	echo "#endif" >> $(BUILD_CONFIG)

$(OBJ_DIR)/%.cpp.d: $(SRC_DIR)/%.cpp
	@echo Building def $@ from $^
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -M $^ -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo Building $@ from $^
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $^ -o $@

link: compile
	@echo Linking $(MAIN_PROG)
	$(LINK) $(LDFLAGS) $(OBJ) -o $(OBJ_DIR)/$(MAIN_PROG)

install:
	$(MAKE) -f $(OBJ_DIR)/Makefile install

.PHONY : clean
clean:
	@echo Cleaning all

clean_obj_dir:
	@echo Cleaning $(OBJ_DIR)
	-rm -rf $(OBJ_DIR)
