function [tran] = map_check_tran(tran)
% MAP_CHECK_TRAN MAP check and update TRAN struct.
%   [TRAN] = MAP_CHECK_TRAN(TRAN) checks and updates TRAN struct.
%%
%   Inputs:
%   TRAN    opt. transformation name or TRAN struct
%
%   Outputs:
%   TRAN    TRAN struct
%
%   Examples:
%   tran = map_check_tran(tran)
%       checks and updates TRAN struct.
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
%   $Id: map_check_tran.m 362 2015-11-06 07:19:39Z jorauh@EMEA.CORPDIR.NET $

%%

if nargin < 1, tran = []; end
if isempty(tran), tran = struct; end

nm = '';
if ischar(tran)
    nm = tran;
else
    if isfield(tran, 'nm'), nm = tran.nm; end
end

if isempty(nm)
    nm = 'NOP'; % default
else
    nm = upper(nm);
end

switch nm
    case 'NOP' % no transformation (default)
    case 'HL7' % 7 parameter linear Helmert transformation
    case 'HN7' % 7 parameter nonlin Helmert transformation
    case 'HS7' % 7 parameter simple Helmert transformation
    otherwise
        error('MAP:checkError', 'unknown transformation name %s', nm)
end

switch nm
    case {'HL7','HN7','HS7'}
        ds = 0; if isfield(tran, 'ds'), ds = tran.ds; end
        rx = 0; if isfield(tran, 'rx'), rx = tran.rx; end
        ry = 0; if isfield(tran, 'ry'), ry = tran.ry; end
        rz = 0; if isfield(tran, 'rz'), rz = tran.rz; end
        tx = 0; if isfield(tran, 'tx'), tx = tran.tx; end
        ty = 0; if isfield(tran, 'ty'), ty = tran.ty; end
        tz = 0; if isfield(tran, 'tz'), tz = tran.tz; end
end

%% compose output struct

tran = struct;

tran.nm = nm;

switch nm
    case {'HL7','HN7','HS7'}
        tran.ds = ds;
        tran.rx = rx;
        tran.ry = ry;
        tran.rz = rz;
        tran.tx = tx;
        tran.ty = ty;
        tran.tz = tz;
end

end