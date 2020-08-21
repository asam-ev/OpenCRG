function [pro] = map_check_proj(pro)
% MAP_CHECK_PROJ Check and update map projection struct.
%   [PRO] = MAP_CHECK_PROJ(PRO, LOC) checks and updates map projection struct.
%%
%   Inputs:
%   PRO     projection name or PROJ struct 
%
%   Outputs:
%   PRO     PROJ struct
%
%   Examples:
%   pro = map_check_proj(pro)
%       checks and updates PROJ struct.
%
%   See also MAP_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             map_check_proj.m 
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

if nargin < 1, pro = []; end
if isempty(pro), pro = struct; end

nm = '';
if ischar(pro)
    nm = pro;
else
    if isfield(pro, 'nm'), nm = pro.nm; end
end

if isempty(nm)
    error('MAP:checkError', 'undefined projection identifier')
end

a = regexp([upper(nm) '_'], '_', 'split');
nm = a{1};
zone = a{2};

switch nm
    case 'GK3' % Gauss-Krueger 3deg zones
        if isempty(zone)
            error('MAP:checkError', 'missing GK3 projection zone number')
        end
        z = str2double(zone);
        if ~isreal(z) || isnan(z) || (floor(z)~=z) || (z<0) || (z>119)
            error('MAP:checkError', 'illegal GK3 projection zone number %s', zone)
        end
        
        zone = sprintf('%3.3d', z);
        
        f0 = 1;
        p0 = 0;
        l0 = pi/180 * 3*z;
        e0 = 1000000*z + 500000;
        n0 = 0;
    case 'GK6' % Gauss-Krueger 6deg zones (Asia and Eastern Europe)
        if isempty(zone)
            error('MAP:checkError', 'missing GK6 projection zone number')
        end
        z = str2double(zone);
        if ~isreal(z) || isnan(z) || (floor(z)~=z) || (z<0) || (z>59)
            error('MAP:checkError', 'illegal GK6 projection zone number %s', zone)
        end
        
        zone = sprintf('%2.2d', z);
        
        f0 = 1;
        p0 = 0;
        l0 = pi/180 * (6*z - 3);
        e0 = 1000000*z + 500000;
        n0 = 0;
    case 'UTM' % Universal Transverse Mercator
        if isempty(zone)
            error('MAP:checkError', 'missing UTM grid zone designator')
        end
        if length(zone)<2
            error('MAP:checkError', 'illegal UTM grid zone designator %s', zone)
        end
        b = strfind('CCCDEFGHJKLMNPQRSTUVWXXX', zone(end:end));
        % <13: C...M (southern hemisphere)
        % A, B, Y, Z omitted (pole regions, need stereographic projection)
        if isempty(b)
            error('MAP:checkError', 'illegal UTM grid zone band letter %s', zone(end:end))
        end
        z = str2double(zone(1:end-1));
        if ~isreal(z) || isnan(z) || (floor(z)~=z) || (z<1) || (z>60)
            error('MAP:checkError', 'illegal UTM grid zone number %s', zone(1:end-1))
        end
        
        zone = sprintf('%2.2d%s', z, zone(end:end));
        
        f0 = 0.9996;
        p0 = 0;
        l0 = pi/180 * (6*z - 183);
        e0 = 500000;
        if b < 13
            n0 = 10000000; % southern hemispere
        else
            n0 = 0; % northern hemisphere
        end
    case 'TM' % Transverse Mercator
        f0 = 1; if isfield(pro, 'f0'), f0 = pro.f0; end
        p0 = 0; if isfield(pro, 'p0'), p0 = pro.p0; end
        l0 = 0; if isfield(pro, 'l0'), l0 = pro.l0; end
        e0 = 0; if isfield(pro, 'e0'), e0 = pro.e0; end
        n0 = 0; if isfield(pro, 'n0'), n0 = pro.n0; end
        
        if ~isempty(zone)
            z = str2double(zone);
            if ~isreal(z) || isnan(z) || (floor(z)~=z) || (z<0) || (z>359)
                error('MAP:checkError', 'illegal projection center meridian %s', zone)
            end
            
            zone = sprintf('%3.3d', z);
            
            l0 = pi/180 * z;
        end
    otherwise
        error('MAP:checkError', 'unknown projection identifier %s', nm)
end

l0 = angle(exp(1i*l0));

%% compose output struct

pro = struct;

if isempty(zone)
    pro.nm = nm;
else
    pro.nm = [nm '_' zone];
end

pro.f0 = f0;
pro.p0 = p0;
pro.l0 = l0;
pro.e0 = e0;
pro.n0 = n0;

end