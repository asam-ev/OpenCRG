%% Usage of CRG_TEST_MAP_PRO
% Introducing the usage of crg_map_uv2uv and crg_map_xy2xy.
% Examples are included.
% The file comments are optimized for the matlab publishing makro.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               test
% file name:             crg_test_map_pro.m
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
% * read input file '../crg-bin/crg_refline_Hoki_HoeKi_Grafing.crg'
%   containing correct wgs84 coordinates, but no mpro
%
% Test 1
% * using crg_wgs84_setend to calculate an approximated crg end point
%   and display as html
% Test 2
% * using crg_check_wgs84 in combination with added mpro definition to
%   calculate accurate wgs84 coordinates and display as html
% Test 3
% * plotting deviation

% DEFAULT SETTINGS
% clear enviroment
close all;
clear all;
clc;

% read crg data (with correct wgs84 and UTM coordinates)
crg_orig = crg_read('../crg-bin/crg_refline_Hoki_HoeKi_Grafing.crg');

%% Test1 ( orig data consistency no map pro entry )

% removing wgs84 end point (for test purposes only)
crg_orig.head = rmfield(crg_orig.head, 'nend');
crg_orig.head = rmfield(crg_orig.head, 'eend');

% recalculating wgs84 end point with approximated calculation on sphere
[crg_approx] = crg_wgs84_setend(crg_orig);

% check data consistency
crg_approx = crg_check_wgs84(crg_approx);

% create html
opts.mpol = 1000; % nr of polyline points, see crg_wgs84_crg2html.m
crg_wgs84_crg2html(crg_approx, 'crg_refline_Hoki_HoeKi_Grafing_approx.html', opts);
web('crg_refline_Hoki_HoeKi_Grafing_approx.html', '-browser');

%% Test2 ( add map pro entry and check data consistency)

% removing all remaining wgs84 coordinates (for test purposes only)
crg_orig.head = rmfield(crg_orig.head,'ebeg');   
crg_orig.head = rmfield(crg_orig.head,'nbeg');

% copy data and change file name
crg_mpro = crg_orig;
crg_mpro.filenm = strrep(crg_mpro.filenm,'.crg','_mpro.crg');

% add mpro entries: ellipsoid name and projection
mpro.gell.nm='WGS84';
mpro.proj.nm='UTM_32U';

% perform check to validate and complete mpro entry
crg_mpro.mpro=map_check(mpro);

% check data consistency (adds new caluclated wgs84 coordinates using mpro)
crg_mpro=crg_check_wgs84(crg_mpro);

% create html
crg_wgs84_crg2html(crg_mpro, 'crg_refline_Hoki_HoeKi_Grafing_mpro.html', opts);
web('crg_refline_Hoki_HoeKi_Grafing_mpro.html', '-browser');

% write crg with new mpro entry
crg_write(crg_mpro,'crg_refline_Hoki_HoeKi_Grafing_mpro.crg');

%% Test3 (examine differences)

disp_mpro(crg_approx)
disp_mpro(crg_mpro)

% generate WGS84 coordinates
[crg_test_wgs, crg_test_puv] = generateWGS84coords(crg_approx);
[crg_new_wgs, crg_new_puv] = generateWGS84coords(crg_mpro);

% distance [m] between start points [nbeg,ebeg]
dist = crg_wgs84_dist(crg_test_wgs, crg_new_wgs);
figure
subplot(2,1,1)
hold on
plot(crg_test_wgs(:,2), crg_test_wgs(:,1), 'rx');
plot(crg_new_wgs(:,2), crg_new_wgs(:,1), 'bo');
text(crg_test_wgs(1:10:end,2),crg_test_wgs(1:10:end,1),num2cell(crg_test_puv(1:10:end,1)),'VerticalAlignment','bottom','HorizontalAlignment','right')
u=text(crg_test_wgs(1,2),crg_test_wgs(1,1),'  \rightarrow u [m]');
set(u,'Rotation',atand((crg_test_wgs(1,1)-crg_test_wgs(end,1))/(crg_test_wgs(1,2)-crg_test_wgs(end,2))));
hold off
title('CRG reference line points')
xlabel('Longitude [°]')
ylabel('Latitude [°]')
legend({'test','mpro'},'Location','northwest')
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

subplot(2,1,2)
bar(crg_test_puv(:,1), dist, 'w');
title('CRG reference line difference between corresponding u-positions')
xlabel('u [m]')
ylabel('distance on sphere [m]')
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')


%% helper functions
function  disp_mpro(crg)
    if isfield(crg, 'mpro')
        disp(['found field mpro in ', crg.filenm])
        gell = struct2table(crg.mpro.gell)
        lell = struct2table(crg.mpro.lell)
        tran = struct2table(crg.mpro.tran)
        proj = struct2table(crg.mpro.proj)
    else
        disp(['no field mpro in ', crg.filenm])
    end
end

function [wgs, puv] = generateWGS84coords(data)
    mpol = 100;         % maximum number of polyline points
    minc = 1.0;         % minimum polyline point u increment

    npol = min(mpol, ceil((data.head.uend-data.head.ubeg)/minc));
    puv = zeros(npol, 2);
    puv(:, 1) = linspace(data.head.ubeg, data.head.uend, npol);

    pxy = crg_eval_uv2xy(data, puv);
    wgs = crg_wgs84_xy2wgs(data, pxy);
end