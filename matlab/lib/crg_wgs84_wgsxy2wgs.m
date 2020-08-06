function [wgs] = crg_wgs84_wgsxy2wgs(wgs1, wgs2, pxy1, pxy2, pxy, eps, tol, dmin)
%CRG_WGS84_WGSXY2WGS CRG transform point in xy to WGS84 using 2 references.
%   [WGS, DATA] = CRG_WGS84_WGSXY2WGS(WGS1,WGS2, PXY1,PXY2, PXY, EPS,TOL,DMIN)
%   transforms points given in xy system to WGS84 coordinates, using two
%   references defined by their WGS84 and their xy coordinates.
%
%   Inputs:
%   WGS1    (2) pair of latitude/longitude (north/east) of P1.
%   WGS2    (2) pair of latitude/longitude (north/east) of P2.
%   PXY1    (2) pair of xy coordinates of P1.
%   PXY2    (2) pair of xy coordinates of P2.
%   PXY     (np, 2) array of points in xy system
%   EPS     relative P1-P2 distance consistency requirement (default=1e-6)
%   TOL     absolute P1-P2 distance consistency requirement (default=1e-4)
%   DMIN    minimal P1-P2 distance requirement (default=1e-3)
%
%   Outputs:
%   WGS     (np, 2) array of latitude/longitude (north/east) wgs84
%           coordinate pairs (in degrees)
%
%   Examples:
%   [wgs] = crg_wgs84_wgsxy2wgs(wgs1, wgs2, pxy1, pxy2, pxy)
%   transforms pxy points to WGS84 coordinates
%
%   See also CRG_INTRO, CRG_WGS84_XY2WGS.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_wgs84_wgsxy2wgs.m 
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

%% check/complement optional arguments

if nargin < 8
    dmin = 1e-3;
end

if nargin < 7
    tol = 1e-4;
end

if nargin < 6
    eps = 1e-6;
end

%% evaluate P1->P2 distance and direction defined by WGS and XY

[wgd12, wgp12] = crg_wgs84_dist(wgs1, wgs2); % P1->P2 dist and direction in WGS84

xyd12 = sqrt((pxy2(2)-pxy1(2))^2 + (pxy2(1)-pxy1(1))^2); % P1->P2 dist in xy
xyp12 = atan2(pxy2(2)-pxy1(2), pxy2(1)-pxy1(1)); % P1->P2 direction in xy

if wgd12 < dmin
    error('CRG:wgs84Error', 'P1->P2 WGS distance too small =%d', wgd12)
end
if xyd12 < dmin
    error('CRG:wgs84Error', 'P1->P2 XY  distance too small =%d', xyd12)
end
if abs(wgd12-xyd12) > max(eps*(wgd12+xyd12)/2, tol)
    error('CRG:wgs84Error', 'inconsitent P1->P2 distance: WGS=%d XY=%d', wgd12, xyd12)
end

sc = wgd12/xyd12; % scale factor wgd/xyd

%% calculate WGS for all PXY

wgs = zeros(size(pxy));

for i = 1:size(pxy, 1)
    xypi = atan2(pxy(i,2)-pxy1(2), pxy(i,1)-pxy1(1)); % P1->pxy direction in xy
    wgpi = wgp12 - (xypi-xyp12); % P1->pxy direction in WGS84

    xydi = sqrt((pxy(i,1)-pxy1(1))^2 + (pxy(i,2)-pxy1(2))^2); % P1->pxy distance

    wgs(i,:) = crg_wgs84_invdist(wgs1, wgpi, sc*xydi);
end

end
