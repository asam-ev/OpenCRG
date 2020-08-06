%% CRG_DEMO_CONVERT2BIN
% Convert handmade_curved.crg demo road to binary representation.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               demo
% file name:             crg_demo_convert2bin.m
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

ipl = ipl_read('../crg-txt/handmade_curved.crg');

%% write it as binary verison (single precision)

ipl_write(ipl, 'handmade_curved-bin-single.crg', 'KRBI');

%% read and visualize result

crg = crg_read('handmade_curved-bin-single.crg');
crg_show(crg);
