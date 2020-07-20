function [url] = crg_wgs84_wgs2url(wgs, opts)
%CRG_WGS84_WGS2URL CRG generate url string to show wgs info
%   [URL] = CRG_WGS84_WGS2URL(WGS, OPTS) generates url string
%   to show WGS84 coordinates.
%
%   Inputs:
%   WGS     (np, 2) arrays of latitude/longitude (north/east) wgs84
%           coordinate pairs (in degrees)
%   OPTS    stuct for method options (optional, no default)
%   .label  sets label comment text (default: 'OpenCRG road mark')
%
%   Outputs:
%   URL     url string (for np=1) or struct of strings (for np>1)
%
%   Examples:
%   wgs = [51.477811,-0.001475]  % Greenwich Prime Meridian
%                                % (Airy's Transit Circle)
%   url = crg_wgs84_wgs2url(wgs) % generate url sting
%   web(url, '-browser')         % show url in default browser
%   generate url string to show wgs info in
%
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_wgs84_wgs2url.m 
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

%% handle optional args

if nargin < 2
    opts = struct;
end

if isfield(opts, 'label')
    label = opts.label;
else
    label = 'OpenCRG road mark';
end
label = strrep(label, ' ', '+'); % replace blanks by '+' for url string

%% generate url string

np = size(wgs, 1);

if np == 1
    url = sprintf('http://maps.google.com/maps?q=%.6f,%.6f(%s)', wgs(1,1), wgs(1,2), label);
else
    for i = 1:np
        url{i} = sprintf('http://maps.google.com/maps?q=%.6f,%.6f(%s)', wgs(i,1), wgs(i,2), label); %#ok<AGROW>
    end
end

end
