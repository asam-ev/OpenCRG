function [data] = crg_check_single(data)
%CRG_CHECK_SINGLE Check core OpenCRG data for type single.
%   [DATA] = CRG_CHECK_SINGLE(DATA) checks whether OpenCRG data in core data 
%   vectors and arrays is of type single.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO.
%
%   Outputs:
%   DATA    input DATA with unchanged contents.
%
%   Examples:
%   data = crg_check_single(data);
%       Checks CRG core data for single type.
%
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_check_single.m 
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

%% check core vectors and arrays for single type

% core elevation grid data
if isfield(data, 'z') && ~isa(data.z, 'single')
    warning('CRG:checkWarning', 'non-single type of core DATA.z')
    ierr = ierr + 1;
end
if isfield(data, 'v') && ~isa(data.v, 'single')
    warning('CRG:checkWarning', 'non-single type of core DATA.v')
    ierr = ierr + 1;
end
if isfield(data, 'b') && ~isa(data.b, 'single')
    warning('CRG:checkWarning', 'non-single type of core DATA.b')
    ierr = ierr + 1;
end

% core reference line data
if isfield(data, 'u') && ~isa(data.u, 'single')
    warning('CRG:checkWarning', 'non-single type of core DATA.u')
    ierr = ierr + 1;
end
if isfield(data, 'p') && ~isa(data.p, 'single')
    warning('CRG:checkWarning', 'non-single type of core DATA.p')
    ierr = ierr + 1;
end
if isfield(data, 's') && ~isa(data.s, 'single')
    warning('CRG:checkWarning', 'non-single type of core DATA.s')
    ierr = ierr + 1;
end

%% set ok-flag

if ierr == 0
    data.ok = 0;
end

end
