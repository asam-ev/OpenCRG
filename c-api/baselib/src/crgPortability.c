/* ===================================================
 *  collections of methods which may be subject to 
 *  portability issues     
 * ---------------------------------------------------
 * 
 * ASAM OpenCRG C API
 * 
 * OpenCRG version:           1.2.0
 * 
 * package:               baselib
 * file name:             crgPortability.c 
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
#include <stdarg.h>
#include <stdio.h>

/*
* try to stay compatible with older MSM compilers
*/
#if defined(_MSC_VER) && (_MSC_VER < 1500)
#define vsnprintf _vsnprintf
#endif

/* ====== LOCAL VARIABLES ====== */
static int mMsgLevel    = dCrgMsgLevelNotice;
static int mMaxWarnMsgs = -1;
static int mMaxLogMsgs  = -1;

static void* ( *mCallocCallback ) ( size_t nmemb, size_t size ) = NULL;
static void* ( *mReallocCallback ) ( void* ptr, size_t size ) = NULL;
static void ( *mFreeCallback ) ( void* ptr ) = NULL;
static int ( *mMsgCallback ) ( int level, char* message ) = NULL;

void 
crgMsgPrint( int level, const char *format, ...)
{
    va_list ap;
    int     ret;
    
    if ( mMsgLevel < level )
        return;
    
    /* --- is re-direction activated? --- */
    if ( mMsgCallback )
    {
        char buffer[1024];  /* limit message text to 1024 characters */
        
        buffer[0] = '\0';
        
        va_start ( ap, format );
        ret = vsnprintf( buffer, 1023, format, ap );
        /* NOTE: on some compilers, vsnprintf() may be called _vsnprintf() */
        va_end( ap );

        if ( ret <= 0 )
            fprintf( stderr, "crgMsgPrint: Cannot create message.\n" );
        else
            mMsgCallback( level, buffer );
        
        return;
    }

    /** @todo: this is just a temporary solution and should be completed until 1.0 */
    if ( !mMaxWarnMsgs )
        return;
    
    if ( mMaxWarnMsgs > 0 )
        mMaxWarnMsgs--;

    fprintf( stderr, "%7s: ", crgMsgGetLevelName( level ) );
    
    va_start ( ap, format );
    ret = vfprintf( stderr, format, ap );
    va_end( ap );

    if ( ret <= 0 )
        fprintf( stderr, "crgMsgPrint: Cannot create message.\n" );
}
    
void
crgPortSetMsgLevel( int level )
{
    if ( level >= dCrgMsgLevelNone && level <= dCrgMsgLevelDebug )
        mMsgLevel = level;
}
    
void*
crgCalloc( size_t nmemb, size_t size )
{
    if ( mCallocCallback )
     return mCallocCallback( nmemb , size );   
    return calloc( nmemb, size );
}

void
crgCallocSetCallback( void* ( *func ) ( size_t nmemb, size_t size ) )
{
  mCallocCallback = func;
}

void*
crgRealloc( void* ptr, size_t size )
{
  if ( mReallocCallback )
    return mReallocCallback( ptr, size );
  return realloc( ptr, size );
}

void
crgReallocSetCallback( void* ( *func ) ( void* ptr, size_t size ) )
{
  mReallocCallback = func;
}

void
crgFree( void* ptr )
{
    if ( mFreeCallback )
    {
        mFreeCallback( ptr );
        return;
    }
    free( ptr );
}

void
crgFreeSetCallback( void ( *func ) ( void* ptr ) )
{
    mFreeCallback = func;
}

void
crgPortSetMaxWarnMsgs( int maxNo )
{
    mMaxWarnMsgs = maxNo;
}

void
crgPortSetMaxLogMsgs( int maxNo )
{
    mMaxLogMsgs = maxNo;
}

int
crgPortMsgIsPrintable( int level )
{
    return mMaxWarnMsgs != 0;
}

void
crgMsgSetCallback( int ( *func ) ( int level, char* message ) )
{
    mMsgCallback = func;
}
