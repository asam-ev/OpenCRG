function [sdf_out] = sdf_add(sdf_in, blockname, sdf_block)
% SDF_ADD SDF (structured data file) block add.
%   [SDF_OUT] = SDF_CUT(SDF_IN, BLOCKNAME) adds block to SDF
%
%   Inputs:
%   SDF_IN      cell array of struct data file lines
%   BLOCKNAME   name of block to add
%   SDF_BLOCK   cell array of struct data lines of named block
%
%   Output:
%   SDF_OUT     cell array of resulting struct data lines
%
%   Example:
%   sdf_out = sdf_add(sdf_in, blockname, sdf_block) adds a SDF block.
%
%   See also SDF_CUT.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             sdf_add.m 
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

sdf_out = sdf_in;

sdf_out{end+1} = strcat('$', blockname);
for i = 1:length(sdf_block)
    if strncmp(sdf_block{i}, '$', 1)
        sdf_out{end+1} = strcat('$', sdf_block{i}); %#ok<AGROW>
    else
        sdf_out{end+1} = sdf_block{i}; %#ok<AGROW>
    end
end
sdf_out{end+1} = '$';
