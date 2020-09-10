function [crv, data] = crg_eval_u2crv(data, pu)
%CRG_U2PHI Evaluate curvature at reference line posititons.
%   [CRV, DATA] = CRG_U2CRV(DATA, PU) evaluates the curvature at
%   given u-positions.
%
%   Inputs:
%       DATA    struct array as defined in CRG_INTRO.
%       PU      (np) vector of reference line u-positions
%
%   Outputs:
%       CRV     (np) vector of curvature values
%       DATA    struct array as defined in CRG_INTRO.
%
%   Examples:
%   crv = crg_eval_u2crv(data, pu)
%       Evaluates the curvature at u-positions.
%
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_eval_u2crv.m 
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

%% check if already successfully checked

if ~isfield(data, 'ok')
    data = crg_check(data);
    if ~isfield(data, 'ok')
        error('CRG:checkError', 'check of DATA was not completely successful')
    end
end

%% pre-allocate output

np = length(pu);
crv = zeros(1, np);

%% straight reference line: simple setting only

if ~isfield(data, 'rc')
      return
end

%% for closed reference line: map u-values to valid interval

if data.opts.rflc==1 && data.dved.ulex~=0
    pu = mod(pu-data.dved.ubex, data.dved.ulex) + data.dved.ubex;
end

%% simplify data access

uinc = data.head.uinc;
ubeg = data.head.ubeg;

rc = data.rc;
num2 = size(rc, 2); % nu - 2

%% work on all points

for ip = 1:np
    iu = floor((pu(ip) - ubeg) / uinc);
    if iu < 1
        crv(ip) = 0;
    elseif iu > num2
        crv(ip) = 0;
    else
        crv(ip) = rc(iu);
    end
end

end
