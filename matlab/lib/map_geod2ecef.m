function [xyz ell] = map_geod2ecef(llh, ell)
% MAP_GEOD2ECEF MAP convert points from GEOD to ECEF system.
%   [XYZ ELL] = MAP_GEOD2ECEF(LLH, ELL) converts points from GEOD to ECEF
%   system.
%
%   Inputs:
%   LLH     (n, 3) array of points in GEOD system
%   ELL     opt. ELLI struct array
%
%   Outputs:
%   XYZ     (n, 3) array of points in ECEF system
%   ELL     ELLI struct array
%
%   Examples:
%   xyz = map_geod2ecef(llh, ell)
%       converts points from GEOD to ECEF system.
%
%   See also MAP_INTRO.

%   Copyright 2012-2013 OpenCRG - Daimler AG - Jochen Rauh
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
%   $Id: map_geod2ecef.m 345 2014-08-24 20:15:55Z jorauh $

%% check/complement inputs

% ELL
if nargin < 2
    ell = [];
end
ell = map_check_elli(ell);

%% decompose inputs

phi    = llh(:,1)';
lambda = llh(:,2)';
h      = llh(:,3)';

%% prepare scalars

a = ell.a;
b = ell.b;
e2 = 1-b^2/a^2;

%% prepare vectors

sinphi = sin(phi);
cosphi = cos(phi);


%% transform GEOD -> ECEF

% norm radius of curvature in prime vertical
n  = a ./ sqrt(1 - e2 * sinphi .^ 2);

x = (n + h) .* cosphi .* cos(lambda);
y = (n + h) .* cosphi .* sin(lambda);
z = (n * (1 - e2) + h) .* sinphi;

%% compose outputs

xyz = [x' y' z'];

end

% All above formulas are mainly based on the Ordnance Survey publication:
% http://www.ordnancesurvey.co.uk/oswebsite/gps/ ...
%   information/index.html (Overrview)
%   docs/A_Guide_to_Coordinate_Systems_in_Great_Britain.pdf (User Guide)
%   docs/ProjectionandTransformationCalculations.xls (VB implementation)
% last accessed 2012-08-30
%
% Function Lat_Long_H_to_X(PHI, LAM, H, a, b)
% 'Convert geodetic coords lat (PHI), long (LAM) and height (H) to cartesian X coordinate.
% 'Input: - _
%  Latitude (PHI)& Longitude (LAM) both in decimal degrees; _
%  Ellipsoidal height (H) and ellipsoid axis dimensions (a & b) all in meters.
% 
% 'Convert angle measures to radians
%     Pi = 3.14159265358979
%     RadPHI = PHI * (Pi / 180)
%     RadLAM = LAM * (Pi / 180)
% 
% 'Compute eccentricity squared and nu
%     e2 = ((a ^ 2) - (b ^ 2)) / (a ^ 2)
%     V = a / (Sqr(1 - (e2 * ((Sin(RadPHI)) ^ 2))))
% 
% 'Compute X
%     Lat_Long_H_to_X = (V + H) * (Cos(RadPHI)) * (Cos(RadLAM))
% 
% End Function
% 
% Function Lat_Long_H_to_Y(PHI, LAM, H, a, b)
% 'Convert geodetic coords lat (PHI), long (LAM) and height (H) to cartesian Y coordinate.
% 'Input: - _
%  Latitude (PHI)& Longitude (LAM) both in decimal degrees; _
%  Ellipsoidal height (H) and ellipsoid axis dimensions (a & b) all in meters.
% 
% 'Convert angle measures to radians
%     Pi = 3.14159265358979
%     RadPHI = PHI * (Pi / 180)
%     RadLAM = LAM * (Pi / 180)
% 
% 'Compute eccentricity squared and nu
%     e2 = ((a ^ 2) - (b ^ 2)) / (a ^ 2)
%     V = a / (Sqr(1 - (e2 * ((Sin(RadPHI)) ^ 2))))
% 
% 'Compute Y
%     Lat_Long_H_to_Y = (V + H) * (Cos(RadPHI)) * (Sin(RadLAM))
% 
% End Function
% 
% Function Lat_H_to_Z(PHI, H, a, b)
% 'Convert geodetic coord components latitude (PHI) and height (H) to cartesian Z coordinate.
% 'Input: - _
%  Latitude (PHI) decimal degrees; _
%  Ellipsoidal height (H) and ellipsoid axis dimensions (a & b) all in meters.
% 
% 'Convert angle measures to radians
%     Pi = 3.14159265358979
%     RadPHI = PHI * (Pi / 180)
% 
% 'Compute eccentricity squared and nu
%     e2 = ((a ^ 2) - (b ^ 2)) / (a ^ 2)
%     V = a / (Sqr(1 - (e2 * ((Sin(RadPHI)) ^ 2))))
% 
% 'Compute X
%     Lat_H_to_Z = ((V * (1 - e2)) + H) * (Sin(RadPHI))
% 
% End Function
