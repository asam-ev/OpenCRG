function [data] = crg_show_refline_elevation(data, iu)
% CRG_SHOW_REFLINE_ELEVATION CRG road refline elevation visualizer.
%   DATA = CRG_SHOW_REFLINE_ELEVATION(DATA, IU) visualizes CRG refline
%   elevation info.
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
%   data = crg_show_refline_elevation(data)
%       shows full CRG info.
%   data = crg_show_refline_elevation(data, [1000 2000])
%       shows selected CRG info.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_show_refline_elevation.m 
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
    error('CRG:showError', 'illegal IU index values iu=[%d %d] with nu=%d', iu(1), iu(2), nu);
end

%% define figure frame

if ~isfield(data, 'fopt') || ~isfield(data.fopt, 'tit')
    data.fopt.tit = 'CRG reference line elevation';
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

%% refline slope and banking plot

subplot(2,2,2)
data = crg_plot_refline_slope_bank(data, iu);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')
a2 = gca;

%% refline 3D plot

subplot(2,2,3)
data = crg_plot_refline_xyz_map(data, iu);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')


%% refline elevation plot

subplot(2,2,4)
data = crg_plot_refline_elevation(data, iu);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')
a4 = gca;

%%  link axes

linkaxes([a2 a4], 'x')

end
