%% Usage of CRG_TEST_MAP_PRO
% Introducing the usage of crg_map_uv2uv and crg_map_xy2xy.
% Examples are included.
% The file comments are optimized for the matlab publishing makro.

%   Copyright penCRG - ASAM e.V.
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

% distance [m] between start points [nbeg,ebeg]
dll_beg = crg_wgs84_dist([crg_orig.head.nbeg crg_orig.head.ebeg], [crg_new.head.nbeg crg_new.head.ebeg])

% distance [m] between end points [nend,eend]
dll_end = crg_wgs84_dist([crg_orig.head.nend crg_orig.head.eend], [crg_new.head.nend crg_new.head.eend])



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