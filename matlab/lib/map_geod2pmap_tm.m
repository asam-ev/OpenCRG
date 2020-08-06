function [enh ell pro] = map_geod2pmap_tm(llh, ell, pro)
% MAP_GEOD2PMAP_TM MAP forward projection: transverse mercator.
%   [ENH ELL PRO] = MAP_GEOD2PMAP_TM(LLH, ELL, PRO) converts points from
%   GEOD to PMAP system using forward transverse mercator projection.
%
%   Inputs:
%   LLH     (n, 3) array of points in GEOD system
%   ELL     opt. ELLI struct array
%   PRO     opt. PROJ struct array
%
%   Outputs:
%   ENH     (n, 3) array of points in PMAP system
%   ELL     ELLI struct array
%   PRO     PROJ struct array
%
%   Examples:
%   enh = map_geod2pmap_tm(llh, ell, pro)
%       converts points from GEOD to PMAP system.
%
%   See also MAP_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             map_geod2pmap_tm.m 
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

phi = llh(:,1)';
lam = llh(:,2)';

a = ell.a;
b = ell.b;
e2 = 1-b^2/a^2;

f0 = pro.f0;
l0 = pro.l0;
e0 = pro.e0;
n0 = pro.n0;

%%

cphi = cos(phi);
sphi = sin(phi);
cphi2 = cphi.^2;
sphi2 = sphi.^2;
cphi4 = cphi2.^2;
sphi4 = sphi2.^2;
scphi2 = sphi2.*cphi2;

nu = a*f0./sqrt(1-e2*sphi2);
nr = (1-e2*sphi2)/(1-e2);
eta2 = nr-1;

lamd = lam-l0;
lamd = angle(exp(1i*lamd));
lamd2 = lamd.^2;
  
%%

e = e0 + lamd.*nu.*cphi.*(1 ...
    + lamd2.*((cphi2.*nr-sphi2)/6  ...
    + lamd2.*((5+14*eta2).*cphi4-(18+58*eta2).*scphi2+sphi4 )/120));

n = n0 + map_ptm_phi2marc(phi, ell, pro) + lamd2.*nu.*sphi.*cphi.*(1/2 ...
    + lamd2.*(((5+ 9.*eta2).*cphi2-sphi2)/24 ...
    + lamd2.*(61*cphi4-58*scphi2+sphi4)/720));

%%

enh = [e' n' llh(:,3)];

end
% All above formulas are mainly based on the Ordnance Survey publication:
% http://www.ordnancesurvey.co.uk/oswebsite/gps/ ...
%   information/index.html (Overrview)
%   docs/A_Guide_to_Coordinate_Systems_in_Great_Britain.pdf (User Guide)
%   docs/ProjectionandTransformationCalculations.xls (VB implementation)
% last accessed 2012-08-30
%
% Function Lat_Long_to_East(PHI, LAM, a, b, e0, f0, PHI0, LAM0)
% 'Project Latitude and longitude to Transverse Mercator eastings.
% 'Input: - _
%  Latitude (PHI) and Longitude (LAM) in decimal degrees; _
%  ellipsoid axis dimensions (a & b) in meters; _
%  eastings of false origin (e0) in meters; _
%  central meridian scale factor (f0); _
%  latitude (PHI0) and longitude (LAM0) of false origin in decimal degrees.
% 
% 'Convert angle measures to radians
%     Pi = 3.14159265358979
%     RadPHI = PHI * (Pi / 180)
%     RadLAM = LAM * (Pi / 180)
%     RadPHI0 = PHI0 * (Pi / 180)
%     RadLAM0 = LAM0 * (Pi / 180)
% 
%     af0 = a * f0
%     bf0 = b * f0
%     e2 = ((af0 ^ 2) - (bf0 ^ 2)) / (af0 ^ 2)
%     n = (af0 - bf0) / (af0 + bf0)
%     nu = af0 / (Sqr(1 - (e2 * ((Sin(RadPHI)) ^ 2))))
%     rho = (nu * (1 - e2)) / (1 - (e2 * (Sin(RadPHI)) ^ 2))
%     eta2 = (nu / rho) - 1
%     p = RadLAM - RadLAM0
%     
%     IV = nu * (Cos(RadPHI))
%     V = (nu / 6) * ((Cos(RadPHI)) ^ 3) * ((nu / rho) - ((Tan(RadPHI) ^ 2)))
%     VI = (nu / 120) * ((Cos(RadPHI)) ^ 5) * (5 - (18 * ((Tan(RadPHI)) ^ 2)) + ((Tan(RadPHI)) ^ 4) + (14 * eta2) - (58 * ((Tan(RadPHI)) ^ 2) * eta2))
%     
%     Lat_Long_to_East = e0 + (p * IV) + ((p ^ 3) * V) + ((p ^ 5) * VI)
%     
% End Function
% 
% Function Lat_Long_to_North(PHI, LAM, a, b, e0, n0, f0, PHI0, LAM0)
% 'Project Latitude and longitude to Transverse Mercator northings
% 'Input: - _
%  Latitude (PHI) and Longitude (LAM) in decimal degrees; _
%  ellipsoid axis dimensions (a & b) in meters; _
%  eastings (e0) and northings (n0) of false origin in meters; _
%  central meridian scale factor (f0); _
%  latitude (PHI0) and longitude (LAM0) of false origin in decimal degrees.
% 
% 'REQUIRES THE "Marc" FUNCTION
% 
% 'Convert angle measures to radians
%     Pi = 3.14159265358979
%     RadPHI = PHI * (Pi / 180)
%     RadLAM = LAM * (Pi / 180)
%     RadPHI0 = PHI0 * (Pi / 180)
%     RadLAM0 = LAM0 * (Pi / 180)
%     
%     af0 = a * f0
%     bf0 = b * f0
%     e2 = ((af0 ^ 2) - (bf0 ^ 2)) / (af0 ^ 2)
%     n = (af0 - bf0) / (af0 + bf0)
%     nu = af0 / (Sqr(1 - (e2 * ((Sin(RadPHI)) ^ 2))))
%     rho = (nu * (1 - e2)) / (1 - (e2 * (Sin(RadPHI)) ^ 2))
%     eta2 = (nu / rho) - 1
%     p = RadLAM - RadLAM0
%     M = Marc(bf0, n, RadPHI0, RadPHI)
%     
%     I = M + n0
%     II = (nu / 2) * (Sin(RadPHI)) * (Cos(RadPHI))
%     III = ((nu / 24) * (Sin(RadPHI)) * ((Cos(RadPHI)) ^ 3)) * (5 - ((Tan(RadPHI)) ^ 2) + (9 * eta2))
%     IIIA = ((nu / 720) * (Sin(RadPHI)) * ((Cos(RadPHI)) ^ 5)) * (61 - (58 * ((Tan(RadPHI)) ^ 2)) + ((Tan(RadPHI)) ^ 4))
%     
%     Lat_Long_to_North = I + ((p ^ 2) * II) + ((p ^ 4) * III) + ((p ^ 6) * IIIA)
%    
% End Function
