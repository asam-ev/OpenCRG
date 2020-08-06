function [phi ell pro] = map_ptm_north2initiallat(north, ell, pro)
% MAP_PTM_NORTH2INITIALLAT MAP transverse mercator utility function.
%   [PHI ELL PRO] = MAP_PTM_NORTH2INITIALLAT(PHI, ELL, PRO) computes the 
%   initial value for latitude needed for transverse mercator projections.
%
%   Inputs:
%   NORTH   (n) vector of northings
%   ELL     opt. ELLI struct array
%   PRO     opt. PROJ struct array
%
%   Outputs:
%   PHI     (n) vector of initialo values for latitude
%   ELL     ELLI struct array
%   PRO     PROJ struct array
%
%   Examples:
%   phi = map_ptm_north2initiallat(north, ell, pro)
%       calculates initial latitude values.
%
%   See also MAP_INTRO, MAP_PMAP2GEOD_TM.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             map_ptm_north2initiallat.m 
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

% PRO
if nargin < 3
    pro = [];
end
pro = map_check_proj(pro);

% ELL
if nargin < 2
    ell = [];
end
ell = map_check_elli(ell);

%%

f0 = pro.f0;
n0 = pro.n0;
p0 = pro.p0;

a = ell.a;

%%

nn0 = north-n0;

marc = 0;
phi = p0;

aeps = eps(a); % nn0 has magitude of ellipsoid axis

i = 0;
m = 10;
while i < m
    phi = phi + (nn0-marc)/(a*f0);
    marc = map_ptm_phi2marc(phi, ell, pro);
    
    mabs = max(abs(nn0-marc));
    
    if mabs < 2*aeps
        break
    end
    
    i = i+1;
end

if (i == m) && (mabs > 10*aeps)
    warning('MAP:tm_north2initiallatWarning', ...
        'accuracy problem, no final convergence after %d iterations, err = %d [m]', m, mabs)
end

end
% All above formulas are mainly based on the Ordnance Survey publication:
% http://www.ordnancesurvey.co.uk/oswebsite/gps/ ...
%   information/index.html (Overrview)
%   docs/A_Guide_to_Coordinate_Systems_in_Great_Britain.pdf (User Guide)
%   docs/ProjectionandTransformationCalculations.xls (VB implementation)
% last accessed 2012-08-30
%
% Function InitialLat(North, n0, afo, PHI0, n, bfo)
% 'Compute initial value for Latitude (PHI) IN RADIANS.
% 'Input: - _
%  northing of point (North) and northing of false origin (n0) in meters; _
%  semi major axis multiplied by central meridian scale factor (af0) in meters; _
%  latitude of false origin (PHI0) IN RADIANS; _
%  n (computed from a, b and f0) and _
%  ellipsoid semi major axis multiplied by central meridian scale factor (bf0) in meters.
%  
% 'REQUIRES THE "Marc" FUNCTION
% 'THIS FUNCTION IS CALLED BY THE "E_N_to_Lat", "E_N_to_Long" and "E_N_to_C" FUNCTIONS
% 'THIS FUNCTION IS ALSO USED ON IT'S OWN IN THE  "Projection and Transformation Calculations.xls" SPREADSHEET
% 
% 'First PHI value (PHI1)
%     PHI1 = ((North - n0) / afo) + PHI0
%     
% 'Calculate M
%     M = Marc(bfo, n, PHI0, PHI1)
%     
% 'Calculate new PHI value (PHI2)
%     PHI2 = ((North - n0 - M) / afo) + PHI1
%     
% 'Iterate to get final value for InitialLat
%     Do While Abs(North - n0 - M) > 0.00001
%         PHI2 = ((North - n0 - M) / afo) + PHI1
%         M = Marc(bfo, n, PHI0, PHI2)
%         PHI1 = PHI2
%     Loop
%     
%     InitialLat = PHI2
%     
% End Function