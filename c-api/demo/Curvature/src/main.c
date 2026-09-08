/* ===================================================
 *  main program for CRG curvature test
 * ---------------------------------------------------
 *
 * See the NOTICE file distributed with this work regarding copyright ownership.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * More Information on ASAM OpenCRG can be found here:
 * https://www.asam.net/standards/detail/opencrg/
 *
 */

/* ====== INCLUSIONS ====== */
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "crgBaseLib.h"
#include "crgBaseLib.h"
#include "crgBaseLibPrivate.h"


void usage()
{
    crgMsgPrint( dCrgMsgLevelNotice, "usage: crgSimple [options] <filename>\n" );
    crgMsgPrint( dCrgMsgLevelNotice, "       options: -h    show this info\n" );
    crgMsgPrint( dCrgMsgLevelNotice, "       <filename>  input file, default: [%s]\n", "../../Data/handmade_straight.crg" );
    exit( -1 );
}

int main( int argc, char** argv )
{
    char*  filename = "../../../crg-txt/handmade_straight.crg";
    int    dataSetId = 0;

    /* --- decode the command line --- */
    if ( argc > 2 )
        usage();

    if ( argc == 2 )
    {
        argv++;
        argc--;

        if ( !strcmp( *argv, "-h" ) )
            usage();
        else
            filename = *argv;
    }

    /* --- now load the file --- */
    if ( ( dataSetId = crgLoaderReadFile( filename ) ) <= 0 )
    {
        crgMsgPrint( dCrgMsgLevelFatal, "main: error reading data file <%s>.\n", filename );
        usage();
    }

    /* --- check CRG data for consistency and accuracy --- */
    if ( !crgCheck( dataSetId ) )
    {
    	crgMsgPrint ( dCrgMsgLevelFatal, "main: could not validate crg data. \n" );
        return -1;
    }

    crgMsgPrint( dCrgMsgLevelNotice, "main: releasing data set\n" );

    crgDataSetRelease( dataSetId );

    /* --- release remaining data set list --- */
    crgMemRelease();

    crgMsgPrint( dCrgMsgLevelNotice, "main: normal termination\n" );

    return 1;
}

