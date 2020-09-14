function [ell] = map_check_elli(ell)
% MAP_CHECK_ELLI Check and update ellipsoid struct.
%   [ELL] = MAP_CHECK_ELLI(ELL) checks and updates the ellipsoid struct.
%
%   Inputs:
%   ELL     optional ellipsoid name (default: 'WGS84') or ELLI struct 
%
%   Outputs:
%   ELL     ELLI struct
%
%   Examples:
%   ell = map_check_elli(ell)
%       Checks and updates ELLI struct.
%
%   See also MAP_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             map_check_elli.m 
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

%%

if nargin < 1, ell = []; end
if isempty(ell), ell = struct; end

nm = '';
if ischar(ell)
    nm = ell;
else
    if isfield(ell, 'nm'), nm = ell.nm; end
end

if isempty(nm)
    if isfield(ell, 'a')
        nm = 'USERDEFINED';
    else
        nm = 'WGS84'; % default
    end
else
    nm = upper(nm);
end

switch nm % EPSG data retrieved 2012-11-01 http://www.epsg-registry.org
    case 'AIRY1830' % EPSG::7001
        a = 6377563.396;
        b = a*(1 - 1/299.3249646);
    case 'AIRYMODIFIED1849' % EPSG::7002
        a = 6377340.189;
        b = a*(1 - 1/299.3249646);
    case 'BESSEL1841' % EPSG::7004
        a = 6377397.155;
        b = a*(1 - 1/299.1528128);
    case 'BESSELMODIFIED' % EPSG::7005
        a = 6377492.018;
        b = a*(1 - 1/299.1528128);
    case 'BESSELNAMIBIAGLM' % EPSG::7046
        a = 6377483.865;
        b = a*(1 - 1/299.1528128);
    case 'BESSELDHDN' % Wasmeier
        a = 6377397.155;
        b = a*(1 - 1/299.1528154);
    case 'CLARKE1866' % EPSG::7008
        a = 6378206.4;
        b = 6356583.8;
    case 'CLARKE1866AUTHALICSPHERE' % EPSG::7052
        a = 6370997;
        b = 6370997;
    case 'CLARKE1880IGN' % EPSG::7011
        a = 6378249.2;
        b = 6356515;
    case 'GRS1980' % EPSG::7019
        a = 6378137;
        b = a*(1 - 1/298.257222101);
    case 'GRS1980AUTHALICSPHERE' % EPSG::7048
        a = 6371007;
        b = 6371007;
    case 'INTERNATIONAL1924' % EPSG::7022
        a = 6378388;
        b = a*(1 - 1/297);
    case 'INTERNATIONAL1924AUTHALICSPHERE' % EPSG::7057
        a = 6371228;
        b = 6371228;
    case 'KRASSOWSKY1940' % EPSG::7024
        a = 6378245;
        b = a*(1 - 1/298.3);
    case 'WGS84' % EPSG::7030
        a = 6378137;
        b = a*(1 - 1/298.257223563);       
    case 'USERDEFINED'
        if isfield(ell, 'a')
            a = ell.a;
            if isfield(ell, 'b')
                b = ell.b;
            else
                b = a;
            end
        else
            error('MAP:checkError', 'undefined ellipsoid semi-major axis')
        end
    otherwise
        error('MAP:checkError', 'unknown ellipsoid name %s', nm)
end

%% compose output struct

ell = struct;

ell.nm = nm;

ell.a = a;
ell.b = b;

end