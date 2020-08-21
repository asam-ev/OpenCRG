function [pz, data] = crg_eval_xy2z(data, pxy)
%CRG__EVAL_XY2Z CRG evaluate z at position xy.
%   [PZ, DATA] = CRG_EVAL_XY2Z(DATA, PXY) evaluates the z-values at
%   the given x/y-positions. This function combines the calls of
%   CRG_EVAL_XY2UV and CRG_EVAL_UV2Z.
%
%   inputs:
%       DATA    struct array as defined in CRG_INTRO.
%       PXY     (np, 2) array of points in xy system
%
%   outputs:
%       PZ      (np) vector of z values
%       DATA    struct array as defined in CRG_INTRO, with history added
%
%   Examples:
%   [pz, data] = crg_eval_xy2z(data, pxy)
%       Evaluates the z-values at the given x/y-positions.
%
%   See also CRG_EVAL_XY2UV, CRG_EVAL_UV2Z, CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_eval_xy2z.m 
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

%% just do it

[puv, data] = crg_eval_xy2uv(data, pxy);
[pz , data] = crg_eval_uv2z (data, puv);

end
