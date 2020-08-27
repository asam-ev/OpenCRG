function [data] = crg_show_refpnts_and_refline(data, pxy)
% CRG_SHOW_REFLINE_MAP CRG Visualize reference points and reference line.
%   DATA = CRG_SHOW_REFLINE_MAP(DATA, IU) visualizes the given reference points
%   and the resulting reference line map.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO
%   PXY     (np, 2) array of points in x-y coordinate system
%
%   Outputs:
%   DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   data = crg_show_refpnts_and_refline(data, pxy)
%       Visualizes the reference points pxy in relation to the reference line.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_show_refpnts_and_refline.m 
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

%% define figure frame

if ~isfield(data, 'fopt') || ~isfield(data.fopt, 'tit')
    data.fopt.tit = 'CRG reference points and resulting reference line map';
    data          = crg_figure(data);
    data.fopt     = rmfield(data.fopt, 'tit');
else
    data = crg_figure(data);
end

%% reference points and reference line XY overview map

subplot(3,2,1)

plot(pxy(:,1), pxy(:,2), '.')
hold on
data = crg_plot_refline_xy_overview_map(data);
title('CRG reference points in reference line XY overview map')

set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

%% reference point distances from refline

subplot(3,2,2)

data = crg_plot_refpnt_distances(data, pxy);

set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

%% reference line XY overview map

subplot(3,2,3)
data = crg_plot_refline_xy_overview_map(data);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

%% reference line heading plot

subplot(3,2,4)
data = crg_plot_refline_heading(data);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

%% reference line XY map with norm. curvature

subplot(3,2,5)
data = crg_plot_refline_xy_map_and_curv(data);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')


%% reference line curvature plot

subplot(3,2,6)
data = crg_plot_refline_curvature(data);
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

end
