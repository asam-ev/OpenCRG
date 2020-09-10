function [data] = crg_plot_road_uv2uvz_map(data, u, v)
% CRG_PLOT_ROAD_UV2UVZ_MAP Plot road surface over a given uncurved grid.
%   DATA = CRG_PLOT_ROAD_UV2UVZ_MAP(DATA, U, V) plots the road surface as
%   an orthographic image over a given uncurved grid in the current axes object.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO
%   U       vector of U grid values
%   V       vector of V grid values
%   Outputs:
%   DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   data = crg_plot_road_uv2uvz_map(data, 0:0.1:100, -2:0.1:2)
%       Plots entire road surface on a grid given by u = 0:0.1:100
%       and v = -2:0.1:2.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_plot_road_uv2uvz_map.m 
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

%% check if already successfully checked

if ~isfield(data, 'ok')
    data = crg_check(data);
    if ~isfield(data, 'ok')
        error('CRG:checkError', 'check of DATA was not completely successful')
    end
end

%% auxiliary data

nuiu = length(u);
nviv = length(v);

% grid coordinates in reference line system
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
