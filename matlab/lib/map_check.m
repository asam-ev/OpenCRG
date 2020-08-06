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

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             map_check.m 
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
