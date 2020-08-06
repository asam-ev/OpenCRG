function [data] = crg_show_elgrid_cuts_and_limits(data, iu, iv)
% CRG_SHOW_ELGRID_CUTS_AND_LIMITS CRG road elevation grid 2D visualizer.
%   DATA = CRG_SHOW_ELGRID_CUTS_AND_LIMITS(DATA, IU, IV) visualizes CRG
%   elevation grid cuts and limits info.
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
%   data = crg_show_elgrid_cuts_and_limits(data)
%       shows full CRG info.
%   data = crg_show_elgrid_cuts_and_limits(data, [1000 2000], [10 20])
%       shows partial CRG info.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_show_elgrid_cuts_and_limits.m 
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

%% define figure frame

if ~isfield(data, 'fopt') || ~isfield(data.fopt, 'tit')
    data.fopt.tit = 'CRG elevation grid cuts and limits';
    data          = crg_figure(data);
    data.fopt     = rmfield(data.fopt, 'tit');
else
    data = crg_figure(data);
end

%% refline XY overview map

subplot(2,2,1)
data = crg_plot_refline_xy_overview_map(data, iu);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

%% elevation grid limits

subplot(2,2,2)
data = crg_plot_elgrid_limits(data, iu, iv);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')
a2 = gca;

%% cross sections

subplot(2,2,3)
data = crg_plot_elgrid_cross_sect(data, iu, iv);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

%% long sections

subplot(2,2,4)
data = crg_plot_elgrid_long_sect(data, iu, iv);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')
a4 = gca;

%%  link axes

linkaxes([a2 a4], 'x')

end
