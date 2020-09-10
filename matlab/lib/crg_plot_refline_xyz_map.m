function [data] = crg_plot_refline_xyz_map(data, iu)
% CRG_PLOT_REFLINE_XYZ_MAP Plot reference line in x/y/z-coordinates.
%   DATA = CRG_PLOT_REFLINE_XYZ_MAP(DATA, IU) plots the reference line
%   in x/y/z-coordinates in the current axes object. The plot can be limited to
%   a selected range on the reference line.
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
%   data = crg_plot_refline_xyz_map(data)
%       Plot the entire reference line.
%   data = crg_plot_refline_xyz_map(data, [1000 2000])
%       Plots selected range of the reference line.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_plot_refline_xyz_map.m 
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

%% evaluate DATA.z size

nu = size(data.z, 1);

%% check and complement optional arguments

if nargin < 2
    iu =  [1 nu];
end
if iu(1)<1 || iu(1) >= iu(2) || iu(2) > nu
    error('CRG:plotError', 'illegal IU index values iu=[%d %d] with nu=%d', iu(1), iu(2), nu);
end

%% generate auxiliary data

nuiu = iu(2) - iu(1) + 1;

u = zeros(1, nuiu);
for i = 1:nuiu
    u(i) = data.head.ubeg + (i-1+iu(1)-1)*data.head.uinc;
end

if isfield(data, 'rx')
    rx = data.rx(iu(1):iu(2));
    ry = data.ry(iu(1):iu(2));
else
    rx = interp1([data.head.ubeg data.head.uend], [data.head.xbeg data.head.xend], u);
    ry = interp1([data.head.ubeg data.head.uend], [data.head.ybeg data.head.yend], u);
end

if isfield(data, 'rz')
    rz = data.rz(iu(1):iu(2));
else
    rz = zeros(1, nuiu) + data.head.zbeg;
end

%% plot reference line XYZ map

plot3(rx, ry, rz, '-')
hold on

plot3(rx(  1), ry(  1), rz(  1), '>') % mark start
plot3(rx(end), ry(end), rz(end), 's') % mark end

fasp = 0.1; % z aspect ratio 0.1 magnifies z-axis by 10
if isfield(data, 'fopt') && isfield(data.fopt, 'asp')
    fasp = data.fopt.asp;
end
daspect([1 1 fasp])

axis vis3d
view(3)
grid on

title('CRG reference line XYZ map')
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
if data.head.zoff == 0
    zlabel('Z [m]')
else
    zlabel(sprintf('Z [m] (%+dm)', data.head.zoff))
end

end
