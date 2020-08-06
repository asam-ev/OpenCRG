function [] = crg_demo_gen_syntheticStraight()
% CRG_DEMO_GEN_SYNTHETICSTRAIGHTREFLINE CRG demo to generate a synthtec straigth crg file.
%   CRG_DEMO_GEN_SYNTHETICSTRAIGHT() demonstrates how a simple straight crg file can be
%   generated.
%
%   Example:
%   crg_demo_gen_syntheticStraight    runs this demo to generate "simpleStraight.crg"
%
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               demo
% file name:             crg_demo_gen_syntheticStraight.m
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

%% default settings

u =   [  0    900   ];
v =   [ -2.50   2.5 ];
inc = [  0.04   0.02];

filename = 'simpleStraight.crg';
ct = 'CRG generated file';

%% generate synthetical straight crg file

data = crg_gen_csb2crg0(inc, u, v);

%% add z-values

[nu nv] = size(data.z);

z = 0.01*peaks(nv);
z = repmat(z, ceil(nu/nv), 1);

data.z(1:nu,:) = single(z(1:nu,:));

%% write to file

data.ct{1} = ct;
crg_write(data, filename);

%% display result

crg_show(data);

end
