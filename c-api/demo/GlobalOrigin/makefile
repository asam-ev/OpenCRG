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

#directories
LIB_INC_DIR = ../../baselib/inc
LIB_DIR     = ../../baselib/lib
SRC_DIR     = src
OBJ_DIR     = obj
INC_DIR     = inc
BIN_TGT     =../bin/crgGlobalOrigin

#Compiler
COMP = gcc

#Compiler options
CFLGS = -Wall -ggdb -std=c11 -I$(LIB_INC_DIR) -I$(INC_DIR)	#all Warnings with debugging

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

%.o:	$(SRC_DIR)/%.c $(OBJ_DIR)
	$(CC) $(CFLGS) -c $< -o $(OBJ_DIR)/$@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

#*** FILE DEPENDENCIES : WHERE TO FIND FILES
.PATH: $(SRC_DIR)


