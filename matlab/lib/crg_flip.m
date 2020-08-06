function [data] = crg_flip(data)
% CRG_FLIP flip CRG data structure.
%   DATA = CRG_FLIP(DATA) flips a CRG data structure, i.e. swaps start
%   and end, while leaving the mods and opts sub-structures untouched.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO.
%
%   Outputs:
%   DATA    struct array as defined in CRG_INTRO.
%
%   Examples:
%   crg = crg_flip(crg)
%       flips the CRG contents.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_flip.m 
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


data = crg_check(data);
if ~isfield(data, 'ok')
    error('CRG:checkError', 'check of DATA was not completely successful')
end

%% keep everything

dat0 = data;

%% flip elevation grid

data.z = dat0.z(end:-1:1, end:-1:1);


%% flip vectors

if length(dat0.v) > 1
    data.v = -dat0.v(end:-1:1);
end
if isfield(dat0, 'p')
    data.p = angle(-exp(i*dat0.p(end:-1:1)));
end
if isfield(dat0, 's')
    data.s = -dat0.s(end:-1:1);
end
if isfield(dat0, 'b')
    data.b = -dat0.b(end:-1:1);
end

%% flip head data

data.head.vmin = -dat0.head.vmax;
data.head.vmax = -dat0.head.vmin;

data.head.xbeg = dat0.head.xend;
data.head.ybeg = dat0.head.yend;
data.head.zbeg = dat0.head.zend;
data.head.xend = dat0.head.xbeg;
data.head.yend = dat0.head.ybeg;
data.head.zend = dat0.head.zbeg;

data.head.sbeg = -dat0.head.send;
data.head.send = -dat0.head.sbeg;

data.head.bbeg = -dat0.head.bend;
data.head.bend = -dat0.head.bbeg;

data.head.pbeg = angle(-exp(i*dat0.head.pend));
data.head.pend = angle(-exp(i*dat0.head.pbeg));

% WGS84: beg or beg/end allowed, end only not allowed
if isfield(dat0.head, 'eend')
    data.head.ebeg = dat0.head.eend;
    data.head.nbeg = dat0.head.nend;
    if isfield(dat0.head, 'ebeg')
        data.head.eend = dat0.head.ebeg;
        data.head.nend = dat0.head.nbeg;
    else
        warning('crg:flipWarning', 'WGS84 start lon/lat removed')
    end
end
if isfield(dat0.head, 'aend')
    data.head.abeg = dat0.head.aend;
    if isfield(dat0.head, 'abeg')
        data.head.aend = dat0.head.abeg;
    else
         warning('crg:flipWarning', 'WGS84 start altitude removed')
    end
end

%% add timestamp

if ~isfield(data, 'struct')
    data.struct = cell(1,0);
end
data.struct{end+1} = ...
    sprintf('* flipped by %s at %s', mfilename, datestr(now, 31));

%% check again

data = crg_check(data);

end
