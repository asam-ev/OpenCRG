# ===================================================
#  readme for OpenCRG project
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


About this readme file
--------------------------------------------------------------
This readme file is a complementary file to the readme file
provided in the OpenCRG root directory. Please read the root
directory's file first.


Overview
--------------------------------------------------------------
The C-API provides a tool suite for reading, modifying and
evaluating OpenCRG data files. It is based on plain ANSI-C code
and should therefore allow for the compilation on all relevant
platforms without modification of the source code.


Directory structure:
--------------------------------------------------------------
|----baselib................OpenCRG basic library - the core of the toolset
|    |----inc...............include files providing the interface to the library
|    |----src...............the library's sources
|    |----CMakeLists.txt....CMake listfile to build OpenCRG basic library
|    |----makefile..........sample makefile for users preferring the make mechanism
|----cmake..................directory containing cmake modules
|    |----*.cmake...........cmake modules to set compiler settings, common include directories, etc.
|----demo...................demo sources showing the usage of the basic library
|    |----bin...............target directory for demo executables
|    |----Curvature.........example of crg check which includes refline curvature check 
|    |----EvalOptions.......a set of routines demonstrating the usage of various options
|    |----EvalXYnUV.........a set of routines for the evaluation of OpenCRG reference lines
|    |----EvalZ.............an advanced example for the evaluation of OpenCRG data
|    |----Reader............a sample application for a CRG file reader
|    |----Simple............a really simple application covering all basics of the API
|    |----CMakeLists.txt....CMake listfile to build all demos
|    |----makefile..........makefile for all demos (alternative to "compileScript.sh" and cmake)
|----test
|    |----bin.....................target directory for test executables
|    |----Dump....................reads an OpenCRG file and dumps the values x/y/z/u/v into
|    |                            into a text file "crgDump.txt" - very helpful for debugging
|    |----MemTest.................just a quick test for allocating and releasing CRG data sets
|    |----MultiCp.................test with multiple contact points
|    |----MultiRead...............read multiple data files, evaluate on last file
|    |----PerfTest................test tool for evaluating the performance of the library
|    |----Scan....................perform an x/y-scan of arbitrary CRG data set
|    |----Verify..................test tool for verifying the c-api algorithms; reads an
|    |                            OpenCRG file AND an x/y/z or x/y/z/u/v reference text
|    |                            file containing test points. This will compute the z value
|    |                            at the given x/y locations from the OpenCRG file and then
|    |                            compare the result with the given z reference value
|    |----CMakeLists.txt..........CMake listfile to build all tests
|    |----makefile................makefile for all tests (alternative to "compileScript.sh" and cmake)
|    |----testModifiers.sh........script for performing a series of tests using the
|    |                            modifier mechanisms; requires gnuplot
|    |----testOptions.sh..........script for performing a series of tests using the
|    |                            evaluation option mechanisms; requires gnuplot
|----CMakeLists.txt.........CMake listfile to build OpenCRG basic library, demos and tests
|----compileScript.sh.......script for the compilation of all demos and tools,
|                           based on simple compiler calls; this is an alternative to
|                           using the make mechanism; all files of the base library are
|                           also compiled with this script, so there is no need for a
|                           separate compilation of the library files.
|----makefile...............sample makefile that builds baselib, demos, tests
|----readme.txt


Compiling:
--------------------------------------------------------------
Four methods for compiling the tool-set are provided:

A) On machines with CMake 3.19 or higher and compatible C compiler installed,
   when in a directory containing a CMake listfile, type

       cmake -B build -DCMAKE_BUILD_TYPE=Release
	   
   then type
	   
       cmake --build build --config Release
	   
   Note that CMAKE_BUILD_TYPE will be ignored using multi-config generators. 
   The build type is specified by the --config flag in this case.
   The above is a simplified example and it is assumed that the compiler is 
   detected automatically.
   
   Depending on which sources were built, the OpenCRG basic library or executables can be found in:
   
      baselib/lib/
      demo/bin/
      test/bin/

B) On machines with gcc and standard make environment, just type

      make

   in the root directory. This should result in a series of executable files
   in the directories

      demo/bin/
      test/bin/

   In addition, a library containing all object files of the baselib/ sources
   is created in

      baselib/lib

C) On machines having trouble with the provided makefiles, either adapt those
   files or use the very basic fallback solution which is a compile script.
   The script "compileScript.sh" is located in the root directory

      c-api/

   Open the script, set the compiler variable "COMP" to the name of your compiler,
   re-save the script and execute it. The results should - again - be found in

      demo/bin/
      test/bin/

   In contrast to the makefile mechanism, no library is explicitly created
   from the baselib/ files.

D) If you don't like makefiles and our scripts, you may just write your own
   simple compile instruction at command line level.

   For this purpose, please note the following hints:

   1) In order to compile a demo, set your include file search path to
        baselib/inc
   2) Always compile in combination with all .c-files in
        baselib/src

   Example: For the compilation of EvalXYnUV, use:

            cc -lm -o EvalXYnUV -I baselib/inc demo/EvalXYnUV/src/main.c baselib/src/*.c
