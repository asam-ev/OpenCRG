%% Usage of CRG_TEST_MAP_PRO
% Introducing the usage of crg_map_uv2uv and crg_map_xy2xy.
% Examples are included.
% The file comments are optimized for the matlab publishing makro.

%   Copyright OpenCRG - ASAM e.V.
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
%   $Id: crg_test_map_pro.m 1 2020-04-24 15:30:00Z rruhdorfer $

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


%% Test1 ( orig data consistency no map pro entry )

% check data consistency
%crg_orig = crg_check_wgs84(crg_orig);
crg_wgs84_crg2html(crg_orig, '3DMap_Axis1318611_Cobblestoneroad_5mm_orig.html');


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
%orig_ref_points = [[crg_orig.head.nbeg, crg_orig.head.ebeg]; [crg_orig.head.nend, crg_orig.head.eend]];
%new_ref_points = [[crg_new.head.nbeg, crg_new.head.ebeg];[crg_new.head.nend, crg_new.head.eend]];

%dll_beg = crg_wgs84_dist(orig_ref_points, new_ref_points)

dist = crg_wgs84_dist(crg_orig_wgs, crg_new_wgs);
figure
subplot(2,1,1)
hold on
plot(crg_orig_wgs(:,2), crg_orig_wgs(:,1), 'rx');
plot(crg_new_wgs(:,2), crg_new_wgs(:,1), 'bo');
text(crg_orig_wgs(1:10:end,2),crg_orig_wgs(1:10:end,1),num2cell(crg_orig_puv(1:10:end,1)),'VerticalAlignment','bottom','HorizontalAlignment','right')
u=text(crg_orig_wgs(1,2),crg_orig_wgs(1,1),'  \leftarrow U [m]');
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
xlabel('U [m]')
ylabel('distance on sphere [m]')
set(    gca             , 'ButtonDownFcn','copy_ax2fig')
set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')



% distance [m] between end points [nend,eend]
%dll_end = crg_wgs84_dist([crg_orig.head.nend crg_orig.head.eend], [crg_new.head.nend crg_new.head.eend])

% plot difference in steps
% [pllh, crg_orig] = crg_eval_xyz2llh(crg_orig, [crg_orig.rx, crg_orig.ry]);


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