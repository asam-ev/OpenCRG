function [sdf_block, sdf_out] = sdf_cut(sdf_in, blockname)
% SDF_CUT Cut block from struct data file
%   [SDF_BLOCK SDF_OUT] = SDF_CUT(SDF_IN, BLOCKNAME) cuts a block from a struct
%   data file.
%
%   Inputs:
%   SDF_IN      cell array of struct data file lines
%   BLOCKNAME   name of block to cut out
%
%   Outputs:
%   SDF_BLOCK   cell array of struct data lines of named block
%   SDF_OUT     cell array of remaining struct data lines
%
%   Example:
%   [sdf_block, sdf_out] = sdf_cut(sdf_in, blockname) extracts a SDF block.
%
%   See also SDF_ADD.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             sdf_cut.m 
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

sdf_block{1} = '';
sdf_out{1} = '';

state = 0;

hc = upper(strcat('$', blockname));

for i = 1:length(sdf_in)
    switch state
        case 0 % outside of $BLOCKNAME
            if strcmp(upper(strtok(sdf_in{i}, ' !')), hc)
                state = 1; % begin of $BLOCKNAME detected
            else
                sdf_out{end+1} = sdf_in{i}; %#ok<AGROW>
            end
        case 1 % inside of $BLOCKNAME
            if strncmp(sdf_in{i}, '$', 1)
                if strncmp(sdf_in{i}, '$$', 2)
                    sdf_block{end+1} = sdf_in{i}(2:end); %#ok<AGROW>
                else
                    state = 2; % end of $BLOCKNAME detected
                end
            else
                sdf_block{end+1} = sdf_in{i}; %#ok<AGROW>
            end
        case 2 % after end of $BLOCKNAME
            sdf_out{end+1} = sdf_in{i}; %#ok<AGROW>
    end
end

sdf_block(1) = [];
sdf_out(1) = [];
