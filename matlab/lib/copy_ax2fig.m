function [] = copy_ax2fig()
% COPY_AX2FIG Copy current axes object to new figure.
%   COPY_AX2FIG() copies the current axes object to a new figure.
%   This function is most useful if called by a mouse click action in a
%   subplot of a complex figure.
%   -   If the subplot is a surface plot, then a colorbar is also attached
%       to the new figure.
%   -   If the subplot has a legend, then a legend will also attached to
%       the new figure.
%   In order for the function to work, each subplot must be have it's
%   ButtonDownFcn set to COPY_AX2FIG. To set this property for the current
%   axes object:
%       set(    gca             , 'ButtonDownFcn','copy_ax2fig')
%       set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')
%   for all children of the current axis object, or more individually
%       set(axis_handle,'ButtonDownFcn','copy_ax2fig');
%       set(line_handle,'ButtonDownFcn','copy_ax2fig');
%   The line_handle represents the handle for either a line, surface,
%   or plot handle. If there are multiple line objects, each needs to be
%   set. With both the line and axis object set, it doesn't matter whether
%   the axis object or line object is clicked on.
%
%   Example:
%   figure
%   t = 0:pi/100:2*pi;
%
%   subplot(2,1,1)
%   plot(t,sin(t))
%   set(    gca             , 'ButtonDownFcn','copy_ax2fig')
%   set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')
%
%   subplot(2,1,2)
%   plot(t,cos(t))
%   set(    gca             , 'ButtonDownFcn','copy_ax2fig')
%   set(get(gca, 'Children'), 'ButtonDownFcn','copy_ax2fig')
%
%   See also gca.

%   Motivated by call_copy of Jeff Lucas
%   http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=3450
%
% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             copy_ax2fig.m 
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

[legend_h,object_h,plot_h,text_strings] = legend;

ax = copyobj(gca,figure);

set(ax,'OuterPosition',[0 0 1 1]);
set(ax,'LooseInset',get(ax,'TightInset')+[0.045 0.02 0.065 0.02]);

set(ax,'ButtonDownFcn','');
h_child=get(ax,'Children');
set(h_child,'ButtonDownFcn','');

if any(strcmp(get(h_child,'Type'),'surface'));
    colorbar;
end;

if iscell(text_strings)
    legend(text_strings)
end

end
