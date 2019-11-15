function [pxyz, data] = crg_eval_llh2xyz(data, pllh)
%CRG_EVAL_ENH2XYZ CRG tranform point in llh to xyz.
%   [PXYZ, DATA] = CRG_EVAL_LLH2XYZ(DATA, PLLH) transforms points given in
%   llh coordinate system to xyz coordinate system.
%
%   inputs:
%       DATA    struct array as defined in CRG_INTRO.
%       PLLH    (np, 3) array of points in llh system (GEOD global)
%
%   outputs:
%       PXYZ    (np, 3) array of points in xyz system (CRG local)
%       DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   [pxyz, data] = crg_eval_llh2xyz(data, pllh) transforms pllh points
%   given in global GEOD coordinate system to pxyz points given in CRG
%   local coordinate system.
%
%   See also CRG_INTRO, MAP_INTRO, CRG_EVAL_XYZ2LLH.

%   Copyright 2014-2015 OpenCRG - Daimler AG - Jochen Rauh
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
%   $Id: crg_eval_llh2xyz.m 369 2019-09-12 20:52:13Z jorauh@EMEA.CORPDIR.NET $

%% check if already succesfully checked

if ~isfield(data, 'ok')
    data = crg_check(data);
    if ~isfield(data, 'ok')
        error('CRG:checkError', 'check of DATA was not completely successful')
    end
end

%% check if MPRO is available

if ~isfield(data, 'mpro')
    error('CRG:evalError', 'no map projection data available')
end

%% perform transformation GEOD global -> CRG global

[penh, data.mpro] = map_global2plocal(pllh, data.mpro);

%% perform transformation CRG global -> CRG local

[pxyz, data] = crg_eval_enh2xyz(data, penh);

end
