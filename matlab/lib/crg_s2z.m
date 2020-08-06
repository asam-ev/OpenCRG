function [data] = crg_s2z(data, rz)
% CRG_S2Z separates slope from elevation grid.
%   CRG_S2Z(DATA, RZ) separates slope defined by refline elevation profile
%   from elevation grid.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO
%   RZ      (optional) refline elevation profile (default: (zbeg+zend)/2)
%           length(rz) == 1: no slope
%           length(rz) == 2: constant slope
%           length(rz) == nu: variable slope
%
%   Outputs:
%   DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   crg = crg_s2z(crg)
%       merges existing slope information into the elevation grid.
%   crg = crg_s2z(crg, [crg.head.zbeg crg.head.zend])
%       separates constant slope from elevation grid
%   crg = crg_s2z(crg, rz)
%       separates slope defined by refline elevation profile.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_s2z.m 
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

%% evaluate DATA.z size

[nu] = size(data.z,1);

%% handle optional args

if nargin < 2
    rz = (data.head.zbeg + data.head.zend) / 2;
end

if length(rz)~=1 && length(rz)~=2 && length(rz)~=nu
    error('CRG:s2zError', 'illegal size of rz')
end

if length(rz) ~= nu
    rz = linspace(rz(1), rz(end), nu);
end

%% get old rz

if isfield(data, 'rz')
    rzold = data.rz;
else
    rzold = linspace(data.head.zbeg, data.head.zend, nu);
end

%% set new slope

s = diff(rz) / data.head.uinc;

data.head.sbeg = s(1);
data.head.send = s(end);

data.s = single(s);

data.head.zbeg = rz(1);
data.head.zend = rz(end);

%% adjust altitude

if isfield(data.head, 'abeg')
    data.head.abeg = data.head.abeg + rz(1) - rzold(1);
    data.head.aend = data.head.abeg + (rz(end)-rz(1));
end

%% apply refline elevation profile

for i = 1:nu
    data.z(i,:) = single(double(data.z(i,:)) + (rzold(i) - rz(i)));
end

%% check data

data = crg_check(data);
if ~isfield(data, 'ok')
    error('CRG:checkError', 'check of DATA was not completely successful')
end

end
