/* ===================================================
 *  convert a xyz to enh coordinates and vice versa
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
#include "crgBaseLibPrivate.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

/* ====== DEFINITIONS ====== */

/* ====== TYPE DEFINITIONS ====== */

/* ====== LOCAL METHODS ====== */

/* ====== IMPLEMENTATION ====== */
int
crgEvalxyz2enh( int cpId, double x, double y, double z, double* e, double* n, double* h)
{
    const CrgContactPointStruct* cp;

    if ( !( cp = crgContactPointGetFromId( cpId ) ) )
        return 0;

    return crgDataEvalxyz2enh(cp->crgData, x, y, z, e, n, h);
}

int 
crgDataSetEvalxyz2enh( int dataSetId, double x, double y, double z, double* e, double* n, double* h )
{
    CrgDataStruct* crgData = crgDataSetAccess(dataSetId);

    if (!crgData)
    {
        crgMsgPrint(dCrgMsgLevelNotice, "crgDataSetEvalxyz2enh: unknown data set %d\n", dataSetId);
        return 0;
    }

    return crgDataEvalxyz2enh(crgData, x, y, z, e, n, h);
}

int
crgDataEvalxyz2enh( const CrgDataStruct *crgData, double x, double y, double z, double* e, double* n, double* h )
{
    if (!crgData)
        return 0;

    double xbeg = crgData->channelX.info.first;
    double ybeg = crgData->channelY.info.first;

    double ps = crgData->util.phiOffSin;
    double pc = crgData->util.phiOffCos;

    /* --- rotate around(xbeg, ybeg) --- */
    double dx = x - xbeg;
    double dy = y - ybeg;

    *e = xbeg + dx * pc - dy * ps;
    *n = ybeg + dx * ps + dy * pc;
    *h = z;

    /* --- translate --- */
    *e += crgData->channelX.info.offset;
    *n += crgData->channelY.info.offset;
    *h += crgData->channelRefZ.info.offset;

    return 1;
}

int
crgEvalenh2xyz( int cpId, double e, double n, double h, double* x, double* y, double* z )
{
    const CrgContactPointStruct* cp;

    if (!(cp = crgContactPointGetFromId(cpId)))
        return 0;

    return crgDataEvalenh2xyz(cp->crgData, e, n, h, x, y, z);
}

int
crgDataSetEvalenh2xyz(int dataSetId, double e, double n, double h, double* x, double* y, double* z )
{
    CrgDataStruct* crgData = crgDataSetAccess(dataSetId);

    if (!crgData)
    {
        crgMsgPrint(dCrgMsgLevelNotice, "crgDataSetEvalenh2xyz: unknown data set %d\n", dataSetId);
        return 0;
    }

    return crgDataEvalenh2xyz(crgData, e, n, h, x, y, z);
}

int
crgDataEvalenh2xyz( const CrgDataStruct* crgData, double e, double n, double h, double* x, double* y, double* z )
{
    if (!crgData)
        return 0;

    double xbeg = crgData->channelX.info.first;
    double ybeg = crgData->channelY.info.first;

    double ps = crgData->util.phiOffSin;
    double pc = crgData->util.phiOffCos;

    /* --- translate --- */
    *x = e - crgData->channelX.info.offset;
    *y = n - crgData->channelY.info.offset;
    *z = h - crgData->channelRefZ.info.offset;

    /* --- rotate around(xbeg, ybeg) --- */
    double dx = *x - xbeg;
    double dy = *y - ybeg;
    *x = xbeg + dx * pc + dy * ps;
    *y = ybeg - dx * ps + dy * pc;

    return 1;
}
