function [penh, data] = crg_eval_xyz2enh(data, pxyz)
%CRG_EVAL_XYZ2ENH CRG tranform point in xyz to enh.
%   [PENH, DATA] = CRG_EVAL_XYZ2ENH(DATA, PXYZ) transforms points given in
%   xyz coordinate system to enh coordinate system.
%
%   inputs:
%       DATA    struct array as defined in CRG_INTRO.
%       PXYZ    (np, 3) array of points in xyz system (CRG local)
%
%   outputs:
%       PENH    (np, 3) array of points in enh system (CRG global)
%       DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   [penh, data] = crg_eval_xyz2enh(data, pxyz) transforms pxyz points
%   given in local CRG coordinate system to penh points given in CRG
%   global coordinate system.
%
%   See also CRG_INTRO, MAP_INTRO, CRG_EVAL_ENH2XYZ.

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
%   $Id: crg_eval_xyz2enh.m 343 2014-07-24 22:11:12Z jorauh $

%% check if already succesfully checked

if ~isfield(data, 'ok')
    data = crg_check(data);
    if ~isfield(data, 'ok')
        error('CRG:checkError', 'check of DATA was not completely successful')
    end
end

%% pre-allocate output

np = size(pxyz, 1);
penh = zeros(np, 3);

%% simplify data access

xbeg = data.head.xbeg;
ybeg = data.head.ybeg;

ps = sin(data.head.poff);
pc = cos(data.head.poff);

%% perform transformation local -> global

% rotate around (xbeg, ybeg)
dx = pxyz(:, 1) - xbeg;
dy = pxyz(:, 2) - ybeg;

penh(:, 1) = xbeg + dx*pc - dy*ps;
penh(:, 2) = ybeg + dx*ps + dy*pc;
penh(:, 3) = pxyz(:, 3);

% translate
penh(:, 1) = penh(:, 1) + data.head.xoff;
penh(:, 2) = penh(:, 2) + data.head.yoff;
penh(:, 3) = penh(:, 3) + data.head.zoff;

end
