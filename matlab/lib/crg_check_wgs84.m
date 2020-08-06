function [data] = crg_check_wgs84(data)
% CRG_CHECK_WGS84 CRG check wgs84 data consistency.
%   [DATA] = CRG_CHECK_WGS84(DATA) checks CRG wgs84 data for consistency
%   of definitions and values.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO.
%
%   Outputs:
%   DATA    is a checked, purified, and eventually completed version of
%           the function input argument DATA
%
%   Examples:
%   data = crg_check_wgs84(data) checks CRG wgs84 data consistency.
%
%   See also CRG_CHECK, CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_check_wgs84.m 
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

%% remove ok flag, initialize error/warning counter

if isfield(data, 'ok')
    data = rmfield(data, 'ok');
end
ierr = 0;

%% some local variables

crgeps = data.opts.ceps;
crgtol = data.opts.ctol;
crgpro = data.opts.cpro;
crgwgs = data.opts.cwgs;

%% check for mpro field

if isfield(data, 'mpro')
    % add consistent start definitions (we already checked for existing pairs in crg_check_head)
    if ~isfield(data.head, 'ebeg') || ~isfield(data.head, 'abeg') % add missing (ebeg, nbeg) pair and/or abeg
        data.ok = 0; % add ok flag to prevent checking
        llh = crg_eval_xyz2llh(data, [data.head.xbeg data.head.ybeg data.head.zbeg]);
        data = rmfield(data, 'ok'); % remove ok flag
        
        if ~isfield(data.head, 'ebeg')
            data.head.nbeg = 180/pi*llh(1);
            data.head.ebeg = 180/pi*llh(2);
        end
        
        if ~isfield(data.head, 'abeg')
            data.head.abeg = llh(3);
        end
    end
    
    % add consistent end definitions (we already checked for existing pairs in crg_check_head)
    if ~isfield(data.head, 'eend') || ~isfield(data.head, 'aend') % add missing (eend, nend) pair and/or aend
        data.ok = 0; % add ok flag to prevent checking
        llh = crg_eval_xyz2llh(data, [data.head.xend, data.head.yend, data.head.zend]);
        data = rmfield(data, 'ok'); % remove ok flag
        
        if ~isfield(data.head, 'eend')
        data.head.nend = 180/pi*llh(1);
        data.head.eend = 180/pi*llh(2);
        end
        
        if ~isfield(data.head, 'aend')
            data.head.aend = llh(3);
        end
    end

    % check consistent start definitions
    data.ok = 0; % add ok flag to prevent checking
    xyz = crg_eval_llh2xyz(data, [pi/180*data.head.nbeg pi/180*data.head.ebeg data.head.abeg]);
    data = rmfield(data, 'ok'); % remove ok flag
    
    if norm(xyz - [data.head.xbeg data.head.ybeg data.head.zbeg]) > crgpro
        warning('CRG:checkWarning', 'inconsistent definition of header data "reference_line_start_x/y/z" and "reference_line_start_lon/lat/alt"')
        ierr = 1;
    end
    
   % check consistent end definitions
    data.ok = 0; % add ok flag to prevent checking
    xyz = crg_eval_llh2xyz(data, [pi/180*data.head.nend pi/180*data.head.eend data.head.aend]);
    data = rmfield(data, 'ok'); % remove ok flag
    
    if norm(xyz - [data.head.xend data.head.yend data.head.zend]) > crgpro
        warning('CRG:checkWarning', 'inconsistent definition of header data "reference_line_end_x/y/z" and "reference_line_end_lon/lat/alt"')
        ierr = 1;
    end
    
else
    %% check for consistent start/end distance (we already checked for existing start and pairs in crg_check_head)
    
    % local rectangular coordinate system <> WGS84 world geodetic system
    if isfield(data.head, 'eend')
        dxy = sqrt((data.head.xend-data.head.xbeg)^2 + (data.head.yend-data.head.ybeg)^2);
        dll = crg_wgs84_dist([data.head.nbeg data.head.ebeg], [data.head.nend data.head.eend]);
        if abs(dxy-dll) > max(crgeps*(dxy+dll)/2, crgwgs)
            warning('CRG:checkWarning', 'inconsistent distance definition of header data "reference_line_start/end_x/y" and "reference_line_start/end_lon/lat"')
            ierr = 1;
        end
    end 
end

%% check for consistent altitude definitions (we already checked for existing start in crg_check_head)

% local rectangular coordinate system <> WGS84 world geodetic system
if isfield(data.head, 'aend')
    dxy = data.head.zend - data.head.zbeg;
    dll = data.head.aend - data.head.abeg;
    if dxy*dll < -crgtol^2 || abs(dxy-dll) > max(crgeps*abs(dxy+dll)/2, crgtol)
        warning('CRG:checkWarning', 'inconsistent definition of header data "reference_line_start/end_z" and "reference_line_start/end_alt"')
        ierr = 1;
    end
end


%% set ok-flag

if ierr == 0
    data.ok = 0;
end

end
