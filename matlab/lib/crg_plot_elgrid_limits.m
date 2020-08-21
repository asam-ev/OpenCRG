function [data] = crg_plot_elgrid_limits(data, iu, iv)
% CRG_PLOT_ELGRID_LIMITS Plot the outer grid limits.
%   DATA = CRG_PLOT_ELGRID_LIMITS(DATA, IU, IV) plots the outer limits of the
%   grid in the current axis object. The plot can be limited to a selected area
%   of the grid.
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
%   data = crg_plot_elgrid_limits(data)
%       plots full elevation grid data.
%   data = crg_plot_elgrid_limits(data, [1000 2000], [10 30])
%       plots selected elevation grid data part.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_plot_elgrid_limits.m 
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

u = zeros(1, nuiu);
for i = 1:nuiu
    u(i) = data.head.ubeg + (i-1+iu(1)-1)*data.head.uinc;
end

if isfield(data.head, 'vinc')
    v = zeros(1, nv);
    for i=1:nv
        v(i) = data.head.vmin + (i-1)*data.head.vinc;
    end
else
    v = double(data.v);
end

il = min(iv(2), data.il(iu(1):iu(2)));
ir = max(iv(1), data.ir(iu(1):iu(2)));
vl = v(il);
vr = v(ir);

%% plot elevation grid NaN limits


plot(u, [vl; vr], '-')

hold on
plot(u(  1), [vl(  1); vr(  1)], '>') % mark start
plot(u(end), [vl(end); vr(end)], 's') % mark end

grid on

title('CRG elevation grid limits')
xlabel('U [m]')
ylabel('V [m]')
legend('left limit', 'right limit');

end
