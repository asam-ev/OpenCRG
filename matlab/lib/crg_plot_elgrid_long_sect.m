function [data] = crg_plot_elgrid_long_sect(data, iu, iv)
% CRG_PLOT_ELGRID_LONG_SECT Plot z-values over longitudinal cuts.
%   DATA = CRG_PLOT_ELGRID_LONG_SECT(DATA, IU, IV) plots z-values over u for
%   various v-coordinates. The plot can be limited to a selected area of the grid.
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
%   data = crg_plot_elgrid_long_sect(data)
%       Plots all z-values.
%   data = crg_plot_elgrid_long_sect(data, [1000 2000], [10 30])
%       Plots z-values in the selected area of the grid.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_plot_elgrid_long_sect.m 
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

[nu nv] = size(data.z);

%% check and complement optional arguments

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

jv = [iv(1):ceil(nviv/5):iv(2)-1 iv(2)];

%% plot elevation grid long sections

% MATLAB bug in verison 7.13 (R2011b):
% Using a matrix of singles as input to PLOT causes MATLAB to crash or hang.
% Workaround: Cast matrix to double data type.
% (see MATLAB service request 1-GAYXED of 2012-01-09)
plot(u, double(data.z(iu(1):iu(2), jv)), '-')

hold on
plot(u(  1), data.z(iu(  1), jv), '>') % mark start
plot(u(end), data.z(iu(end), jv), 's') % mark end

grid on

title('CRG elevation grid long sections - w/o slope & banking & offset')
xlabel('U [m]')
ylabel('Z [m]')
leg = cell(1,0);
for i = 1:length(jv)
    leg{i} = ['at v = ' num2str(v(jv(i)-iv(1)+1))];
end
legend(leg);

end
