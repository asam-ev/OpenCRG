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

%   Copyright 2014-2015 OpenCRG - Daimler AG - Jochen Rauh
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
%   $Id: crg_check_mpro.m 363 2015-11-09 07:26:14Z jorauh@EMEA.CORPDIR.NET $

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
