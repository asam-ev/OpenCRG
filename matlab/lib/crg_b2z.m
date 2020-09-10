function [data] = crg_b2z(data, b)
% CRG_B2Z Apply banking to OpenCRG data.
%   CRG_B2Z(DATA, B) applies new banking to an OpenCRG struct. Existing 
%   banking data is merged into the road data.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO
%   B       (optional) new banking (default: 0)
%           length(b) == 1: constant banking
%           length(b) == nu: variable banking
%
%   Outputs:
%   DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   crg = crg_b2z(crg)
%       Merges existing banking information into the elevation grid.
%   crg = crg_b2z(crg, 0.03)
%       Apply a 3.0% banking from the elevation grid
%   crg = crg_b2z(crg, b)
%       Apply banking defined by b from the elevation grid.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_b2z.m 
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

%% evaluate DATA.z size

[nu] = size(data.z,1);

%% handle optional arguments

if nargin < 2 || isempty(b)
    b = 0;
end

if length(b)~=1 && length(b)~=nu
    error('CRG:b2zError', 'illegal size of B')
end

%% build full v-vector

if isfield(data.head, 'vinc')
    vmin = data.head.vmin;
    vmax = data.head.vmax;
    vinc = data.head.vinc;
    v = vmin:vinc:vmax;
else
    v = double(data.v);
end

%% get old banking

if isfield(data, 'b')
    if length(data.b) == 1
        bold = data.head.bbeg*ones(1, nu);
    else
        bold = double(data.b);
    end
else
    bold = zeros(1, nu);
end

%% set new banking

data.head.bbeg = b(1);
data.head.bend = b(end);

data.b = single(b);

if length(b) == 1
    bnew = data.head.bbeg*ones(1, nu);
else
    bnew = double(data.b);
end

%% apply new banking

for i = 1:nu
    zd = (bold(i)-bnew(i)) .* v;
    data.z(i,:) = single(double(data.z(i,:)) + zd);
end

%% check data

data = crg_check(data);
if ~isfield(data, 'ok')
    error('CRG:checkError', 'check of DATA was not completely successful')
end

end
