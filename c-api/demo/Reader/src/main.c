/* ===================================================
 *  main program for CRG reader   
 * ---------------------------------------------------
 * 
 * ASAM OpenCRG C API
 * 
 * OpenCRG version:           1.2.0
 * 
 * package:               demo/Reader
 * file name:             main.c
 * author:                ASAM e.V.
 * 
 * 
 * C by ASAM e.V., 2020
 * Any use is limited to the scope described in the license terms.
 * The license terms can be viewed at www.asam.net/license
 * 
 * More Information on ASAM OpenCRG can be found here:
 * https://www.asam.net/standards/detail/opencrg/
 *
 */

/* ====== INCLUSIONS ====== */
#include <stdlib.h>
#include <string.h>
#include "crgBaseLib.h"


void usage()
{
    crgMsgPrint( dCrgMsgLevelNotice, "usage: crgReader [options] <filename>\n" );
    crgMsgPrint( dCrgMsgLevelNotice, "       options: -h    show this info\n" );
    crgMsgPrint( dCrgMsgLevelNotice, "       <filename> use indicated file as input file\n" );
    exit( -1 );
}

int main( int argc, char** argv ) 
{
    char* filename = "";
    int dataSetId = 0;
    
    /* --- decode the command line --- */
    if ( argc < 2 )
        usage();
    
    argc--;
    
    while( argc )
    {
        argc--;
        argv++;
        
        if ( !strcmp( *argv, "-h" ) )
            usage();
        
        if ( !argc ) /* last argument is the filename */
        {
            crgMsgPrint( dCrgMsgLevelInfo, "searching file\n" );
            
            if ( argc < 0 )
            {
                crgMsgPrint( dCrgMsgLevelFatal, "Name of input file is missing.\n" );
                usage();
            }
                
            filename = *argv;
        }
    }
    
    /* --- now load the file --- */
    crgMsgSetLevel( dCrgMsgLevelDebug );
    
    if ( ( dataSetId = crgLoaderReadFile( filename ) ) > 0 )
    {
        crgDataPrintHeader( dataSetId );
        crgDataPrintChannelInfo( dataSetId );
        crgDataPrintRoadInfo( dataSetId );
    }

    /* --- check CRG data for consistency and accuracy --- */
    if ( !crgCheck( dataSetId ) )
    {
        crgMsgPrint ( dCrgMsgLevelFatal, "main: could not validate crg data. \n" );
        return -1;
    }
    
    crgMsgPrint( dCrgMsgLevelNotice, "main: normal termination\n" );
    
    return 1;
}

