function [data] = crg_plot_refline_xy_overview_map(data, iu)
% CRG_PLOT_REFLINE_XY_OVERVIEW_MAP CRG road refline XY overview map plot.
%   DATA = CRG_PLOT_REFLINE_XY_OVERVIEW_MAP(DATA, IU) plots CRG refline map
%   in current axes object.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO
%   IU      U index for plot selection (default: full CRG)
%           IU(1): longitudinal start index
%           IU(2): longitudinal end index
%   Outputs:
%   DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   data = crg_plot_refline_xy_overview_map(data)
%       plots full map.
%   data = crg_show_refline_xy_overview_map(data, [1000 2000])
%       plots full map and highlights selected part.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_plot_refline_xy_overview_map.m 
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

nu = size(data.z, 1);

%% check/complement optional arguments

if nargin < 2
    iu =  [1 nu];
end
if iu(1)<1 || iu(1) >= iu(2) || iu(2) > nu
    error('CRG:plotError', 'illegal IU index values iu=[%d %d] with nu=%d', iu(1), iu(2), nu);
end

%% generate auxiliary data

u = zeros(1, nu);
for i = 1:nu
    u(i) = data.head.ubeg + (i-1)*data.head.uinc;
end

if isfield(data, 'rx')
    rx = data.rx;
    ry = data.ry;
else
    rx = interp1([data.head.ubeg data.head.uend], [data.head.xbeg data.head.xend], u);
    ry = interp1([data.head.ubeg data.head.uend], [data.head.ybeg data.head.yend], u);
end

%% plot refline XY overview map

if iu(1)>1 || iu(2)<nu
    plot(rx, ry, ':') % plot total refline
    hold on
end

plot(rx(iu(1):iu(2)), ry(iu(1):iu(2)), '-') % plot selected refline part

hold on
plot(rx(iu(1)), ry(iu(1)), '>') % mark start of selected part
plot(rx(iu(2)), ry(iu(2)), 's') % mark end of selected part

axis equal
grid on

title('CRG reference line XY overview map')
if data.head.xoff == 0 || data.head.poff ~= 0
    xlabel('X [m]')
else
    xlabel(sprintf('X [m] (%+dm)', data.head.xoff))
end
if data.head.yoff == 0 || data.head.poff ~= 0
    ylabel('Y [m]')
else
    ylabel(sprintf('Y [m] (%+dm)', data.head.yoff))
end

end
