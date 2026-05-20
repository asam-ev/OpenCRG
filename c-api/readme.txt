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
|    |----lib...............location of the compiled OpenCRG library
|    |----inc...............include files providing the interface to the library
|    |----makefile..........sample makefile for users preferring the make mechanism
|    |----obj...............target directory for sources compiled with the make mechanism
|    |----src...............the library's sources
|----compileScript.sh.......script for the compilation of all demos and tools,
|                           based on simple compiler calls; this is an alternative to
|                           using the make mechanism; all files of the base library are
|                           also compiled with this script, so there is no need for a
|                           separate compilation of the library files.
|----demo...................demo sources showing the usage of the basic library
|    |----Simple............a really simple application covering all basics of the API,
|    |                      runs with fix data sample "handmade_straight.crg"
|    |----EvalOptions.......a set of routines demonstrating the usage of various options
|    |----EvalXYnUV.........a set of routines for the evaluation of OpenCRG reference lines
|    |----EvalZ.............an advanced example for the evaluation of OpenCRG data
|    |----Reader............a sample application for a CRG file reader
|    |----bin
|    |    |----crgSimple....executable of the very simple example
|    |    |----crgEvalxyuv..executable of the reference line evaluator
|    |    |----crgReader....executable of the sample reader
|    |    |----crgEvalz.....executable of the complex z data evaluator
|    |    |----crgEvalOpts..executable of the option usage example
|    |----makefile..........makefile for all demos (alternative to "compileScript.sh")
|----makefile
|----readme.txt
|----test
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
|    |----bin
|    |    |----testModifiers.sh...script for performing a series of tests using the
|    |    |                       modifier mechanisms; requires gnuplot
|    |    |----testOptions.sh.....script for performing a series of tests using the
|    |    |                       evaluation option mechanisms; requires gnuplot
|    |    |----crgPerfTest........performance test tool; may not run on all platforms
|    |----makefile................makefile for all tests (alternative to "compileScript.sh")


Compiling:
--------------------------------------------------------------
Three methods for compiling the tool-set are provided:

A) On machines with gcc and standard make environment, just type

      make

   in the root directory. This should result in a series of executable files
   in the directories

      demo/bin/
      test/bin/

   In addition, a library containing all object files of the baselib/ sources
   is created in

      baselib/lib

B) On machines having trouble with the provided makefiles, either adapt those
   files or use the very basic fallback solution which is a compile script.
   The script "compileScript.sh" is located in the root directory

      c-api/

   Open the script, set the compiler variable "COMP" to the name of your compiler,
   re-save the script and execute it. The results should - again - be found in

      demo/bin/
      test/bin/

   In contrast to the makefile mechanism, no library is explicitly created
   from the baselib/ files.

C) If you don't like makefiles and our scripts, you may just write your own
   simple compile instruction at command line level.

   For this purpose, please note the following hints:

   1) In order to compile a demo, set your include file search path to
        baselib/inc
   2) Always compile in combination with all .c-files in
        baselib/src

   Example: For the compilation of EvalXYnUV, use:

            cc -lm -o EvalXYnUV -I baselib/inc demo/EvalXYnUV/src/main.c baselib/src/*.c
