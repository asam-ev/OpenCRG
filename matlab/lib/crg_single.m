function [data] = crg_single(data)
%CRG_SINGLE Convert OpenCRG road data to type single.
%   [DATA] = CRG_SINGLE(DATA) converts OpenCRG road data to type
%   single.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO.
%
%   Outputs:
%   DATA    input DATA with road data converted to type single.
%
%   Examples:
%   data = crg_single(data); 
%       Converts CRG road data to type single.
%
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_single.m 
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


%% convert core vectors and arrays to type single

% core elevation grid data
if isfield(data, 'z'), data.z = single(data.z); end
if isfield(data, 'v'), data.v = single(data.v); end
if isfield(data, 'b'), data.b = single(data.b); end

% core reference line data
if isfield(data, 'u'), data.u = single(data.u); end
if isfield(data, 'p'), data.p = single(data.p); end
if isfield(data, 's'), data.s = single(data.s); end

end
