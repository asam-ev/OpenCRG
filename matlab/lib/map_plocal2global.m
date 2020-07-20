function [llh dat] = map_plocal2global(enh, dat)
% MAP_LOCAL2GLOBL MAP backward projection: projected local to global.
%   [LLH DAT] = MAP_LOCAL2GLOBL(ENH, DAT) converts points from
%   local PMAP to global GEOD system by backward projection on local
%   ellipsoid and datum transformation from local to global ellipsoid.
%
%   Inputs:
%   ENH     (n, 3) array of points in PMAP system
%   DAT     opt struct array with
%       .lell   ELLI struct of local geodetic datum
%       .gell   ELLI struct of global geodetic datum
%       .tran   TRAN struct of datum transformation
%       .proj   PROJ struct of map projection
%
%   Outputs:
%   LLH     (n, 3) array of points in WGS84 GEOD system
%   DAT     struct array with
%       .lell   ELLI struct of local geodetic datum
%       .gell   ELLI struct of global geodetic datum
%       .tran   TRAN struct of datum transformation
%       .proj   PROJ struct of map projection
%
%   Examples:
%   llh = map_plocal2global(enh, dat)
%       converts points from PMAP to GEOD system.
%
%   See also MAP_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             map_plocal2global.m 
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

% DAT
if nargin < 2, dat = []; end

dat = map_check(dat);

gell = dat.gell;
lell = dat.lell;
tran = dat.tran;
proj = dat.proj;

%ENH
enh_local = enh;

%% process

[llh_local lell proj] = map_pmap2geod_tm(enh_local, lell, proj);

if isequal(gell, lell) && strcmp(tran.nm, 'NOP')
    llh_globl = llh_local;
else
    [xyz_local lell] = map_geod2ecef(llh_local, lell);
    [xyz_globl tran] = map_ecef2ecef(xyz_local, tran, 'B');
    [llh_globl gell] = map_ecef2geod(xyz_globl, gell);
end

%% prepare outputs

llh = llh_globl;

dat = struct;
dat.gell = gell;
dat.lell = lell;
dat.tran = tran;
dat.proj = proj;

end