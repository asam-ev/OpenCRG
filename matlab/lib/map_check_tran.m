function [tran] = map_check_tran(tran)
% MAP_CHECK_TRAN MAP check and update TRAN struct.
%   [TRAN] = MAP_CHECK_TRAN(TRAN) checks and updates TRAN struct.
%%
%   Inputs:
%   TRAN    opt. transformation name or TRAN struct
%
%   Outputs:
%   TRAN    TRAN struct
%
%   Examples:
%   tran = map_check_tran(tran)
%       checks and updates TRAN struct.
%
%   See also MAP_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             map_check_tran.m 
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

if nargin < 1, tran = []; end
if isempty(tran), tran = struct; end

nm = '';
if ischar(tran)
    nm = tran;
else
    if isfield(tran, 'nm'), nm = tran.nm; end
end

if isempty(nm)
    nm = 'NOP'; % default
else
    nm = upper(nm);
end

switch nm
    case 'NOP' % no transformation (default)
    case 'HL7' % 7 parameter linear Helmert transformation
    case 'HN7' % 7 parameter nonlin Helmert transformation
    case 'HS7' % 7 parameter simple Helmert transformation
    otherwise
        error('MAP:checkError', 'unknown transformation name %s', nm)
end

switch nm
    case {'HL7','HN7','HS7'}
        ds = 0; if isfield(tran, 'ds'), ds = tran.ds; end
        rx = 0; if isfield(tran, 'rx'), rx = tran.rx; end
        ry = 0; if isfield(tran, 'ry'), ry = tran.ry; end
        rz = 0; if isfield(tran, 'rz'), rz = tran.rz; end
        tx = 0; if isfield(tran, 'tx'), tx = tran.tx; end
        ty = 0; if isfield(tran, 'ty'), ty = tran.ty; end
        tz = 0; if isfield(tran, 'tz'), tz = tran.tz; end
end

%% compose output struct

tran = struct;

tran.nm = nm;

switch nm
    case {'HL7','HN7','HS7'}
        tran.ds = ds;
        tran.rx = rx;
        tran.ry = ry;
        tran.rz = rz;
        tran.tx = tx;
        tran.ty = ty;
        tran.tz = tz;
end

end