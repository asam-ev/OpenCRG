function [phi, data] = crg_eval_u2phi(data, pu)
%CRG_U2PHI CRG evaluate heading phi in reference line u posititon.
%   [PHI, DATA] = CRG_U2PHI(DATA, PU) evaluates heading angle phi at
%   reference line u positions pu.
%
%   Inputs:
%       DATA    struct array as defined in CRG_INTRO.
%       PU      (np) vector of reference line u positions
%
%   Outputs:
%       PHI     (np) vector of heading angles
%       DATA    struct array as defined in CRG_INTRO.
%
%   Examples:
%   phi = crg_eval_u2phi(data, pu) evaluates phi at pu points.
%
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_eval_u2phi.m 
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

%% check if already succesfully checked

if ~isfield(data, 'ok')
    data = crg_check(data);
    if ~isfield(data, 'ok')
        error('CRG:checkError', 'check of DATA was not completely successful')
    end
end

%% pre-allocate output

np = length(pu);
phi = zeros(1, np);

%% straight reference line: simple setting only

if ~isfield(data, 'rx')
    phi = phi + data.head.pbeg;

    return
end

%% for closed refline: map u values to valid interval

if data.opts.rflc==1 && data.dved.ulex~=0
    pu = mod(pu-data.dved.ubex, data.dved.ulex) + data.dved.ubex;
end

%% simplify data access

uinc = data.head.uinc;
ubeg = data.head.ubeg;
pbeg = data.head.pbeg;
pend = data.head.pend;

p = data.p;
num1 = size(p, 2); % nu - 1

%% work on all points

for ip = 1:np
    iu = floor((pu(ip) - ubeg) / uinc);
    if iu < 1
        phi(ip) = pbeg;
    elseif iu > num1
        phi(ip) = pend;
    else
        phi(ip) = double(p(iu));
    end
end

end
