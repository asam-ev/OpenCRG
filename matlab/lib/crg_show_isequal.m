function [] = crg_show_isequal(dd, out)
% CRG_SHOW_ISEQUAL CRG_comparison of two crg_files data core visualizer.
%   CRG_SHOW_ISEQUAL(DD) Visualize the result of comparing two OpenCRG files.
%   Comparisons are usually done using CRG_ISEQUAL.
%
%   Inputs:
%   DD      struct array as defined in CRG_ISEQUAL
%   OUT     visualization ( optional )
%           html:   html visualization
%
%   Examples:
%   crg_show_isequal(dd, 'html')
%       Visualizes dd, the results of CRG_ISEQUAL, and displays them in the default web browser
%       default web browser
%
%   See also CRG_INTRO, CRG_ISEQUAL.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_show_isequal.m 
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

% default
if nargin < 2 || isempty(out), out = ''; end

scrpos = get(0,'ScreenSize');   % Set plot area
scrpos(3) = scrpos(4);          % quadratic max. window size

% publish html
if strcmp(out,'html')
    function_options.format = 'html';
    function_options.evalCode=true;
    function_options.codeToEvaluate= 'crg_show_isequal(dd)' ;
    function_options.showCode=false;
    web(publish('crg_show_isequal.m',function_options))
    return
end

%% warning messages
% warning messages will not stop comparison
for i = 1:length(dd.warn)
    disp(dd.warn(i));
end

%% error messages
% display error messages
for i = 1:length(dd.err)
    disp(dd.err(i));
end

%% visualize z-matrix comparison

% histogram of arithmetic absolute mean
figure('Position', scrpos)

[xi, yi] = meshgrid(dd.u,dd.v);

subplot(3,1,1)
hist(dd.mean)
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

xlabel('Diff [m]')
ylabel('Count [#]')
title('CRG histogramm of absolute arithmetic average')

% arithmetic average of z-values (absolute)
subplot(3,1,2)
surf(xi, yi, double(dd.mean));
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

shading interp

xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
title('CRG arithmetic average of z-values (absolute)')

colorbar

% CRG arithmetic average of z-values (relative)
subplot(3,1,3)
surf(xi,yi, double(dd.rmean));
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

shading interp

xlabel('NN')
ylabel('NN')
zlabel('NN')
title('CRG arithmetic average of z-values (relative)')

colorbar

end % function crg_show_isequal
