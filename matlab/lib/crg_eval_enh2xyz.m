function [pxyz, data] = crg_eval_enh2xyz(data, penh)
%CRG_EVAL_ENH2XYZ CRG tranform point in enh to xyz.
%   [PXYZ, DATA] = CRG_EVAL_ENH2XYZ(DATA, PENH) transforms points given in
%   enh coordinate system to xyz coordinate system.
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

%   Copyright 2013-2014 OpenCRG - Daimler AG - Jochen Rauh
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
%   $Id: crg_eval_enh2xyz.m 343 2014-07-24 22:11:12Z jorauh $

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
