function [pllh, data] = crg_eval_xyz2llh(data, pxyz)
%CRG_EVAL_XYZ2LLH CRG tranform point in xyz to llh.
%   [PLLH, DATA] = CRG_EVAL_XYZ2LLH(DATA, PXYZ) transforms points given in
%   xyz CRG coordinate system to llh GEOD coordinate system.
%
%   inputs:
%       DATA    struct array as defined in CRG_INTRO.
%       PXYZ    (np, 3) array of points in xyz system (CRG local)
%
%   outputs:
%       PLLH    (np, 3) array of points in llh system (GEOD global)
%       DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   [pllh, data] = crg_eval_xyz2llh(data, pxyz) transforms pxyz points
%   given in local CRG coordinate system to pllh points given in GEOD
%   global coordinate system.
%
%   See also CRG_INTRO, MAP_INTRO, CRG_EVAL_LLH2XYZ.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_eval_xyz2llh.m 
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

%% perform transformation CRG local -> CRG global

[penh, data] = crg_eval_xyz2enh(data, pxyz);

%% perform transformation CRG global -> GEOD global

[pllh, data.mpro] = map_plocal2global(penh, data.mpro);

end
