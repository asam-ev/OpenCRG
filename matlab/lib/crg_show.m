function [data] = crg_show(data, iu, iv)
% CRG_SHOW CRG road visualizer.
%   DATA = CRG_SHOW_ELGRID_SURFACE(DATA, IU, IV) visualizes CRG road info.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO
%   IU      U index for plot selection (default: full CRG)
%           IU(1): longitudinal start index
%           IU(2): longitudinal end index
%   IV      V index for plot selection (default: full CRG)
%           IV(1): lateral start index
%           IV(2): lateral end index
%   Outputs:
%   DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   data = crg_show(data)
%       shows full CRG info.
%   data = crg_show(data, [1000 2000], [10 20])
%       shows partial CRG info.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_show.m 
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

%% evaluate DATA.z size

[nu nv] = size(data.z);

%% check/complement optional arguments

if nargin < 2
    iu =  [1 nu];
end
if iu(1)<1 || iu(1) >= iu(2) || iu(2) > nu
    error('CRG:showError', 'illegal IU index values iu=[%d %d] with nu=%d', iu(1), iu(2), nu);
end

if nargin < 3
    iv =  [1 nv];
end
if iv(1)<1 || iv(1) >= iv(2) || iv(2) > nv
    error('CRG:showError', 'illegal IV index values iv=[%d %d] with nv=%d', iv(1), iv(2), nv);
end

%% generate only useful figures

if isfield(data, 'rx')
    data = crg_show_refline_map(data, iu);
end

if isfield(data, 'rz') || isfield(data, 'b')
    data = crg_show_refline_elevation(data, iu);
end

data = crg_show_elgrid_cuts_and_limits(data, iu, iv);

nuiu = iu(2) - iu(1) + 1;

if isfield(data, 'rz') || isfield(data, 'b')
    if nuiu > 3000
        data = crg_show_elgrid_surface(data, ...
            [iu(1)                   iu(1)+1000             ], [1 nv]); % start
        data = crg_show_elgrid_surface(data, ...
            [iu(1)+round(nuiu/2)-500 iu(1)+round(nuiu/2)+500], [1 nv]); % mid
        data = crg_show_elgrid_surface(data, ...
            [iu(2)-1000              iu(2)                  ], [1 nv]); % end
    else
        data = crg_show_elgrid_surface(data, iu, iv);
    end
end

if nuiu > 3000
    data = crg_show_road_surface(data, ...
        [iu(1)                   iu(1)+1000             ], [1 nv]); % start
    data = crg_show_road_surface(data, ...
        [iu(1)+round(nuiu/2)-500 iu(1)+round(nuiu/2)+500], [1 nv]); % mid
    data = crg_show_road_surface(data, ...
        [iu(2)-1000              iu(2)                  ], [1 nv]); % end
else
    data = crg_show_road_surface(data, iu, iv);
end

data = crg_show_info(data);

end
