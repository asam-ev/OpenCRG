function [pxyz, data] = crg_eval_llh2xyz(data, pllh)
%CRG_EVAL_ENH2XYZ CRG tranform point in llh to xyz.
%   [PXYZ, DATA] = CRG_EVAL_LLH2XYZ(DATA, PLLH) transforms points given in
%   llh coordinate system to xyz coordinate system.
%
%   inputs:
%       DATA    struct array as defined in CRG_INTRO.
%       PLLH    (np, 3) array of points in llh system (GEOD global)
%
%   outputs:
%       PXYZ    (np, 3) array of points in xyz system (CRG local)
%       DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   [pxyz, data] = crg_eval_llh2xyz(data, pllh) transforms pllh points
%   given in global GEOD coordinate system to pxyz points given in CRG
%   local coordinate system.
%
%   See also CRG_INTRO, MAP_INTRO, CRG_EVAL_XYZ2LLH.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_eval_llh2xyz.m 
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

%% check if MPRO is available

if ~isfield(data, 'mpro')
    error('CRG:evalError', 'no map projection data available')
end

%% perform transformation GEOD global -> CRG global

[penh, data.mpro] = map_global2plocal(pllh, data.mpro);

%% perform transformation CRG global -> CRG local

[pxyz, data] = crg_eval_enh2xyz(data, penh);

end
