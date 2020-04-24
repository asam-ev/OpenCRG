%% Usage of CRG_TEST_MAP_TRANSFORMATION
% Introducing the usage of map_geod2pmap_tm and map_pmap2geod_tm, 
% map_global2plocal and map_geod2pmap_tm.
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
%   $Id: crg_test_map_transformation.m 1 2020-04-24 15:30:00Z rruhdorfer $

%% Test proceedings
%
% * UTM (UTM2BLH, BLH2UTM)
% * GK (GK2BLH, BLH2GK)
% * .. 
%

% DEFAULT SETTINGS
% clear enviroment
clear all;
close all;
clc;

% display format
format long g;

% example position ASAM e.V. 
% (Altlaufstraße 40, 85635 Höhenkirchen-Siegertsbrunn)
org_llh = [	48.02331, 11.71584, 584.0]; % WGS84

%% Test1 (UTM)

% create mpro
mpro.gell.nm='WGS84';   % global datum
mpro.proj.nm='UTM_32U'; % local datum

% WGS84 llh degree -> WGS84 llh radian
llh = [pi/180*org_llh(1), pi/180*org_llh(2), org_llh(3)];

% transform WGS84 llh radian -> UTM_32U
enh_utm = map_geod2pmap_tm(llh, mpro.gell, mpro.proj)

% transform UTM_32U -> WGS84 llh radian
llh = map_pmap2geod_tm(enh_utm,  mpro.gell, mpro.proj);

% WGS84 llh radian -> WGS84 llh degree
llh = [180/pi*llh(1), 180/pi*llh(2), llh(3)]

%% Test2 (GK with datum transformation)

% create mpro2
mpro2.gell.nm='WGS84';
mpro2.lell.nm='BESSELDHDN';
mpro2.proj.nm='GK3_4';
mpro2.tran.nm='HN7';     % transformation
% 7 Parameter Helmerttransformation (example for Bavaria from LDBV)
mpro2.tran.ds = -5.2379 * 0.000001;
mpro2.tran.rx = (0.7201 / 3600) * (pi / 180);
mpro2.tran.ry = (0.1112 / 3600) * (pi / 180);
mpro2.tran.rz = (-1.7209 / 3600) * (pi / 180);
mpro2.tran.tx = -604.7365;
mpro2.tran.ty = -72.3946;
mpro2.tran.tz = -424.402;
mpro2=map_check(mpro2);

% WGS84 llh degree -> WGS84 llh radian
llh = [pi/180*org_llh(1), pi/180*org_llh(2), org_llh(3)];

% transform WGS84 llh radian -> GK3 zone 4 (BESSELDHDN)
% transformation includes datum transformation, see map_global2plocal.m
enh_gk = map_global2plocal(llh, mpro2)

% transform GK3 zone 4 (BESSELDHDN) -> WGS84 llh radian
% transformation includes datum transformation, see map_global2plocal.m
llh = map_plocal2global(enh_gk, mpro2);

% WGS84 llh radian -> WGS84 llh degree
llh = [180/pi*llh(1), 180/pi*llh(2), llh(3)]


%% Test3 (GK to UTM)

% transform GK3 zone 4 (BESSELDHDN) -> WGS84 llh radian
% transformation includes datum transformation, see map_global2plocal.m
llh = map_plocal2global(enh_gk, mpro2);

% transform WGS84 llh radian -> UTM_32U
enh_utm = map_geod2pmap_tm(llh, mpro.gell, mpro.proj)

%% Test4 (NAD)
