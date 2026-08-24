# ===================================================
#  Makefile for OpenCRG project
# ---------------------------------------------------
#
# See the NOTICE file distributed with this work regarding copyright ownership.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# More Information on ASAM OpenCRG can be found here:
# https://www.asam.net/standards/detail/opencrg/
#
#

#library version
REVISION = 2.0.1

#directories
LIB_DIR = lib
SRC_DIR = src
OBJ_DIR = obj
INC_DIR = inc

#Compiler
COMP = gcc

#Compiler options
# CFLGS = -Wall -ggdb -std=c11 -I$(INC_DIR) #all Warnings with debugging
CFLGS = -Wall -O3 -std=c11 -I$(INC_DIR)     #all Warnings with level 3 optimizations

#Compiler call
CC = $(COMP) $(CFLGS)

#SOURCE FILES
SOURCES = \
	crgMgr.c \
	crgMsg.c \
	crgStatistics.c \
	crgContactPoint.c \
	crgEvalxy2uv.c \
	crgEvaluv2xy.c \
	crgEvalz.c \
	crgEvalpk.c \
	crgEvalenh.c \
        crgLoader.c \
        crgOptionMgmt.c \
        crgPortability.c

#EXTERNAL OBJECT FILES
OBJECTS = $(SOURCES:.c=.o)

#Make
lib : all archive

all : $(OBJECTS)

archive :
	mkdir -p $(LIB_DIR)
	rm -f $(LIB_DIR)/libOpenCRG*.a
	ar -r $(LIB_DIR)/libOpenCRG.$(REVISION).a obj/*.o
	cd $(LIB_DIR); ln -s libOpenCRG.$(REVISION).a libOpenCRG.a

clean :
	rm -f $(OBJ_DIR)/*.o
	rm -f $(LIB_DIR)/libOpenCRG*.a

%.o:	$(SRC_DIR)/%.c $(OBJ_DIR)
	$(CC) -c $< -o $(OBJ_DIR)/$@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

#*** FILE DEPENDENCIES : WHERE TO FIND FILES
.PATH: $(SRC_DIR) $(INC_DIR)


