function [data] = crg_surf(data, x, y, z)
% CRG_SURF plots a 3d surface.
%   DATA = CRG_SURF(DATA, X, Y, Z) plots a 3d surface in current axes
%   object with extended option settings.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO
%           DATA.fopts options are evaluated if available.
%   X       surf argument X
%   Y       surf argument Y
%   Z       surf argument Z
%
%   Outputs:
%   DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   data = crg_surf(data, x, y, z)
%       plots 3d surface.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_surf.m 
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

%% plot elgrid XYZ perspective map

fmod = 0; % colormap mod divisor 0 returns unchanged value
if isfield(data, 'fopt') && isfield(data.fopt, 'mod')
    fmod = data.fopt.mod;
end
surf(x, y, z, mod(z, fmod))

fasp = 0.1; % z aspect ratio 0.1 magnifies z axis by 10
if isfield(data, 'fopt') && isfield(data.fopt, 'asp')
    fasp = data.fopt.asp;
end
daspect([1 1 fasp])

axis tight
grid on
colorbar

shading interp
lighting phong

h = camlight;
flit = 0; % light visibility
if isfield(data, 'fopt') && isfield(data.fopt, 'lit')
    flit = data.fopt.lit;
end
if flit == 0
    set(h, 'Visible', 'off')
end

end
