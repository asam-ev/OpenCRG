/* ===================================================
 *  demonstration and test of global coordinate conversion
 *  and the global origin setter
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
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "crgBaseLib.h"


void usage()
{
    crgMsgPrint(dCrgMsgLevelNotice, "usage: crgGlobalOrigin [options] <filename>\n");
    crgMsgPrint(dCrgMsgLevelNotice, "       options: -h      show this info\n");
    crgMsgPrint(dCrgMsgLevelNotice, "       <filename>  input file, example: [%s]\n", "../../../crg-bin/country_road.crg");
    exit(-1);
}

void crg_demo_local_to_global_conversion(int dataSetId, int cpId, int nStepsU)
{
    double crgeps = 1e-6;
    int    i;
    double du;
    double uMin;
    double uMax;
    double vMin;
    double vMax;
    double u;
    double v;
    double x;
    double y;
    double z;
    double e;
    double n;
    double h;
    double xComp;
    double yComp;
    double zComp;
    double dx;
    double dy;
    double dz;

    nStepsU = nStepsU < 1 ? 1 : nStepsU;

    /* --- get extents of data set --- */
    if (!crgDataSetGetURange(dataSetId, &uMin, &uMax))
    {
        crgMsgPrint(dCrgMsgLevelFatal, "error getting crg u range. \n");
        return;
    }

    if (!crgDataSetGetVRange(dataSetId, &vMin, &vMax))
    {
        crgMsgPrint(dCrgMsgLevelFatal, "error getting crg v range. \n");
        return;
    }

    /* --- get du according to n steps and v in middle of road surface --- */
    du = (uMax - uMin) / nStepsU;
    v = 0.5 * (vMax + vMin);

    for (i = 0; i <= nStepsU; i++)
    {
        u = uMin + du * i;

        /* --- local coordinates --- */
        if (!crgEvaluv2xy(cpId, u, v, &x, &y))
        {
            crgMsgPrint(dCrgMsgLevelWarn, "error converting u/v = %+10.4f / %+10.4f to x/y.\n", u, v);
            continue;
        }

        if (!crgEvaluv2z(cpId, u, v, &z))
        {
            crgMsgPrint(dCrgMsgLevelWarn, "error converting u/v = %+10.4f / %+10.4f to z.\n", u, v);
            continue;
        }

        /* --- local to global coordinates --- */
        if (!crgEvalxyz2enh(cpId, x, y, z, &e, &n, &h))
        {
            crgMsgPrint(dCrgMsgLevelWarn, "error converting x/y/z = %+10.4f / %+10.4f / %+10.4f to e/n/h .\n", x, y, z);
            continue;
        }

        /* --- global back to local coordinates for comparison --- */
        if (!crgEvalenh2xyz(cpId, e, n, h, &xComp, &yComp, &zComp))
        {
            crgMsgPrint(dCrgMsgLevelWarn, "error converting e/n/h = %+10.4f / %+10.4f / %+10.4f to x/y/z .\n", e, n, h);
            continue;
        }

        dx = x - xComp;
        dy = y - yComp;
        dz = z - zComp;

        if (fabs(dx) > crgeps)
            crgMsgPrint(dCrgMsgLevelWarn, "converting e/n/h to x differs from the expected result. dx = %g.\n", dx);

        if (fabs(dy) > crgeps)
            crgMsgPrint(dCrgMsgLevelWarn, "converting e/n/h to y differs from the expected result. dy = %g.\n", dy);

        if (fabs(dz) > crgeps)
            crgMsgPrint(dCrgMsgLevelWarn, "converting e/n/h to z differs from the expected result. dz = %g.\n", dz);

        /* --- print results of conversion --- */
        crgMsgPrint(dCrgMsgLevelNotice, "u/v = % 9.4f / % 7.4f --> XYZ: % 9.4f / % 9.4f / % 7.4f --> ENH: % 9.4f / % 9.4f / % 9.4f\n", u, v, x, y, z, e, n, h);
    }
}

int main(int argc, char** argv)
{
    int    cpId;
    char*  filename = "../../../crg-bin/country_road.crg";
    int    dataSetId = 0;

    /* number of equidistant u values to test evaluation on */
    int    nStepsU = 3;

    /* global origin */
    double xoff = 0.0;
    double yoff = 0.0;
    double zoff = 0.0;
    double poff = 0.0;

    /* arbitrary test modifier */
    double crgModRefUFrac = 0.5;
    double crgModRefVFrac = 0.4;
    double crgModRefX     = 100.2;
    double crgModRefY     = 30.5;
    double crgModRefZ     = 12.9;
    double crgModRefPhi   = 3.14159;

    /* --- print the release notes --- */
    crgMsgPrint(dCrgMsgLevelNotice, "Library version info: <%s>\n", crgGetReleaseInfo());

    /* --- decode the command line --- */
    if (argc < 2)
        usage();

    while (argc > 1)
    {
        argv++;
        argc--;

        if (!strcmp(*argv, "-h"))
            usage();
        else
            filename = *argv;
    }

    /* --- load the file --- */
    crgMsgPrint(dCrgMsgLevelNotice, "reading data file <%s>.\n", filename);
    if ((dataSetId = crgLoaderReadFile(filename)) <= 0)
    {
        crgMsgPrint(dCrgMsgLevelFatal, "error reading data file <%s>.\n", filename);
        return -1;
    }

    /* --- create a contact point for evaluation of the data set --- */
    if ((cpId = crgContactPointCreate(dataSetId)) < 0)
    {
        crgMsgPrint(dCrgMsgLevelFatal, "could not create contact point.\n");
        return -1;
    }

    /* --- evaluate local and global coordinates for n steps at v --- */
    crgMsgPrint(dCrgMsgLevelNotice, "\n");
    crgMsgPrint(dCrgMsgLevelNotice, "--- evaluate local (XYZ) and global coordinates (ENH) of unmodified road ---\n");
    crgMsgPrint(dCrgMsgLevelNotice, "\n");

    crg_demo_local_to_global_conversion(dataSetId, cpId, nStepsU);

    /* --- apply arbitrarily chosen modifiers to move local origin --- */
    crgMsgPrint(dCrgMsgLevelNotice, "\n");
    crgMsgPrint(dCrgMsgLevelNotice, "--- apply semi arbitrarily chosen refpoint modifiers to move local origin ---\n");

    crgDataSetGetGlobalOrigin(dataSetId, &xoff, &yoff, &zoff, &poff);
    crgMsgPrint(dCrgMsgLevelNotice, "global CRG origin before modifier: xoff = % 9.4f / yoff = % 9.4f / zoff = % 9.4f / poff = % 5.4f\n", xoff, yoff, zoff, poff);

    crgMsgPrint(dCrgMsgLevelNotice, "\n");
    crgMsgPrint(dCrgMsgLevelNotice, "apply modifier refpoint_u_fraction = % 5.3f\n", crgModRefUFrac);
    crgMsgPrint(dCrgMsgLevelNotice, "apply modifier refpoint_v_fraction = % 5.3f\n", crgModRefVFrac);
    crgMsgPrint(dCrgMsgLevelNotice, "apply modifier refpoint_x   = % 5.3f\n", crgModRefX);
    crgMsgPrint(dCrgMsgLevelNotice, "apply modifier refpoint_y   = % 5.3f\n", crgModRefY);
    crgMsgPrint(dCrgMsgLevelNotice, "apply modifier refpoint_z   = % 5.3f\n", crgModRefZ);
    crgMsgPrint(dCrgMsgLevelNotice, "apply modifier refpoint_phi = % 5.3f\n", crgModRefPhi);
    crgMsgPrint(dCrgMsgLevelNotice, "\n");

    crgDataSetModifierRemoveAll(dataSetId);
    crgDataSetModifierSetDouble(dataSetId, dCrgModRefPointUFrac, crgModRefUFrac);
    crgDataSetModifierSetDouble(dataSetId, dCrgModRefPointV, crgModRefVFrac);
    crgDataSetModifierSetDouble(dataSetId, dCrgModRefPointX, crgModRefX);
    crgDataSetModifierSetDouble(dataSetId, dCrgModRefPointY, crgModRefY);
    crgDataSetModifierSetDouble(dataSetId, dCrgModRefPointZ, crgModRefZ);
    crgDataSetModifierSetDouble(dataSetId, dCrgModRefPointPhi, crgModRefPhi);

    crgDataSetModifiersApply(dataSetId);

    crgDataSetGetGlobalOrigin(dataSetId, &xoff, &yoff, &zoff, &poff);
    crgMsgPrint(dCrgMsgLevelNotice, "global CRG origin after modifier : xoff = % 9.4f / yoff = % 9.4f / zoff = % 9.4f / poff = % 5.4f\n", xoff, yoff, zoff, poff);

    /* set new global origin so that the evaluation returns global z/h coordinates */
    crgMsgPrint(dCrgMsgLevelNotice, "\n");
    crgMsgPrint(dCrgMsgLevelNotice, "set new global origin so that the evaluation returns global z/h coordinates by setting zoff to zero\n");

    crgDataSetSetGlobalOrigin(dataSetId, xoff, yoff, 0.0, poff);
    crgDataSetGetGlobalOrigin(dataSetId, &xoff, &yoff, &zoff, &poff);
    crgMsgPrint(dCrgMsgLevelNotice, "current global CRG origin: xoff = % 9.4f / yoff = % 9.4f / zoff = % 9.4f / poff = % 5.4f\n", xoff, yoff, zoff, poff);
    crgMsgPrint(dCrgMsgLevelNotice, "\n");

    /* evaluate local and global coordinates after modification and origin adjustment */
    crg_demo_local_to_global_conversion(dataSetId, cpId, nStepsU);

    /* --- set new global origin so that the evaluation returns all global coordinates --- */
    crgMsgPrint(dCrgMsgLevelNotice, "\n");
    crgMsgPrint(dCrgMsgLevelNotice, "--- set new global origin to (0,0,0) with poff = 0. xyz evaluation will return global coordinates ---\n");

    crgDataSetSetGlobalOrigin(dataSetId, 0.0, 0.0, 0.0, 0.0);
    crgDataSetGetGlobalOrigin(dataSetId, &xoff, &yoff, &zoff, &poff);
    crgMsgPrint(dCrgMsgLevelNotice, "current global CRG origin: xoff = % 9.4f / yoff = % 9.4f / zoff = % 9.4f / poff = % 5.4f\n", xoff, yoff, zoff, poff);
    crgMsgPrint(dCrgMsgLevelNotice, "\n");

    /* evaluate local and global coordinates after modification and origin adjustment */
    crg_demo_local_to_global_conversion(dataSetId, cpId, nStepsU);

    /* --- end program with cleanup --- */
    crgMsgPrint(dCrgMsgLevelNotice, "\n");
    crgMsgPrint(dCrgMsgLevelNotice, "In summary the results show that global coordinates do not change after the modifications.\n");
    crgMsgPrint(dCrgMsgLevelNotice, "Modifying the global origin lets the user choose the coordinate system to evaluate in.\n");

    /* release data set */
    crgMsgPrint(dCrgMsgLevelNotice, "\n");
    crgMsgPrint(dCrgMsgLevelNotice, "releasing data set\n");

    crgDataSetRelease(dataSetId);

    crgMsgPrint(dCrgMsgLevelNotice, "normal termination\n");

    return 1;
}


