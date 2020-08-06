%% Usage of CRG_MAP_UV2UVV AND CRG_MAP_XY2XY
% Introducing the usage of crg_map_uv2uv and crg_map_xy2xy.
% Examples are included.
% The file comments are optimized for the matlab publishing makro.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               test
% file name:             crg_test_map_uv2uvAxy2xy.m
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
% * generate 0-z-crg file
% * load test/real files
% * FIRST: u,v maping ( za(u,v) -> zb(u,v) )
% * SECOND: inertial x,y mapping ( za(x,y) -> zb(x,y) )
% * display result
%

% DEFAULT SETTINGS
% clear enviroment
clear all;
close all;

%% Test1 ( no additional parameter )
c = {  3   {   0  -0.2/3 }  ...    % klothoide
     ; 5   {-0.2   0.4/5 }  ...    % turning klothoide
     ; 8   { 0.4   0.4/8 }  ...    % circle
    };

dat1 = crg_gen_csb2crg0([], 16, 1, c);
dat2 = crg_read('demo1.crg');

data = crg_map_uv2uv(dat1,dat2);        % u,v mapping
crg_show(data);

data = crg_map_xy2xy(dat1,dat2);        % inertial mapping
crg_show(data);


%% Test2 ( u-start/stop index)
c = {  3   {   0  -0.2/3 }  ...    % klothoide
     ; 5   {-0.2   0.4/5 }  ...    % turning klothoide
     ; 8   { 0.4   0.4/8 }  ...    % circle
    };

dat1 = crg_gen_csb2crg0([], 16, 1, c);
dat2 = crg_read('demo3.crg');

data = crg_map_uv2uv(dat1, dat2, [200 1000]);       % u,v mapping
crg_show(data);

data = crg_map_xy2xy(dat1,dat2, [200 1000]);        % inertial mapping
crg_show(data);

%% Test3 ( v-start/stop index )
% Border Mode is default
c = {  3   {   0  -0.2/3 }  ...    % klothoide
     ; 5   {-0.2   0.4/5 }  ...    % turning klothoide
     ; 8   { 0.4   0.4/8 }  ...    % circle
    };


dat1 = crg_gen_csb2crg0([], 16, 1, c);
dat2 = crg_read('demo1.crg');

data = crg_map_uv2uv(dat1, dat2, [], [70 110]);     % u,v mapping
crg_show(data);

data = crg_map_xy2xy(dat1,dat2, [], [20 75]);       % inertial mapping
crg_show(data);


%% Test4 ( u/v-start/stop index )
c = {  3   {   0  -0.2/3 }  ...    % klothoide
     ; 5   {-0.2   0.4/5 }  ...    % turning klothoide
     ; 8   { 0.4   0.4/8 }  ...    % circle
    };

dat1 = crg_gen_csb2crg0([], 16, 1, c);
dat2 = crg_read('demo1.crg');

data = crg_map_uv2uv(dat1, dat2, [200 1000], [50 150]); % u,v mapping
crg_show(data);

data = crg_map_xy2xy(dat1,dat2, [50 150], [20 50]);     % inertial mapping
crg_show(data);

%% Test5 ( add curved crg )
c = {  3   {   0  -0.2/3 }  ...    % klothoide
     ; 5   {-0.2   0.4/5 }  ...    % turning klothoide
     ; 8   { 0.4   0.4/8 }  ...    % circle
    };

dat1 = crg_gen_csb2crg0([], 16, 1, c);
dat2 = crg_read('demo7.crg');

data = crg_map_uv2uv(dat1, dat2);   % u,v mapping
crg_show(data);

data = crg_map_xy2xy(dat1,dat2);    % inertial mapping
crg_show(data);

%% Test6 ( adding real dataset )
c = {  3   {   0  -0.2/3 }  ...    % klothoide
     ; 5   {-0.2   0.4/5 }  ...    % turning klothoide
     ; 8   { 0.4   0.4/8 }  ...    % circle
    };

dat1 = crg_gen_csb2crg0([], 16, 1, c);
dat2 = crg_read('../crg-bin/belgian_block.crg');

dat2.mods.rptx = 1;
dat2.mods.rpty = 1;
dat4 = crg_mods(dat2);

data = crg_map_uv2uv(dat1, dat4 );    % u,v mapping
crg_show(data);

data = crg_map_xy2xy(dat1,dat4 );     % inertial mapping
crg_show(data);
