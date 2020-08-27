function [data] = crg_check(data)
% CRG_CHECK Run all OpenCRG data checks.
%   [DATA] = CRG_CHECK(DATA) runs all available checks for the given OpenCRG data.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO.
%
%   Outputs:
%   DATA    is a checked, cleaned-up, and potentially completed version of
%           the input DATA.
%
%   Examples:
%   data = crg_check(data)
%   Runs all checks on data.
%
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_check.m 
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

%% initialize error counter

ierr = 0;

%% check options for consistency

data = crg_check_opts(data);
if ~isfield(data, 'ok')
    ierr = ierr + 1;
end

%% check modifiers for consistency

data = crg_check_mods(data);
if ~isfield(data, 'ok')
    ierr = ierr + 1;
end

%% check head consistency

data = crg_check_head(data);
if ~isfield(data, 'ok')
    ierr = ierr + 1;
end

%% check data consistency

data = crg_check_data(data);
if ~isfield(data, 'ok')
    ierr = ierr + 1;
end

%% check map projection data consistency

data = crg_check_mpro(data);
if ~isfield(data, 'ok')
    ierr = ierr + 1;
end

%% check mapping consistency

data = crg_check_wgs84(data);
if ~isfield(data, 'ok')
    ierr = ierr + 1;
end

%% check core data type

data = crg_check_single(data);
if ~isfield(data, 'ok')
    ierr = ierr + 1;
end

%% set ok-flag

if ierr == 0
    data.ok = 0;
else
    warning('CRG:checkWarning', 'check of DATA was not completely successful')
    if isfield(data, 'ok')
        data = rmfield(data, 'ok');
    end
end

end
