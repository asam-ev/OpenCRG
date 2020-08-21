function [data, ierr] = crg_check_curvature(data, ierr)
% CRG_CHECK_CURVATURE Check OpenCRG curvature data.
%   [DATA] = CRG_CHECK_CURVATURE(DATA) checks reference line curvature in `data`
%   globally and locally. The global curvature check fails if two or more
%   lateral cuts intersect inside the road limits. In this case, the local
%   curvature check still succeeds, if such an intersection falls into a region
%   of NaN values.

%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO.
%
%   Outputs:
%   DATA    input DATA with checked curvature data.
%
%   Examples:
%   data = crg_check_curvature(data)
%       Checks CRG reference line curvature.
%
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_check_curvature.m 
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

%% some local variables

crgeps = data.opts.ceps;
icerr = 0;

%% check for rc field (reference line curvature)

if ~isfield(data, 'rc')
    error('CRG:checkError', 'DATA.rc missing')
end

%% global curvature check


cmin = min(data.rc);
cmax = max(data.rc);
if abs(cmax) > crgeps
    if 1/cmax <= data.head.vmax && 1/cmax >= data.head.vmin
        warning('CRG:checkWarning', 'global curvature check failed - center of max. reference line curvature=%d inside road limits', cmax)
        icerr = icerr + 1;
    end
end
if abs(cmin) > crgeps
    if 1/cmin <= data.head.vmax && 1/cmin >= data.head.vmin
        warning('CRG:checkWarning', 'global curvature check failed - center of min. reference line curvature=%d inside road limits', cmin)
        icerr = icerr + 1;
    end
end

ierr = ierr + icerr;


%% local curvature check

if isfield(data.opts, 'wcvl') && data.opts.wcvl > 0 && icerr > 0
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
        ierr = ierr - icerr;
    else
        warning('local curvature check failed - critical curvature areas in z-value regions')
        ierr = ierr + 1;
    end
    
    % remove temp ok
    data = rmfield(data, 'ok');
end

end
