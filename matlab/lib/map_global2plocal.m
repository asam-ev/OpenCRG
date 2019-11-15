function [enh dat] = map_global2plocal(llh, dat)
% MAP_GLOBAL2PLOCAL MAP forward projection: global to projected local.
%   [ENH DAT] = MAP_GLOBAL2PLOCAL(LLH, DAT) converts points from
%   global GEOD to local PMAP system by datum transformation from global to
%   local ellipsoid and forward projection on local ellipsoid.
%
%   Inputs:
%   LLH     (n, 3) array of points in WGS84 GEOD system
%   DAT     struct array with
%       .lell   ELLI struct of local geodetic datum
%       .gell   ELLI struct of global geodetic datum
%       .tran   TRAN struct of datum transformation
%       .proj   PROJ struct of map projection
%
%   Outputs:
%   ENH     (n, 3) array of points in PMAP system
%   DAT     struct array with
%       .lell   ELLI struct of local geodetic datum
%       .gell   ELLI struct of global geodetic datum
%       .tran   TRAN struct of datum transformation
%       .proj   PROJ struct of map projection
%
%   Examples:
%   enh = map_global2plocal(llh, dat)
%       converts points from PMAP to GEOD system.
%
%   See also MAP_INTRO.

%   Copyright 2012-2015 OpenCRG - Daimler AG - Jochen Rauh
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
%   $Id: map_global2plocal.m 362 2015-11-06 07:19:39Z jorauh@EMEA.CORPDIR.NET $

%% check/complement inputs

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