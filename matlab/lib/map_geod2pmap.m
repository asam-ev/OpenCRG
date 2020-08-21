function [enh ell pro] = map_geod2pmap(llh, ell, pro)
% MAP_GEOD2PMAP Forward map projection.
%   [ENH ELL PRO] = MAP_GEOD2PMAP_TM(LLH, ELL, PRO) converts points from
%   geodetic coordinates to map coordinates using a forward projection.
%
%   Inputs:
%   LLH     (n, 3) array of points in GEOD system
%   ELL     optional ELLI struct array
%   PRO     opt. PROJ struct array
%
%   Outputs:
%   ENH     (n, 3) array of points in PMAP system
%   ELL     ELLI struct array
%   PRO     PROJ struct array
%
%   Examples:
%   enh = map_geod2pmap_tm(llh, ell, pro)
%       Converts points from geodetic to map coordinates.
%
%   See also MAP_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             map_geod2pmap_tm.m 
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

%% check and complement inputs

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



