function [llh ell pro] = map_pmap2geod_tm(enh, ell, pro)
% MAP_PMAP2GEOD_TM MAP backward projection: transverse mercator.
%   [LLH ELL PRO] = MAP_PMAP2GEOD_TM(ENH, ELL, PRO) converts points from
%   PMAP to GEOD system using backward transverse mercator projection.
%
%   Inputs:
%   ENH     (n, 3) array of points in PMAP system
%   ELL     ELLI struct array
%   PRO     PROJ struct array
%
%   Outputs:
%   LLH     (n, 3) array of points in GEOD system
%   ELL     ELLI struct array
%   PRO     PROJ struct array
%
%   Examples:
%   llh = map_pmap2geod_tm(enh, ell, pro)
%       converts points from PMAP to GEOD system.
%
%   See also MAP_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             map_pmap2geod_tm.m 
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

e = enh(:,1)';
n = enh(:,2)';

a = ell.a;
b = ell.b;

f0 = pro.f0;
l0 = pro.l0;
e0 = pro.e0;

%%

phid = map_ptm_north2initiallat(n, ell, pro);

%%

sphid2 = sin(phid).^2;
tphid = tan(phid);
tphid2 = tphid.^2;

e2 = (a^2-b^2)/a^2;
nurho = (1 - e2 * sphid2)./(1 - e2);

etnu = (e-e0).*sqrt(1-e2*sphid2)/(a*f0);
etnu2 = etnu.^2;

%%

phi = phid - etnu2.*tphid .*nurho .* (1/2 ...
    - etnu2.*((4+nurho+tphid2.*(12-9*nurho))/24 ...
    - etnu2.*(61+tphid2.*(90+45*tphid2))/720));

lam = l0 + etnu .* sec(phid) .* (1 ...
    - etnu2.*((nurho + 2*tphid2)/6 ...
    - etnu2.*((5+tphid2.*(28+24*tphid2 ))/120 ...
    - etnu2.*(61+tphid2.*(662+tphid2.*(1320+tphid2*720)))/5040)));

lam = angle(exp(1i*lam));

%%

llh = [phi' lam' enh(:,3)];
    
end
% All above formulas are mainly based on the Ordnance Survey publication:
% http://www.ordnancesurvey.co.uk/oswebsite/gps/ ...
%   information/index.html (Overrview)
%   docs/A_Guide_to_Coordinate_Systems_in_Great_Britain.pdf (User Guide)
%   docs/ProjectionandTransformationCalculations.xls (VB implementation)
% last accessed 2012-08-30
%
% Function E_N_to_Lat(East, North, a, b, e0, n0, f0, PHI0, LAM0)
% 'Un-project Transverse Mercator eastings and northings back to latitude.
% 'Input: - _
%  eastings (East) and northings (North) in meters; _
%  ellipsoid axis dimensions (a & b) in meters; _
%  eastings (e0) and northings (n0) of false origin in meters; _
%  central meridian scale factor (f0) and _
%  latitude (PHI0) and longitude (LAM0) of false origin in decimal degrees.
% 
% 'REQUIRES THE "Marc" AND "InitialLat" FUNCTIONS
% 
% 'Convert angle measures to radians
%     Pi = 3.14159265358979
%     RadPHI0 = PHI0 * (Pi / 180)
%     RadLAM0 = LAM0 * (Pi / 180)
% 
% 'Compute af0, bf0, e squared (e2), n and Et
%     af0 = a * f0
%     bf0 = b * f0
%     e2 = ((af0 ^ 2) - (bf0 ^ 2)) / (af0 ^ 2)
%     n = (af0 - bf0) / (af0 + bf0)
%     Et = East - e0
% 
% 'Compute initial value for latitude (PHI) in radians
%     PHId = InitialLat(North, n0, af0, RadPHI0, n, bf0)
%     
% 'Compute nu, rho and eta2 using value for PHId
%     nu = af0 / (Sqr(1 - (e2 * ((Sin(PHId)) ^ 2))))
%     rho = (nu * (1 - e2)) / (1 - (e2 * (Sin(PHId)) ^ 2))
%     eta2 = (nu / rho) - 1
%     
% 'Compute Latitude
%     VII = (Tan(PHId)) / (2 * rho * nu)
%     VIII = ((Tan(PHId)) / (24 * rho * (nu ^ 3))) * (5 + (3 * ((Tan(PHId)) ^ 2)) + eta2 - (9 * eta2 * ((Tan(PHId)) ^ 2)))
%     IX = ((Tan(PHId)) / (720 * rho * (nu ^ 5))) * (61 + (90 * ((Tan(PHId)) ^ 2)) + (45 * ((Tan(PHId)) ^ 4)))
%     
%     E_N_to_Lat = (180 / Pi) * (PHId - ((Et ^ 2) * VII) + ((Et ^ 4) * VIII) - ((Et ^ 6) * IX))
% 
% End Function
% 
% Function E_N_to_Long(East, North, a, b, e0, n0, f0, PHI0, LAM0)
% 'Un-project Transverse Mercator eastings and northings back to longitude.
% 'Input: - _
%  eastings (East) and northings (North) in meters; _
%  ellipsoid axis dimensions (a & b) in meters; _
%  eastings (e0) and northings (n0) of false origin in meters; _
%  central meridian scale factor (f0) and _
%  latitude (PHI0) and longitude (LAM0) of false origin in decimal degrees.
% 
% 'REQUIRES THE "Marc" AND "InitialLat" FUNCTIONS
% 
% 'Convert angle measures to radians
%     Pi = 3.14159265358979
%     RadPHI0 = PHI0 * (Pi / 180)
%     RadLAM0 = LAM0 * (Pi / 180)
% 
% 'Compute af0, bf0, e squared (e2), n and Et
%     af0 = a * f0
%     bf0 = b * f0
%     e2 = ((af0 ^ 2) - (bf0 ^ 2)) / (af0 ^ 2)
%     n = (af0 - bf0) / (af0 + bf0)
%     Et = East - e0
% 
% 'Compute initial value for latitude (PHI) in radians
%     PHId = InitialLat(North, n0, af0, RadPHI0, n, bf0)
%     
% 'Compute nu, rho and eta2 using value for PHId
%     nu = af0 / (Sqr(1 - (e2 * ((Sin(PHId)) ^ 2))))
%     rho = (nu * (1 - e2)) / (1 - (e2 * (Sin(PHId)) ^ 2))
%     eta2 = (nu / rho) - 1
%     
% 'Compute Longitude
%     X = ((Cos(PHId)) ^ -1) / nu
%     XI = (((Cos(PHId)) ^ -1) / (6 * (nu ^ 3))) * ((nu / rho) + (2 * ((Tan(PHId)) ^ 2)))
%     XII = (((Cos(PHId)) ^ -1) / (120 * (nu ^ 5))) * (5 + (28 * ((Tan(PHId)) ^ 2)) + (24 * ((Tan(PHId)) ^ 4)))
%     XIIA = (((Cos(PHId)) ^ -1) / (5040 * (nu ^ 7))) * (61 + (662 * ((Tan(PHId)) ^ 2)) + (1320 * ((Tan(PHId)) ^ 4)) + (720 * ((Tan(PHId)) ^ 6)))
% 
%     E_N_to_Long = (180 / Pi) * (RadLAM0 + (Et * X) - ((Et ^ 3) * XI) + ((Et ^ 5) * XII) - ((Et ^ 7) * XIIA))
% 
% End Function