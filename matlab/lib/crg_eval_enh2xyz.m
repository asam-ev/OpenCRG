function [pxyz, data] = crg_eval_enh2xyz(data, penh)
%CRG_EVAL_ENH2XYZ Transform points in enh to xyz.
%   [PXYZ, DATA] = CRG_EVAL_ENH2XYZ(DATA, PENH) transforms points given in
%   enh coordinates to xyz coordinates.
%
%   inputs:
%       DATA    struct array as defined in CRG_INTRO.
%       PENH    (np, 3) array of points in enh system (CRG global)
%
%   outputs:
%       PXYZ    (np, 3) array of points in xyz system (CRG local)
%       DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   [pxyz, data] = crg_eval_enh2xyz(data, penh) transforms penh points
%   given in global CRG coordinate system to pxyz points given in CRG
%   local coordinate system.
%
%   See also CRG_INTRO, MAP_INTRO, CRG_EVAL_XYZ2ENH.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_eval_enh2xyz.m 
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

%% check if already succesfully checked

if ~isfield(data, 'ok')
    data = crg_check(data);
    if ~isfield(data, 'ok')
        error('CRG:checkError', 'check of DATA was not completely successful')
    end
end

%% pre-allocate output

np = size(penh, 1);
pxyz = zeros(np, 3);

%% simplify data access

xbeg = data.head.xbeg;
ybeg = data.head.ybeg;

ps = sin(data.head.poff);
pc = cos(data.head.poff);

%% perform transformation global -> local

% translate
pxyz(:, 1) = penh(:, 1) - data.head.xoff;
pxyz(:, 2) = penh(:, 2) - data.head.yoff;
pxyz(:, 3) = penh(:, 3) - data.head.zoff;

% rotate around (xbeg, ybeg)
dx = pxyz(:, 1) - xbeg;
dy = pxyz(:, 2) - ybeg;

pxyz(:, 1) = xbeg + dx*pc + dy*ps;
pxyz(:, 2) = ybeg - dx*ps + dy*pc;

end
