function [data] = crg_check_mpro(data)
% CRG_CHECK_MPRO CRG check mpro data.
%   [DATA] = CRG_CHECK_MPRO(DATA) checks CRG mpro data for consistency
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
%   data = crg_check_mpro(data) checks CRG mapping projection data.
%
%   See also CRG_CHECK, CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_check_mpro.m 
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

%% check for mpro field

if isfield(data, 'mpro')
    try
        data.mpro = map_check(data.mpro);
    catch exception
        getReport(exception)
        warning('CRG:checkWarning', 'inconsistent or illegal map projection data')
        ierr = 1;
    end
end


%% set ok-flag

if ierr == 0
    data.ok = 0;
end

end
