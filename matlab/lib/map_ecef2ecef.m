function [xyzb tran] = map_ecef2ecef(xyza, tran, fwbw)
% MAP_ECEF2ECEF MAP executes a datum transformation.
%   XYZB = MAP_ECEF2ECEF(XYZA, TRAN, FWBW) executes datum transformation.
%
%   Inputs:
%   XYZA    (n, 3) array of points of datum A
%   TRAN    opt. TRAN struct array
%   FWBW    opt. forward/backward mode flag
%       'F' forward transformation (default)
%       'B' backward transformation
%
%   Outputs:
%   XAZB    (n, 3) array of points of datum B
%   TRAN    TRAN struct array
%
%   Examples:
%   xyz = map_ecef2ecef(xyz, tran, 'B')
%       executes datum transformation in backward direction.
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
%   $Id: map_ecef2ecef.m 346 2014-08-24 20:52:54Z jorauh $

%% check/complement inputs

% FWBW
if nargin < 3 || isempty(fwbw) 
    fwbw = 'F';
end
fwbw = upper(fwbw);
switch fwbw
    case {'F' 'B'}
    otherwise
        error('MAP:ecef2ecefError', 'illegal input FWBW')
end

% TRAN
if nargin < 2
    tran = [];
end
tran = map_check_tran(tran);

%% prepare local scalars and vectors

nm = tran.nm;

if strcmp(nm, 'NOP') % no transformation
    xyzb = xyza;
    return
end

% 7 parameter Helmert transformation

rx = tran.rx;
ry = tran.ry;
rz = tran.rz;

tv = [tran.tx; tran.ty; tran.tz];

ds = tran.ds;

%% prepare transformation matrix

switch nm
    case 'HL7' % 7 parameter linear Helmert transformation
        % linearized inverse (transposed) cardan rotation matrix
        s = [1              -rz              +ry; ...
            +rz               1              -rx; ...
            -ry             +rx                1]';
    case 'HN7' % 7 parameter nonlin Helmert transformation
        % nonlinear inverse (transposed) cardan rotation matrix
        c1 = cos(rx);
        s1 = sin(rx);
        c2 = cos(ry);
        s2 = sin(ry);
        c3 = cos(rz);
        s3 = sin(rz);
    
        s = [c2*c3           -c2*s3           s2; ...
            c1*s3+s1*s2*c3 c1*c3-s1*s2*s3 -s1*c2; ...
            s1*s3-c1*s2*c3 s1*c3+c1*s2*s3  c1*c2]';
    case 'HS7' % 7 parameter simple Helmert transformation
        % linearized inverse (transposed) cardan rotation matrix
        if strcmp(fwbw, 'B')
            ds = -ds;
            tv = -tv;
            rx = -rx;
            ry = -ry;
            rz = -rz;
            fwbw = 'F';
        end
        s = [1+ds           -rz              +ry; ...
            +rz            1+ds              -rx; ...
            -ry             +rx             1+ds]';
        ds = 0;
end
        
%% evaluate transformation

n = size(xyza,1);

switch fwbw
    case 'F'
        xyzb = repmat(tv,1,n) + (1+ds)*s*xyza';
    case 'B'
        xyzb = s \ (xyza' - repmat(tv,1,n)) / (1+ds);
end
xyzb = xyzb';

end
% All above formulas are mainly based on the Ordnance Survey publication:
% http://www.ordnancesurvey.co.uk/oswebsite/gps/ ...
%   information/index.html (Overrview)
%   docs/A_Guide_to_Coordinate_Systems_in_Great_Britain.pdf (User Guide)
%   docs/ProjectionandTransformationCalculations.xls (VB implementation)
% last accessed 2012-08-30
%
% Function Helmert_X(X, Y, Z, DX, Y_Rot, Z_Rot, s)
% 'Computed Helmert transformed X coordinate.
% 'Input: - _
%  cartesian XYZ coords (X,Y,Z), X translation (DX) all in meters ; _
%  Y and Z rotations in seconds of arc (Y_Rot, Z_Rot) and scale in ppm (s).
%  
% 'Convert rotations to radians and ppm scale to a factor
%     Pi = 3.14159265358979
%     sfactor = s * 0.000001
%     RadY_Rot = (Y_Rot / 3600) * (Pi / 180)
%     RadZ_Rot = (Z_Rot / 3600) * (Pi / 180)
%     
% 'Compute transformed X coord
%     Helmert_X = X + (X * sfactor) - (Y * RadZ_Rot) + (Z * RadY_Rot) + DX
%  
% End Function
% 
% Function Helmert_Y(X, Y, Z, DY, X_Rot, Z_Rot, s)
% 'Computed Helmert transformed Y coordinate.
% 'Input: - _
%  cartesian XYZ coords (X,Y,Z), Y translation (DY) all in meters ; _
%  X and Z rotations in seconds of arc (X_Rot, Z_Rot) and scale in ppm (s).
%  
% 'Convert rotations to radians and ppm scale to a factor
%     Pi = 3.14159265358979
%     sfactor = s * 0.000001
%     RadX_Rot = (X_Rot / 3600) * (Pi / 180)
%     RadZ_Rot = (Z_Rot / 3600) * (Pi / 180)
%     
% 'Compute transformed Y coord
%     Helmert_Y = (X * RadZ_Rot) + Y + (Y * sfactor) - (Z * RadX_Rot) + DY
%  
% End Function
% 
% Function Helmert_Z(X, Y, Z, DZ, X_Rot, Y_Rot, s)
% 'Computed Helmert transformed Z coordinate.
% 'Input: - _
%  cartesian XYZ coords (X,Y,Z), Z translation (DZ) all in meters ; _
%  X and Y rotations in seconds of arc (X_Rot, Y_Rot) and scale in ppm (s).
%  
% 'Convert rotations to radians and ppm scale to a factor
%     Pi = 3.14159265358979
%     sfactor = s * 0.000001
%     RadX_Rot = (X_Rot / 3600) * (Pi / 180)
%     RadY_Rot = (Y_Rot / 3600) * (Pi / 180)
%     
% 'Compute transformed Z coord
%     Helmert_Z = (-1 * X * RadY_Rot) + (Y * RadX_Rot) + Z + (Z * sfactor) + DZ
%  
% End Function

