%% Usage of CRG_TEST_CURVATURE
% Introducing the usage of crg_check_data and crg_check_curvature.
% Examples are included.
% The file comments are optimized for the matlab publishing makro.

% *****************************************************************
% See the NOTICE file distributed with this work regarding copyright ownership.
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%    https://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
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
data0 = crg_read('../../crg-bin/crg_local_curv_test_fail.crg');

% File 2: failing global but succeeding local curvature test
disp("----- Pre File 2: standard check 'crg_read' -----");
data1 = crg_read('../../crg-bin/crg_local_curv_test_ok.crg');

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
