function [data] = crg_plot_refline_elevation(data, iu)
% CRG_PLOT_REFLINE_ELEVATION Plot the z-values along the reference line.
%   DATA = CRG_PLOT_REFLINE_ELEVATION(DATA, IU) plots z-values along the
%   reference line in the current axes object. The plot can be limited to a
%   selected range on the reference line.
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
%   data = crg_plot_refline_elevation(data)
%       Plots all z-values.
%   data = crg_plot_refline_elevation(data, [1000 2000])
%       Plots z-values for the selected range on reference line.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_plot_refline_elevation.m 
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

if isfield(data, 'rz')
    rz = data.rz(iu(1):iu(2));
else
    rz = zeros(1, nuiu) + data.head.zbeg;
end

%% plot reference line elevation

plot(u, rz, '-')

hold on
plot(u(  1), rz(  1), '>') % mark start
plot(u(end), rz(end), 's') % mark end

grid on

title('CRG reference line elevation')
xlabel('U [m]')
if data.head.zoff == 0
    ylabel('Z [m]')
else
    ylabel(sprintf('Z [m] (%+dm)', data.head.zoff))
end

end
