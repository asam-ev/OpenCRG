# ===================================================
#  Makefile for OpenCRG project   
# ---------------------------------------------------
# 
# ASAM OpenCRG C API
# 
# OpenCRG version:           1.2.0
# 
# package:               demo/Simple
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

#directories
LIB_INC_DIR = ../../baselib/inc
LIB_DIR     = ../../baselib/lib
SRC_DIR     = src
OBJ_DIR     = obj
INC_DIR     = inc
BIN_TGT     =../bin/crgSimple

#Compiler
COMP = gcc

#Compiler options
CFLGS = -Wall -ggdb -ansi -I$(LIB_INC_DIR) -I$(INC_DIR)	#all Warnings with debugging

#linker options
LFLGS = -L$(LIB_DIR) -lOpenCRG -lm

#Compiler call
CC = $(COMP)

#SOURCE FILES
SOURCES = \
	main.c

#EXTERNAL OBJECT FILES
OBJECTS = $(SOURCES:.c=.o)

#Make
all : $(OBJECTS)
	$(CC) $(OBJ_DIR)/$(OBJECTS) $(LFLGS) -o $(BIN_TGT)
    
clean :
	rm -f $(OBJ_DIR)/*.o
	rm -f $(BIN_TGT)

%.o:	$(SRC_DIR)/%.c
	$(CC) $(CFLGS) -c $? -o $(OBJ_DIR)/$@

#*** FILE DEPENCIES : WHERE TO FIND FILES
.PATH: $(SRC_DIR)


