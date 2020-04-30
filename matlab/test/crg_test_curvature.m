%% Usage of CRG_TEST_CURVATURE
% Introducing the usage of crg_check_data and crg_check_curvature.
% Examples are included.
% The file comments are optimized for the matlab publishing makro.

%   Copyright penCRG - ASAM e.V.
%
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
%
%       http://www.apache.org/licenses/LICENSE-2.0
%
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
%
%   More Information on OpenCRG open file formats and tools can be found at
%
%       http://www.opencrg.org
%
%   $Id: crg_test_map_pro.m 1 2020-04-30 15:30:00Z rruhdorfer $

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
disp("----- standard check: crg_read -----");
data = crg_read('../crg-bin/crgcurvtest.crg');

%% Test 1 a
disp("----- Test 1 a: global & local curvature check -----");
tic;
% set reference line curvature check local
data.head.rccl = 1.0;
crg_check_curvature(data);
toc

%% Test 1 b
disp("----- Test 1 b: global & local curvature check - variant -----");
tic;
% set reference line curvature check local
data.head.rccl = 1.0;
crg_check_curvature2(data);
toc

%% Test 2
disp("----- standard check: crg_write (with curvature check local) -----");
crg_write(data,'crgcurvtest_rccl.crg');

disp("----- standard check: crg_read (with curvature check local) -----");
data = crg_read('crgcurvtest_rccl.crg');


