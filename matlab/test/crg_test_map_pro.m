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
% * UTM (UTM2BLH, BLH2UTM)
% * GK (GK2BLH, BLH2GK)
% * .. 
%

% DEFAULT SETTINGS
% clear enviroment
close all;
clear all;
clc;

% read crg data
crg_orig = crg_read('../crg-bin/3DMap_Axis1318611_Cobblestoneroad_5mm.crg');
% //TODO: use crg_orig = crg_read('../crg-bin/crg_refline_Hoki_HoeKi_Grafing.crg');
% //TODO: missing wgs84 coordinates in crg_refline_Hoki_HoeKi_Grafing.crg

%% Test1 ( orig data consistency no map pro entry )

% check data consistency
crg_orig = crg_check_wgs84(crg_orig);
crg_wgs84_crg2html(crg_orig, '3DMap_Axis1318611_Cobblestoneroad_5mm_orig.html');
% //TODO: use crg_wgs84_crg2html(crg_orig, 'crg_refline_Hoki_HoeKi_Grafing.html');

%% Test2 ( add map pro entry and check data consistency)

% copy data and remove old reference line definition
crg_new = crg_orig;
crg_new.head = rmfield(crg_new.head,'ebeg');   
crg_new.head = rmfield(crg_new.head,'nbeg');
crg_new.head = rmfield(crg_new.head,'nend');
crg_new.head = rmfield(crg_new.head,'eend');
crg_new.filenm = strrep(crg_new.filenm,'.crg','_new_map.crg');

% add mpro entries: ellipsoid name and projection
mpro.gell.nm='WGS84';
mpro.proj.nm='UTM_32U';

% perform check to validate and complete mpro entry
crg_new.mpro=map_check(mpro);

% check data consistency
crg_new=crg_check_wgs84(crg_new);
crg_wgs84_crg2html(crg_new, '3DMap_Axis1318611_Cobblestoneroad_5mm_new_map.html');

% write crg with new mpro entry
crg_write(crg_new,'3DMap_Axis1318611_Cobblestoneroad_5mm_new_map.crg');

%% Test3 (examine differences)

disp_mpro(crg_orig)
disp_mpro(crg_new)

%% generate WGS84 coordinates


[crg_orig_wgs, crg_orig_puv] = generateWGS84coords(crg_orig);
[crg_new_wgs, crg_new_puv] = generateWGS84coords(crg_new);

% distance [m] between start points [nbeg,ebeg]
dist = crg_wgs84_dist(crg_orig_wgs, crg_new_wgs);
figure
subplot(2,1,1)
hold on
plot(crg_orig_wgs(:,2), crg_orig_wgs(:,1), 'rx');
plot(crg_new_wgs(:,2), crg_new_wgs(:,1), 'bo');
text(crg_orig_wgs(1:10:end,2),crg_orig_wgs(1:10:end,1),num2cell(crg_orig_puv(1:10:end,1)),'VerticalAlignment','bottom','HorizontalAlignment','right')
u=text(crg_orig_wgs(1,2),crg_orig_wgs(1,1),'  \leftarrow u [m]');
set(u,'Rotation',atand((crg_orig_wgs(1,1)-crg_orig_wgs(end,1))/(crg_orig_wgs(1,2)-crg_orig_wgs(end,2))));
%annotation('textarrow',pos(1)+cx*(x-rx(1)),pos(2)+cy*(y-ry(1)),'String','u')
hold off
title('CRG reference line points')
xlabel('Longitude [°]')
ylabel('Latitude [°]')
legend({'orig','mpro'},'Location','northwest')
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')

subplot(2,1,2)
bar(crg_orig_puv(:,1), dist, 'w');
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
    % [pz, data] = crg_eval_uv2z(data, puv([1 end],:));
end