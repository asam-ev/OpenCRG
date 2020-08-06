function [marc ell pro] = map_ptm_phi2marc(phi, ell, pro)
% MAP_PTM_ENH2LLH MAP transverse mercator utility function.
%   [MARC ELL PRO] = MAP_PTM_PHI2MARC(PHI, ELL, PRO) computes the 
%   meridional arc needed for transverse mercator projections.
%
%   Inputs:
%   PHI     (n) vector of latitudes
%   ELL     opt. ELLI struct array
%   PRO     opt. PROJ struct array
%
%   Outputs:
%   MARC    (n) vector of meridional arc values
%   ELL     ELLI struct array
%   PRO     PROJ struct array
%
%   Examples:
%   marc = map_ptm_phi2marc(phi, ell, pro)
%       calulates meridional arc values.
%
%   See also MAP_INTRO, MAP_GEOD2PMAP_TM, MAP_PTM_NORTH2INITIALLAT.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             map_ptm_phi2marc.m 
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

p0 = pro.p0;
f0 = pro.f0;

a = ell.a;
b = ell.b;
n = (a-b)/(a+b);

%%

phid = phi-p0; % delta
phis = phi+p0; % sum

%%

marc = b*f0/24*(6*(4+n*(4+5*n*(1+n))).*phid ...
     -  3*n*(24+n*(24+21*n)).*sin(phid).*cos(phis) ...
     +  45*n^2*(1+n).*sin(2*phid).*cos(2*phis) ...
     -  35*n^3.*sin(3*phid).*cos(3*phis));

end
% All above formulas are mainly based on the Ordnance Survey publication:
% http://www.ordnancesurvey.co.uk/oswebsite/gps/ ...
%   information/index.html (Overrview)
%   docs/A_Guide_to_Coordinate_Systems_in_Great_Britain.pdf (User Guide)
%   docs/ProjectionandTransformationCalculations.xls (VB implementation)
% last accessed 2012-08-30
%
% Function Marc(bf0, n, PHI0, PHI)
% 'Compute meridional arc.
% 'Input: - _
%  ellipsoid semi major axis multiplied by central meridian scale factor (bf0) in meters; _
%  n (computed from a, b and f0); _
%  lat of false origin (PHI0) and initial or final latitude of point (PHI) IN RADIANS.
% 
% 'THIS FUNCTION IS CALLED BY THE - _
%  "Lat_Long_to_North" and "InitialLat" FUNCTIONS
% 'THIS FUNCTION IS ALSO USED ON IT'S OWN IN THE "Projection and Transformation Calculations.xls" SPREADSHEET
% 
%     Marc = bf0 * (((1 + n + ((5 / 4) * (n ^ 2)) + ((5 / 4) * (n ^ 3))) * (PHI - PHI0)) _
%     - (((3 * n) + (3 * (n ^ 2)) + ((21 / 8) * (n ^ 3))) * (Sin(PHI - PHI0)) * (Cos(PHI + PHI0))) _
%     + ((((15 / 8) * (n ^ 2)) + ((15 / 8) * (n ^ 3))) * (Sin(2 * (PHI - PHI0))) * (Cos(2 * (PHI + PHI0)))) _
%     - (((35 / 24) * (n ^ 3)) * (Sin(3 * (PHI - PHI0))) * (Cos(3 * (PHI + PHI0)))))
% 
% End Function