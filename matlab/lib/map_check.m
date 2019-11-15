function [dat] = map_check(dat)
% MAP_CHECK MAP check and update DAT struct.
%   [DAT] = MAP_CHECK(DAT) checks and updates DAT struct as used in
%   MAP_GLOBAL2PLOCAL and MAP_PLOCAL2GLOBAL.
%
%   Inputs:
%   DAT     simple projection identifier or struct array with
%       .lell   ELLI struct of local geodetic datum
%       .gell   ELLI struct of global geodetic datum
%       .tran   TRAN struct of datum transformation
%       .proj   PROJ struct of map projection
%
%   Outputs:
%   DAT     struct array with
%       .lell   ELLI struct of local geodetic datum
%       .gell   ELLI struct of global geodetic datum
%       .tran   TRAN struct of datum transformation
%       .proj   PROJ struct of map projection
%
%   Examples:
%   dat = map_check(dat)
%       checks and updates DAT struct.
%
%   See also MAP_INTRO, MAP_GLOBAL2PLOCAL, MAP_PLOCAL2GLOBAL.

%   Copyright 2013-2015 OpenCRG - Daimler AG - Jochen Rauh
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
%   $Id: map_check.m 362 2015-11-06 07:19:39Z jorauh@EMEA.CORPDIR.NET $

%% check/complement inputs

% DAT
if nargin < 1, dat = []; end

if ischar(dat)
    gell = [];
    lell = [];
    tran = [];
    proj = dat;
else
    if isfield(dat, 'gell'), gell = dat.gell; else, gell = []; end
    if isfield(dat, 'lell'), lell = dat.lell; else, lell = []; end
    if isfield(dat, 'tran'), tran = dat.tran; else, tran = []; end
    if isfield(dat, 'proj'), proj = dat.proj; else, proj = []; end
end

%% process individual check calls

gell = map_check_elli(gell);
lell = map_check_elli(lell);
tran = map_check_tran(tran);
proj = map_check_proj(proj);

%% prepare outputs

dat = struct;
dat.gell = gell;
dat.lell = lell;
dat.tran = tran;
dat.proj = proj;

end
