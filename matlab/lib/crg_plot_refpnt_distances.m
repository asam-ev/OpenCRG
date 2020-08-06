function [data] = crg_plot_refpnt_distances(data, pxy)
% CRG_PLOT_REFPNT_DISTANCES CRG road refpoint distance plot.
%   DATA = CRG_PLOT_REFPNT_DISTANCES(DATA, PXY) plots CRG reference point
%   distances from reference line in current axes object.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO
%   PXY     (np, 2) array of points in xy system
%
%   Outputs:
%   DATA    struct array as defined in CRG_INTRO
%
%   Examples:
%   data = crg_plot_refpnt_distances(data, pxy)
%       plots refpoint distances.
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_plot_refpnt_distances.m 
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

%% generate auxiliary data

[puv, data] = crg_eval_xy2uv(data, pxy);
vmean = mean(puv(:,2));
vstd  = std (puv(:,2));

vstd1 = [data.head.ubeg data.head.uend NaN data.head.ubeg data.head.uend];
vstd2 = [vmean+vstd     vmean+vstd     NaN vmean-vstd     vmean-vstd    ];

%% plot refpoint distances from reference line

plot(puv(:,1), puv(:,2), '.')

hold on
plot([data.head.ubeg data.head.uend], [vmean vmean], 'r-.') % mean
plot(vstd1, vstd2, 'r--') % mean +/- std
grid on

title('CRG reference point distances from reference line')
xlabel('U [m]')
ylabel('point distance V [m]')
legend('point distances', ...
    sprintf('mean = %d', vmean), ...
    sprintf('std = %d', vstd))


end
