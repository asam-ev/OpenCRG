function [data] = crg_plot_road_uvz_map(data, iu, iv)
% CRG_PLOT_ROAD_UVZ_MAP CRG road UVZ map.
%   DATA = CRG_PLOT_ROAD_UVZ_MAP(DATA, IU, IV) plots CRG road
%   UVZ map in current axes object.
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
%   data = crg_plot_road_uvz_map(data)
%       plots full CRG info.
%   data = crg_plot_road_uvz_map(data, [1000 2000], [10 30])
%       plots partial CRG info.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_plot_road_uvz_map.m 
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
    error('CRG:plotError', 'illegal IU index values iu=[%d %d] with nu=%d', iu(1), iu(2), nu);
end

if nargin < 3
    iv =  [1 nv];
end
if iv(1)<1 || iv(1) >= iv(2) || iv(2) > nv
    error('CRG:showError', 'illegal IV index values iv=[%d %d] with nv=%d', iv(1), iv(2), nv);
end

%% generate auxiliary data

nuiu = iu(2) - iu(1) + 1;
nviv = iv(2) - iv(1) + 1;

u = zeros(1, nuiu);
for i = 1:nuiu
    u(i) = data.head.ubeg + (i-1+iu(1)-1)*data.head.uinc;
end

if isfield(data.head, 'vinc')
    v = zeros(1, nviv);
    for i=1:nviv
        v(i) = data.head.vmin + (i-1+iv(1)-1)*data.head.vinc;
    end
else
    v = double(data.v(iv(1):iv(2)));
end

% grid coordinates in refline system
z = zeros(nuiu, nviv);
puv = zeros(nviv, 2);
for i = 1:nuiu
    puv(:, 1) = u(i);
    puv(:, 2) = v';
    [pz, data] = crg_eval_uv2z(data, puv);
    z(i, :) = pz;
end


%% plot road UVZ orthographic map

data = crg_surf(data, u, v, z');

xlabel('U [m]')
ylabel('V [m]')
if data.head.zoff == 0
    zlabel('Z [m]')
else
    zlabel(sprintf('Z [m] (%+dm)', data.head.zoff))
end
title('CRG road UVZ map (in uncurved UV grid)')

view(2)

end
