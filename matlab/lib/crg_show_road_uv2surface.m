function [data] = crg_show_road_uv2surface(data, u, v)
% CRG_SHOW_ELGRID_UV2SURFACE CRG road 3D surface visualizer.
%   DATA = CRG_SHOW_ELGRID_UV2SURFACE(DATA, U, V) visualizes CRG road 3D
%   surface info for a given uv grid.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO
%   U       vector of U grid values
%   V       vector of V grid values
%   Outputs:
%   DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   data = crg_plot_road_uv2xyz_map(data, 0:0.1:100, -2:0.1:2)
%       shows CRG info.
%   See also CRG_INTRO.
%
% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_show_road_uv2surface.m 
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

%% first check & fix & complement DATA

%% check if already succesfully checked

if ~isfield(data, 'ok')
    data = crg_check(data);
    if ~isfield(data, 'ok')
        error('CRG:checkError', 'check of DATA was not completely successful')
    end
end

%% define figure frame

if ~isfield(data, 'fopt') || ~isfield(data.fopt, 'tit')
    data.fopt.tit = 'CRG road surface';
    data          = crg_figure(data);
    data.fopt     = rmfield(data.fopt, 'tit');
else
    data = crg_figure(data);
end

%% refline XY overview map

subplot(2,2,1)

data = crg_plot_refline_xy_overview_map(data);

puv(:,1) = [  u      0*v+u(end)   u(end:-1:1) 0*v+u(1)]';
puv(:,2) = [0*u+v(1)   v        0*u+v(end)      v     ]';

% puv(1,:) = [min(u) min(v)];
% puv(2,:) = [max(u) min(v)];
% puv(3,:) = [max(u) max(v)];
% puv(4,:) = [min(u) max(v)];
% puv(5,:) = puv(1,:);
[pxy data] = crg_eval_uv2xy(data, puv);
hold on
plot(pxy(:,1), pxy(:,2))

set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')


%% elevation grid XYZ perspective map

subplot(2,2,2)
data = crg_plot_road_uv2xyz_map(data, u, v);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

%% elevation grid UVZ orthographic map

subplot(2,2,[3 4])
data = crg_plot_road_uv2uvz_map(data, u, v);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

end
