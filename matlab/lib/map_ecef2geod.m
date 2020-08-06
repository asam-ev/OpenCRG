function [llh ell] = map_ecef2geod(xyz, ell)
% MAP_ECEF2GEOD MAP convert points from ECEF to GEOD system.
%   [LLH ELL] = MAP_ECEF2GEOD(XYZ, ELL) converts points from ECEF to GEOD
%   system.
%
%   Inputs:
%   XYZ     (n, 3) array of points in ECEF system
%   ELL     opt. ELLI struct array
%
%   Outputs:
%   LLH     (n, 3) array of points in GEOD system
%   ELL     ELLI struct array
%
%   Examples:
%   llh = map_ecef2geod(xyz, ell)
%       converts points from GEOD to ECEF system.
%
%   See also MAP_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             map_ecef2geod.m 
% author:                ASAM e.V.
%
%
% C by ASAM e.V., 2020
% Any use is limited to the scope described in the license terms.
% The license terms can be viewed at www.asam.net/license
%
% More Information on ASAM OpenCRG can be found here:
% https://www.asam.net/standards/detail/opencrg/
%
% *****************************************************************

%% check/complement inputs

% ELL
if nargin < 2
    ell = [];
end
ell = map_check_elli(ell);

%% prepare scalars

a = ell.a;
b = ell.b;

a2 = a*a;
b2 = b*b;

e2 = 1-b2/a2;
ep2 = a2/b2-1;
f = 1-b/a;

%% prepare vectors

x = xyz(:,1)';
y = xyz(:,2)';
z = xyz(:,3)';

%% longitude

lambda = atan2(y,x);

%% latitude

r = hypot(x,y);
b1 = atan2(z, (1-f)*r);

beps = eps(pi/2); % b is a latitude

i = 0;
m = 5;
while i < m
    b0 = b1;
    phi = atan2(z + b*ep2*sin(b0).^3, r - a*e2*cos(b0).^3);
    sinphi = sin(phi);
    cosphi = cos(phi);
    b1 = atan2((1-f)*sinphi, cosphi);
    
    mabs = max(abs(b1-b0));
    if mabs < 2*beps
        break
    end
    
    i = i + 1;
end
if (i == m) && (mabs > 10*beps)
    warning('MAP:ecef2geodWarning', ...
        'accuracy problem, no final convergence after %d iterations, err = %d [rad]', m, mabs)
end

%% height

% norm radius of curvature in prime vertical
n = a ./ sqrt(1 - e2 * sinphi.^2);

h = r .* cosphi + (z + e2 * n .* sinphi) .* sinphi - n;

%% compose outputs

llh = [phi' lambda' h'];

end
% All above formulas are mainly based on the Ordnance Survey publication:
% http://www.ordnancesurvey.co.uk/oswebsite/gps/ ...
%   information/index.html (Overrview)
%   docs/A_Guide_to_Coordinate_Systems_in_Great_Britain.pdf (User Guide)
%   docs/ProjectionandTransformationCalculations.xls (VB implementation)
% last accessed 2012-08-30
%
% Function XYZ_to_Lat(X, Y, Z, a, b)
% 'Convert XYZ to Latitude (PHI) in Dec Degrees.
% 'Input: - _
%  XYZ cartesian coords (X,Y,Z) and ellipsoid axis dimensions (a & b), all in meters.
% 
% 'THIS FUNCTION REQUIRES THE "Iterate_XYZ_to_Lat" FUNCTION
% 'THIS FUNCTION IS CALLED BY THE "XYZ_to_H" FUNCTION
% 
%     RootXYSqr = Sqr((X ^ 2) + (Y ^ 2))
%     e2 = ((a ^ 2) - (b ^ 2)) / (a ^ 2)
%     PHI1 = Atn(Z / (RootXYSqr * (1 - e2)))
%     
%     PHI = Iterate_XYZ_to_Lat(a, e2, PHI1, Z, RootXYSqr)
%     
%     Pi = 3.14159265358979
%     
%     XYZ_to_Lat = PHI * (180 / Pi)
% 
% End Function
% 
% Function Iterate_XYZ_to_Lat(a, e2, PHI1, Z, RootXYSqr)
% 'Iteratively computes Latitude (PHI).
% 'Input: - _
%  ellipsoid semi major axis (a) in meters; _
%  eta squared (e2); _
%  estimated value for latitude (PHI1) in radians; _
%  cartesian Z coordinate (Z) in meters; _
%  RootXYSqr computed from X & Y in meters.
% 
% 'THIS FUNCTION IS CALLED BY THE "XYZ_to_PHI" FUNCTION
% 'THIS FUNCTION IS ALSO USED ON IT'S OWN IN THE _
%  "Projection and Transformation Calculations.xls" SPREADSHEET
% 
% 
%     V = a / (Sqr(1 - (e2 * ((Sin(PHI1)) ^ 2))))
%     PHI2 = Atn((Z + (e2 * V * (Sin(PHI1)))) / RootXYSqr)
%     
%     Do While Abs(PHI1 - PHI2) > 0.000000001
%         PHI1 = PHI2
%         V = a / (Sqr(1 - (e2 * ((Sin(PHI1)) ^ 2))))
%         PHI2 = Atn((Z + (e2 * V * (Sin(PHI1)))) / RootXYSqr)
%     Loop
% 
%     Iterate_XYZ_to_Lat = PHI2
% 
% End Function
% 
% Function XYZ_to_Long(X, Y)
% 'Convert XYZ to Longitude (LAM) in Dec Degrees.
% 'Input: - _
%  X and Y cartesian coords in meters.
% 
%     Pi = 3.14159265358979
%     
% 'tailor the output to fit the equatorial quadrant as determined by the signs of X and Y
%     If X >= 0 Then 'longitude is in the W90 thru 0 to E90 hemisphere
%         XYZ_to_Long = (Atn(Y / X)) * (180 / Pi)
%     End If
%     
%     If X < 0 And Y >= 0 Then 'longitude is in the E90 to E180 quadrant
%         XYZ_to_Long = ((Atn(Y / X)) * (180 / Pi)) + 180
%     End If
%     
%     If X < 0 And Y < 0 Then 'longitude is in the E180 to W90 quadrant
%         XYZ_to_Long = ((Atn(Y / X)) * (180 / Pi)) - 180
%     End If
%     
% 
% End Function
% 
% Function XYZ_to_H(X, Y, Z, a, b)
% 'Convert XYZ to Ellipsoidal Height.
% 'Input: - _
%  XYZ cartesian coords (X,Y,Z) and ellipsoid axis dimensions (a & b), all in meters.
% 
% 'REQUIRES THE "XYZ_to_Lat" FUNCTION
% 
% 'Compute PHI (Dec Degrees) first
%     PHI = XYZ_to_Lat(X, Y, Z, a, b)
% 
% 'Convert PHI radians
%     Pi = 3.14159265358979
%     RadPHI = PHI * (Pi / 180)
%     
% 'Compute H
%     RootXYSqr = Sqr((X ^ 2) + (Y ^ 2))
%     e2 = ((a ^ 2) - (b ^ 2)) / (a ^ 2)
%     V = a / (Sqr(1 - (e2 * ((Sin(RadPHI)) ^ 2))))
%     H = (RootXYSqr / Cos(RadPHI)) - V
%     
%     XYZ_to_H = H
%     
% End Function
