%% Usage of CRG_EXT_BANKING and CRG_EXT_SLOPE
% Introducing the usage of crg_ext_banking and crg_ext_slope.
% Examples are included.
% The file comments are optimized for the matlab publishing makro.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               test
% file name:             crg_test_ext_sb.m
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
% * load demo/real file
% * extract banking/banking
% * display result
%

% DEFAULT SETTINGS
% clear enviroment
clear all;
close all;

%% Test1 ( extract banking incl. smoothing )

dat = crg_read('demo7.crg');

exdata = crg_ext_banking(dat, 0.0000003);

crg_show_refline_elevation(exdata);
crg_show_elgrid_surface(exdata)
crg_show_road_surface(exdata);

%% Test1.1 ( extract banking w/o smoothing  )

dat = crg_read('demo7.crg');

exdata = crg_ext_banking(dat);

crg_show_refline_elevation(exdata);
crg_show_elgrid_surface(exdata)
crg_show_road_surface(exdata);

%% Test2 ( extract slope )

dat = crg_read('demo9.crg');

exdata = crg_ext_slope(dat);

crg_show_refline_elevation(exdata);
crg_show_elgrid_surface(exdata)
crg_show_road_surface(exdata);

%% Test2.1 ( extract slope/banking )

dat = crg_read('demo8.crg');

exdata = crg_ext_banking(dat);
exdata = crg_ext_slope(exdata);

crg_show_refline_elevation(exdata);
crg_show_elgrid_surface(exdata)
crg_show_road_surface(exdata);

%% Test3 ( real dataset extract slope/banking )

dat = crg_read('../crg-bin/belgian_block.crg');

exdata = crg_ext_banking(dat, 0.0000000000003);
exdata = crg_ext_slope(exdata);

crg_show_refline_elevation(exdata);
crg_show_elgrid_surface(exdata)
crg_show_road_surface(exdata);
