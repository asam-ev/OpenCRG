function [iu, iv] = crg_eval_uv2iuiv(data, u, v)
%CRG_UV2IUIV Evaluate index position of grid positions.
%   [IU, IV] = CRG_UV2IUIV(DATA, U, V) Evaluate the index positions
%   of the given u/v-positions.
%
%   Inputs:
%       DATA    struct array as defined in CRG_INTRO.
%       U       (np, 1) array of u-values in u/v-system
%       V       (np, 1) array of v-values in u/v-system
%
%   Outputs:
%       IU      (np, 1) array of u-index positions in u/v-system
%       IV      (np, 1) array of v-index positions in u/v-system
%
%   Examples:
%   [iu, iv] = crg_eval_uv2iuiv(data, u, v)
%       Transforms u/v-positions to index positions, so that the range of u,v is
%       always included.
%       The index positions are clipped to 1 and length(u) or length(v).
%
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_eval_uv2iuiv.m 
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

%% for closed reference line: map u-values to valid interval

if data.opts.rflc==1 && data.dved.ulex~=0
    u = mod(u-data.dved.ubex, data.dved.ulex) + data.dved.ubex;
end

%% simplify data access

[nu, nv] = size(data.z);

ubeg = data.head.ubeg;
uinc = data.head.uinc;

if isfield(data.head, 'vinc')
    vmin = data.head.vmin;
    vmax = data.head.vmax;
    vinc = data.head.vinc;
else
    vmin = data.head.vmin;
    vmax = data.head.vmax;
end

%% find u-index positions iu

iu = max((u-ubeg)./uinc, 0);
iu = min(floor(iu+1), nu);

%% find v-index positions iv

if ~exist('v','var'), return; end

if isfield(data.head, 'vinc')
    iv = max((v-vmin)./vinc, 0);
    iv = min(floor(iv+1), nv);
else
    iv = max(v, vmin);
    iv = min(iv, vmax);
    for i = 1:length(iv)
        idx = max(find(data.v <= iv(i), 1, 'last'), 1);
        if isempty(idx)
            iv(i) = 1;
        else
            iv(i) = idx;
        end
    end
end

end %function crg_eval_uv2iuiv
