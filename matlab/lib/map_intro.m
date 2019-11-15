function [] = map_intro()
% MAP_INTRO MAP routines introduction
%   MAP_INTRO introduces MAP routines and their data structures
%
%   Definitions:
%   ECEF    earth centered earth fixed system data
%           [0 0 0] center of mass of the Earth
%           (n,1)   x   intersects at 0 latitude (Equator)
%           (n,2)   y   intersects at 0 longitude (Greenwich)
%           (n.3)   z   points to north
%
%   GEOD    geodetic system data
%           (n,1)   phi     latitude [-pi/2, pi/2]
%           (n,2)   lambda  longitude [-pi, pi]
%           (n,3)   h       height
%
%   PMAP    projected map data
%           (n,1)   e (x)   east (abscissa)
%           (n,2)   n (y)   north (ordinate)
%           (n,3)   h (z)   height
%
%   ELLI    ellipsoid struct array
%       .nm ellipsoid name identifier
%           'WGS84': numeric axis parameters are given by WGS84 (default)
%           'USERDEFINED': numeric axis parameters are kept
%           other: numeric axis parameters are overwritten for known ids
%           - known ids are defined in MAP_CHECK_ELLI function
%       .a  opt. semi-major axis
%       .b  opt. semi-minor axis (default: a)
%
%           derived ELLI parameters defined by .a, .b:
%
%       .e      eccentricity
%       .e2     eccentricity squared
%       .ep     second eccentricity
%       .ep2    second eccentricity squared
%       .f      flattening
%       .fi     inverse flattening
%       .n      n-value
%           b   = a*sqrt(1-e2) = a*(1-f)
%           e2  = 2*f-f^2 = 1-b^2/a^2 = (a^2-b^2)/a^2
%           e   = sqrt(e2)
%           ep2 = e2/(1-e2) = a^2/b^2-1
%           ep  = sqrt(ep2)
%           f   = (a-b)/a = 1-b/a = 1-sqrt(1-e^2)
%           fi  = 1/f
%           n   = (a-b)/(a+b) = (1-sqrt(1-e2))/(1+sqrt(1-e2)) = f/(2-f)
%
%   TRAN    datum transformation data struct array with transformation type
%           and parameters
%       .nm transformation type
%           'NOP': no transformation (default)
%           'HL7': 7 parameter linear Helmert transformation
%           - rotations assumed to be small
%           'HN7': 7 parameter nonlin Helmert transformation
%           - rotations may be large
%           'HS7': 7 parameter simple Helmert transformation
%            - similar to 'HL7'
%            - as found in most literature sources
%            - scaling only on diagonal elements
%            - reverse transformaton by simple parameter sign change
%
%           parameters for all 7 parameter Helmert transformations:
%
%       .ds  scalar scaling factor minus one (default: 0)
%       .rx  rotation about the x axis (default: 0)
%       .ry  rotation about the y axis (default: 0)
%       .rz  rotation about the z axis (default: 0)
%       .tx  translation along the x axis (default: 0)
%       .ty  translation along the y axis (default: 0)
%       .tz  translation along the z axis (default: 0)
%
%   PROJ    map projection string or struct array
%       .nm projection identifier and zone substring
%           'GK3': Gauss-Krueger with 3deg zones
%           'GK6': Gauss-Krueger with 6deg zones
%           'UTM': universal transverse mercator
%           'TM': transverse mercator
%           Separated by '_' the zone substing is appended to the
%           projection identifier. The zone substring defines the
%           - zone number (GK3: 0...119, GK6: 0...59)
%           - grid zone designator (UTM) (zone number 01...60 and
%             band letter C...X w/o I/O)
%           - the center meridian [deg east] (TM: 0...359)
%           and is optional only for (TM).
%
%           PROJ numeric parameters defined by GK3, GK6, UTM, TM:
%
%       .f0 center meridian scaling (default: 1)
%       .p0 phi0 (latitude of origin) (default: 0)
%       .l0 lambda0 (longitude of origin) (default: 0)
%       .e0 false easting (default: 0)
%       .n0 false northing (default: 0)
%
%           If the zone substring is defined, 
%           - the numeric PROJ parameter l0 is overwritten by the center
%             meridian defined by the zone substring (TM),
%           - all numeric PROJ parameters are overwritten (otherwise)
% 
%   Units   all data is defined in SI units (m, rad)
%
%   See also MAP_CHECK_ELLI, MAP_CHECK_PROJ, MAP_CHECK_TRAN,
%   MAP_GLOBAL2PLOCAL, MAP_PLOCAL2GLOBAL,
%   and many others.

%   Copyright 2012-2015 OpenCRG - Daimler AG - Jochen Rauh
%
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
%
%       http://www.apache.org/licenses/LICENSE-2.0
%
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
%
%   More Information on OpenCRG open file formats and tools can be found at
%
%       http://www.opencrg.org
%
%   $Id: map_intro.m 369 2019-09-12 20:52:13Z jorauh@EMEA.CORPDIR.NET $

%   The MAP routines use algorithms which can be found in many places in
%   literature and many implementations of various authos. Just to mention
%   some sources of implementations which were used:
%
%   Geodetic Transformation Toolbox of Peter Wasmeier,
%   last downloaded 2012-08-23
%   http://www.mathworks.de/matlabcentral/fileexchange/ ...
%   9696-geodetic-transformations-toolbox
%
%   Geodetic Toolbox of Mike Carymer,
%   last downloaded 2012-08-23
%   http://www.mathworks.de/matlabcentral/fileexchange/ ...
%   15285-geodetic-toolbox
%
%   Geodetic Transformation Routines of Gunnar Graefe
%   received 2012-07-23
%   mailto:info@3d-mapping.de
%
%   Some further Web literature links (all last visited 2012-08-30):
%   http://www.wikipedia.org
%   http://www.colorado.edu/geography/gcraft/contents.html
%   http://www.crs-geo.eu
%   http://geographiclib.sourceforge.net
%   http://pubs.er.usgs.gov/publication/pp1395
%
%   Some  further Web literature links (all last visited 2013-10-15):
%   http://www.ordnancesurvey.co.uk/oswebsite/gps/information/index.html
%   http://www.epsg.org/guides/docs/G7-2.pdf
%

%% add application directory and required subdriectories to path

% map_init

%% show help if someone calls this function

help map_intro

end
