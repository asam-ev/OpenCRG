function [data, ierr] = crg_check_curvature(data, ierr)
% CRG_CHECK_CURVATURE CRG check CRG curvature data.
%   [DATA] = CRG_CHECK_CURVATURE(DATA) checks CRG reference line curvature
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO.
%
%   Outputs:
%   DATA    is a checked, purified, and eventually completed version of
%           the function input argument DATA
%
%   Examples:
%   data = crg_check_curvature(data) checks CRG reference line curvature.
%
%   See also CRG_INTRO.

%   Copyright 2005-2015 OpenCRG - ASAM e.V.
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
%   $Id: crg_check_curvature.m 1 2020-04-30 15:30:00Z rruhdorfer $

%% some local variables

crgeps = data.opts.ceps;

%% check for rc field (reference line curvature)

if ~isfield(data, 'rc')
    error('CRG:checkError', 'DATA.rc missing')
end

%% global curvature check

if isfield(data.opts, 'wcvg') && data.opts.wcvg ~= 0
    cmin = min(data.rc);
    cmax = max(data.rc);
    if abs(cmax) > crgeps
        if 1/cmax <= data.head.vmax && 1/cmax >= data.head.vmin
            warning('CRG:checkWarning', 'global curvature check failed - center of max. reference line curvature=%d inside road limits', cmax)
            ierr = ierr + 1;
        end
    end
    if abs(cmin) > crgeps
        if 1/cmin <= data.head.vmax && 1/cmin >= data.head.vmin
            warning('CRG:checkWarning', 'global curvature check failed - center of min. reference line curvature=%d inside road limits', cmin)
            ierr = ierr + 1;
        end
    end
end

%% local curvature check

if isfield(data.opts, 'wcvl') && data.opts.wcvl > 0
    % set temp ok
    data.ok = 0;
    
    % reference line points
    ur=data.head.ubeg:data.head.uinc:data.head.uend;

    % radii right / left
    rright = 1./data.rc(data.rc < 0);
    uright = ur(data.rc < 0);
    rleft = 1./data.rc(data.rc >= 0);
    uleft = ur(data.rc >= 0);

    % radii inside grid
    rright = rright(rright > data.head.vmin);
    uright = uright(rright > data.head.vmin);
    rleft = rleft(rleft < data.head.vmax);
    uleft = uleft(rleft < data.head.vmax);

    % get z at border
    zright = crg_eval_uv2z(data,[uright',rright']);
    zleft  = crg_eval_uv2z(data,[uleft',rleft']);

    % check if z isnan
    if sum(isnan(zright)) + sum(isnan(zleft)) == 0 
        warning('local curvature check succeeded - critical curvature areas in NaN regions')
        % ierr = ierr + 1;
    else
        warning('local curvature check failed - critical curvature areas in z-value regions') % //TODO: warning or error?
        ierr = ierr + 1;
    end
    
    % remove temp ok
    data = rmfield(data, 'ok');
end

end
