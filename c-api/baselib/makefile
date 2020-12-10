# ===================================================
#  Makefile for OpenCRG project   
# ---------------------------------------------------
# 
# ASAM OpenCRG C API
# 
# OpenCRG version:           1.2.0
# 
# package:               baselib
# file name:             makefile
# author:                ASAM e.V.
# 
# 
# C by ASAM e.V., 2020
# Any use is limited to the scope described in the license terms.
# The license terms can be viewed at www.asam.net/license
# 
# More Information on ASAM OpenCRG can be found here:
# https://www.asam.net/standards/detail/opencrg/
#
#

#library version
REVISION = 1.2.0

#directories
LIB_DIR = lib
SRC_DIR = src
OBJ_DIR = obj
INC_DIR = inc

#Compiler
COMP = gcc

#Compiler options
# CFLGS = -Wall -ggdb -ansi -I$(INC_DIR)	#all Warnings with debugging
CFLGS = -Wall -O3 -ansi -I$(INC_DIR)            #all Warnings with level 3 optimizations

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
        crgLoader.c \
        crgOptionMgmt.c \
        crgPortability.c

#EXTERNAL OBJECT FILES
OBJECTS = $(SOURCES:.c=.o)

#Make
lib : all archive
    
all : $(OBJECTS)

archive :
	rm -f $(LIB_DIR)/libOpenCRG*.a
	ar -r $(LIB_DIR)/libOpenCRG.$(REVISION).a obj/*.o
	cd $(LIB_DIR); ln -s libOpenCRG.$(REVISION).a libOpenCRG.a
    
clean :
	rm -f $(OBJ_DIR)/*.o
	rm -f $(LIB_DIR)/libOpenCRG*.a

%.o:	$(SRC_DIR)/%.c
	$(CC) -c $? -o $(OBJ_DIR)/$@

#*** FILE DEPENCIES : WHERE TO FIND FILES
.PATH: $(SRC_DIR) $(INC_DIR)


