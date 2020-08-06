%% CRG_DEMO_BELGIAN_BLOCK
% Load and visualize belgian_block.crg demo road.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               demo
% file name:             crg_demo_belgian_block.m
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

%% clear enviroment

clear all
close all

%% load demo road

crg = crg_read('../crg-bin/belgian_block.crg');

%% visualize road

crg = crg_show(crg);

crg_wgs84_crg2html(crg, 'belgian_block.html');
web('belgian_block.html', '-browser');
