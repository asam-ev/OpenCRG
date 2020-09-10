function [enh dat] = map_global2plocal(llh, dat)
% MAP_GLOBAL2PLOCAL Forward projection: global to projected local.
%   [ENH DAT] = MAP_GLOBAL2PLOCAL(LLH, DAT) converts points from
%   global geodetic coordinates to local map coordinates by transformation from
%   a global to a local ellipsoid and forward projection on a local ellipsoid.
%
%   Inputs:
%   LLH     (n, 3) array of points in WGS 84
%   DAT     struct array with
%       .lell   ELLI struct of local geodetic datum
%       .gell   ELLI struct of global geodetic datum
%       .tran   TRAN struct of datum transformation
%       .proj   PROJ struct of map projection
%
%   Outputs:
%   ENH     (n, 3) array of points in map coordinate system
%   DAT     struct array with
%       .lell   ELLI struct of local geodetic datum
%       .gell   ELLI struct of global geodetic datum
%       .tran   TRAN struct of datum transformation
%       .proj   PROJ struct of map projection
%
%   Examples:
%   enh = map_global2plocal(llh, dat)
%       Converts points from global geodetic coordinates to local map coordinates.
%
%   See also MAP_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             map_global2plocal.m 
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

%% check and complement inputs

% DAT
if nargin < 2, dat = []; end

dat = map_check(dat);

gell = dat.gell;
lell = dat.lell;
tran = dat.tran;
proj = dat.proj;

% LLH
llh_globl = llh;

%% process

if isequal(gell, lell) && strcmp(tran.nm, 'NOP')
    llh_local = llh_globl;
else
    [xyz_globl gell] = map_geod2ecef(llh_globl, gell);
    [xyz_local tran] = map_ecef2ecef(xyz_globl, tran, 'F');
    [llh_local lell] = map_ecef2geod(xyz_local, lell);
end

[enh_local lell proj] = map_geod2pmap_tm(llh_local, lell, proj);

%% prepare outputs

enh = enh_local;

dat = struct;
dat.gell = gell;
dat.lell = lell;
dat.tran = tran;
dat.proj = proj;

end