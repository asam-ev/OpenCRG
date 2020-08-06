%% CRG_DEMO_CONVERT2TXT
% Convert belgian_block.crg demo road to clear text representation.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               demo
% file name:             crg_demo_convert2txt.m
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

ipl = ipl_read('../crg-bin/belgian_block.crg');

%% write it as clear text verison (single precision)

ipl_write(ipl, 'belgian_block-txt-single.crg', 'LRFI');

%% read and visualize result

crg = crg_read('belgian_block-txt-single.crg');
crg_show(crg);

%% write it as clear text verison (double precision)

ipl_write(ipl, 'belgian_block-txt-double.crg', 'LDFI');

%% read and visualize result

crg = crg_read('belgian_block-txt-double.crg');
crg_show(crg);
