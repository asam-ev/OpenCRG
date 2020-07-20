function [data] = crg_check(data)
% CRG_CHECK CRG check, fix, and complement data.
%   [DATA] = CRG_CHECK(DATA) checks CRG data for consistency
%   and accuracy, fixes slight accuracy problems giving some info, and
%   complements the CRG data as far as possible.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO.
%
%   Outputs:
%   DATA    is a checked, purified, and eventually completed version of
%           the function input argument DATA
%
%   Examples:
%   data = crg_check(data) checks and complements CRG data.
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

%% initialize error/warning counter

ierr = 0;

%% check opts consistency

data = crg_check_opts(data);
if ~isfield(data, 'ok')
    ierr = ierr + 1;
end

%% check mods consistency

data = crg_check_mods(data);
if ~isfield(data, 'ok')
    ierr = ierr + 1;
end

%% check head consistency

data = crg_check_head(data);
if ~isfield(data, 'ok')
    ierr = ierr + 1;
end

%% check mpro consistency

data = crg_check_mpro(data);
if ~isfield(data, 'ok')
    ierr = ierr + 1;
end

%% check data consistency

data = crg_check_data(data);
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
