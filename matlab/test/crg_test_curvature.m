%% Usage of CRG_TEST_CURVATURE
% Introducing the usage of crg_check_data and crg_check_curvature.
% Examples are included.
% The file comments are optimized for the matlab publishing makro.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               test
% file name:             crg_test_curvature.m
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

%% Test proceedings
%
% * Test global & local curvature
% * Test writing and reading flag:
%   'data.opts.wcvl' <-> 'warn_curv_local'
% * .. 
%

% DEFAULT SETTINGS
% clear enviroment
close all;
clear all;
clc;

% read and show crg data

% File 1: failing global and local curvature test
disp("----- Pre File 1: standard check 'crg_read' -----");
data0 = crg_read('../crg-bin/crg_local_curv_test_fail.crg');

% File 2: failing global but succeeding local curvature test
disp("----- Pre File 2: standard check 'crg_read' -----");
data1 = crg_read('../crg-bin/crg_local_curv_test_ok.crg');

ierr = 0;

%% Test 1
disp("----- Test 1: global & local curvature check -----");
% set opts warn_curv_local (if not set)
if ~isfield(data0.opts, 'wcvl')
    data0.opts.wcvl = 1;
end
[data0, ierr, idxArr0] = crg_check_curvature(data0, ierr);

%% Test 2
disp("----- Test 2: global & local curvature check -----");
% set opts warn_curv_local (if not set)
if ~isfield(data1.opts, 'wcvl')
    data1.opts.wcvl = 1;
end
[data1, ierr, idxArr1] = crg_check_curvature(data1, ierr);

%% plotting test files and error regions
% preparing data for plots (set temp ok)
data0.ok = 1;

disp("----- plotting -----");
figure;
subplot(2,2,1)
hold on
crg_plot_refline_xyz_map(data0);
if ~isempty(idxArr0)
    crg_plot_refline_xyz_map(data0, idxArr0);   % error region
end
hold off
legend('ref line','start','end','error region','start','end')
title('File 1: failing global and local curvature test')
subplot(2,2,2)
hold on
crg_plot_refline_xyz_map(data1);
if ~isempty(idxArr1)
    crg_plot_refline_xyz_map(data1, idxArr1);   % error region
end
hold off
legend('ref line','start','end','error region','start','end')
title('File 2: failing global but succeeding local curvature test')
subplot(2,2,3)
crg_plot_road_xyz_map(data0);
subplot(2,2,4)
crg_plot_road_xyz_map(data1);
