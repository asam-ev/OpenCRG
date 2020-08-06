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
%   'data.head.rccl' <-> 'reference_line_curv_check'
% * .. 
%

% DEFAULT SETTINGS
% clear enviroment
close all;
clear all;
clc;

% read crg data
disp("----- Pre: standard check 'crg_read' -----");
data = crg_read('../crg-bin/crgcurvtest.crg');

ierr = 0;

%% Test 1 a
disp("----- Test 1 a: global & local curvature check -----");
tic;
% set opts warn_curv_local
data.opts.wcvl = 1;
crg_check_curvature(data, ierr);
toc

%% Test 1 b
disp("----- Test 1 b: global & local curvature check - variant -----");
tic;
% set opts warn_curv_local
data.opts.wcvl = 1;
crg_check_curvature2(data, ierr);
toc

%% Test 2 a
disp("----- Test 2 a: standard check 'crg_write' (with curvature check local) -----");
% set opts warn_curv_local
data.opts.wcvl = 1;
crg_write(data,'crgcurvtest_local.crg');

%% Test 2 b
disp("----- Test 2 b: standard check 'crg_read' (with curvature check local) -----");
data = crg_read('crgcurvtest_local.crg');
disp("warn_curv_local: " + data.opts.wcvl);
