function [enh ell pro] = map_geod2pmap(llh, ell, pro)
% MAP_GEOD2PMAP MAP forward projection.
%   [ENH ELL PRO] = MAP_GEOD2PMAP_TM(LLH, ELL, PRO) converts points from
%   GEOD to PMAP system using a forward projection.
%
%   Inputs:
%   LLH     (n, 3) array of points in GEOD system
%   ELL     opt. ELLI struct array
%   PRO     opt. PROJ struct array
%
%   Outputs:
%   ENH     (n, 3) array of points in PMAP system
%   ELL     ELLI struct array
%   PRO     PROJ struct array
%
%   Examples:
%   enh = map_geod2pmap_tm(llh, ell, pro)
%       converts points from GEOD to PMAP system.
%
%   See also MAP_INTRO.

%   Copyright 2013-2014 OpenCRG - Daimler AG - Jochen Rauh
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
%   $Id: map_geod2pmap_tm.m 306 2012-12-11 07:38:12Z jorauh $

%% check/complement inputs

% PRO
if nargin < 3
    pro = [];
end
pro = map_check_proj(pro);

% ELL
if nargin < 2
    ell = [];
end
ell = map_check_elli(ell);

%% apply projection

if ~isempty(nm)
    a = regexp([upper(nm) '_'], '_', 'split');
    nm = a{1};
end

if ~isempty(nm)
    switch nm
        case 'GK3' % Gauss-Krueger 3deg zones
            [enh ell pro] = map_geod2pmap_tm(llh, ell, pro);
        case 'GK6' % Gauss-Krueger 6deg zones
            [enh ell pro] = map_geod2pmap_tm(llh, ell, pro);
        case 'UTM' % Universal Transverse Mercator
            [enh ell pro] = map_geod2pmap_tm(llh, ell, pro);
        otherwise
            error('MAP:checkError', 'unknown projection name %s', nm)
    end
end



