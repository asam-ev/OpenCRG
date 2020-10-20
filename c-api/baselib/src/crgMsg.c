/* ===================================================
 *  message handling routines for the OpenCRG project      
 * ---------------------------------------------------
 * 
 * ASAM OpenCRG C API
 * 
 * OpenCRG version:           1.2.0
 * 
 * package:               baselib
 * file name:             crgMsg.c 
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
#include "crgBaseLibPrivate.h"
#include <stdio.h>

/* ====== LOCAL VARIABLES ====== */
static int mLevel = dCrgMsgLevelNotice;

/* ====== LOCAL METHODS ====== */

/* ====== IMPLEMENTATION ====== */

void
crgMsgSetLevel( int level )
{
    if ( level >= dCrgMsgLevelNone && level <= dCrgMsgLevelDebug )
        mLevel = level;
    
    /* --- update the setting in the portability libraries --- */
    crgPortSetMsgLevel( mLevel );
}
   
int 
crgMsgGetLevel( void )
{
    return mLevel;
}
   
const char* 
crgMsgGetLevelName( int level )
{
    if ( level == dCrgMsgLevelNone )
        return "NONE";
    
    if ( level == dCrgMsgLevelFatal )
        return "FATAL";

    if ( level == dCrgMsgLevelWarn )
        return "WARNING";
   
    if ( level == dCrgMsgLevelNotice )
        return "NOTICE";
    
    if ( level == dCrgMsgLevelInfo )
        return "INFO";
    
    if ( level == dCrgMsgLevelDebug )
        return "DEBUG";
    
    return "unknown level";
}

void
crgMsgSetMaxWarnMsgs( int maxNo )
{
    crgPortSetMaxWarnMsgs( maxNo );
}

void
crgMsgSetMaxLogMsgs( int maxNo )
{
    crgPortSetMaxLogMsgs( maxNo );
}

int
crgMsgIsPrintable( int level )
{
    if ( mLevel < level )
        return 0;
    
    return crgPortMsgIsPrintable( level );
}

