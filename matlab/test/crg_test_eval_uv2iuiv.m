%% Usage of CRG_EVAL_UV2IUIV
% Introducing the usage of crg_eval_uv2iuiv.
% Examples are included.
% The file comments are optimized for the matlab publishing makro.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               test
% file name:             crg_test_eval_uv2iuiv.m
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
% Test 1-4
%
% * load crg-file
% * find index positions
%

% DEFAULT SETTINGS
% clear enviroment
clear all;
close all;

%% Test1 ( u-values )

data = crg_read('demo3.crg');
u = data.head.ubeg:data.head.uinc:data.head.uend;

[iu] = crg_eval_uv2iuiv(data, [-1, 0, 5, 7, 10, 11] );
disp('Index: ');
disp(sprintf('< %d > \t', iu));

disp('Distance u(iu) = ');
disp(sprintf('< %f > \t', u(iu)));

%% Test2 ( empty )

data = crg_read('demo3.crg');

[iu] = crg_eval_uv2iuiv(data, [] );

%% Test3 ( v-values constant vinc )

data = crg_read('demo1.crg');
v = data.head.vmin:data.head.vinc:data.head.vmax;

[iu, iv] = crg_eval_uv2iuiv(data, [],  [-2 -1 -0.5, 0, 0.5, 1 2]);
disp('Index: ');
disp(sprintf('< %d > \t', iv));

disp('Distance v(iv) = ');
disp(sprintf('< %f > \t', v(iv)));


%% Test3.1 ( v-values no constant vinc )

data = crg_read('demo3.crg');
v = data.v;

[iu, iv] = crg_eval_uv2iuiv(data, [],  [-2 -1 -0.5, 0, 0.5, 1 2]);
disp('Index: ');
disp(sprintf('< %d > \t', iv));

disp('Distance v(iv) = ');
disp(sprintf('< %f > \t', v(iv)));


%% Test4 ( uv-values & different uinc );

data = crg_read('demo6.crg');
u = data.head.ubeg:data.head.uinc:data.head.uend;
v = data.v;

dat = crg_rerender(data, [0.2]);

[iu, iv] = crg_eval_uv2iuiv(dat, [-1, 0, 5, 7, 10, 11], [-2, -1, 0.5, 0, 0.5, 1, 2]);
disp('Index iu: ');
disp(sprintf('< %d > \t', iu));
disp('Index iv: ');
disp(sprintf('< %d > \t', iv));

disp('Distance u(iu) = ');
disp(sprintf('< %f > \t', u(iu)));
disp('Distance v(iv) = ');
disp(sprintf('< %f > \t', v(iv)));
