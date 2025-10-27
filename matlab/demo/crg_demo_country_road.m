%% CRG_DEMO_COUNTRY_ROAD
% Load and visualize country_road.crg demo road.

% *****************************************************************
% See the NOTICE file distributed with this work regarding copyright ownership.
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%    https://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
% 
% More Information on ASAM OpenCRG can be found here:
% https://www.asam.net/standards/detail/opencrg/
%
% *****************************************************************

%% clear enviroment

clear all
close all

%% load demo road

crg = crg_read('../../crg-bin/country_road.crg');

%% visualize road

crg = crg_show(crg);

crg_wgs84_crg2html(crg, 'country_road.html');
web('country_road.html', '-browser');
