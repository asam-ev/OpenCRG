function [pz, data] = crg_eval_uv2z(data, puv)
%CRG_EVAL_UV2Z Evaluate z at grid position.
%   [PZ, DATA] = CRG_EVAL_UV2Z(DATA, PUV) evaluates the z-values at
%   the given u/v-positions.
%
%   Inputs:
%       DATA    struct array as defined in CRG_INTRO.
%       PUV     (np, 2) array of points in u/v-system
%
%   Outputs:
%       PZ      (np) vector of z-values
%       DATA    struct array as defined in CRG_INTRO.
%
%   Examples:
%   pz = crg_eval_uv2z(data, puv)
%       Evaluates the z-values at the given u/v-positions.
%
%   See also CRG_INTRO.

% *****************************************************************
% See the NOTICE file distributed with this work regarding copyright ownership.
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%    https://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
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

%% for closed reference line: map u-values to valid interval

if data.opts.rflc==1 && data.dved.ulex~=0
    puv(:,1) = mod(puv(:,1)-data.dved.ubex, data.dved.ulex) + data.dved.ubex;
end

%% simplify data access

np = size(puv, 1);

bdmu = data.opts.bdmu;
bdmv = data.opts.bdmv;
bdou = data.opts.bdou;
bdov = data.opts.bdov;
bdss = data.opts.bdss;
bdse = data.opts.bdse;

ceps0 = data.opts.ceps;
ceps1 = 1 - ceps0;

ubeg = data.head.ubeg;
uend = data.head.uend;
uinc = data.head.uinc;
ulen = uend - ubeg;
ule2 = ulen * 2;

vmin = data.head.vmin;
vmax = data.head.vmax;
if isfield(data.head, 'vinc')
    vinc = data.head.vinc;
else
    vinc = 0;
    v = data.v;
end
vwid = vmax - vmin;
vwi2 = vwid * 2;

zbeg = data.head.zbeg;
zend = data.head.zend;
sbeg = data.head.sbeg;
bbeg = data.head.bbeg;

z = data.z;
[nu nv] = size(z);
nvm1 = nv - 1;

if isfield(data, 'rz')
    rz = data.rz;
    nrz = length(rz);
else
    nrz = 0;
end

if isfield(data, 'b')
    b = data.b;
    nb = length(b);
else
    nb = 0;
end

%% pre-allocate output

pz = zeros(np, 1);

%% work on all points

for ip = 1 : np
    pui = puv(ip, 1);
    pvi = puv(ip, 2);

    % repeat/reflect border mode maps u-value into [ubeg uend] interval
    switch bdmu % border_mode_u
        case 3 % repeat
            pui = mod(pui-ubeg, ulen) + ubeg;
        case 4 % reflect
            pui = mod(pui-ubeg, ule2);
            if pui > ulen, pui = ule2 - pui; end
            pui = pui + ubeg;
    end

    % repeat/reflect border mode maps v-value into [vmin vmax] interval
    switch bdmv % border_mode_v
        case 3 % repeat
            pvi = mod(pvi-vmin, vwid) + vmin;
        case 4 % reflect
            pvi = mod(pvi-vmin, vwi2);
            if pvi > vwid, pvi = vwi2 - pvi; end
            pvi = pvi + vmin;
    end

    % find u-interval in constantly spaced u-axis
    ui = (pui - ubeg) / uinc;
    iu = min(max(0, floor(ui)), nu-2); % find u interval
    du = ui-iu;
    ui = min(max(0, du), 1); % limit to [0 1] border interval
    iu = iu + 1; % MATLAB counts from 1

    if vinc ~= 0
        % find v-interval in constantly spaced v-axis
        vi = (pvi - vmin) / vinc;
        iv = min(max(0, floor(vi)), nv-2); % find v-interval
        dv = vi-iv;
        vi = min(max(0, dv), 1); % limit to [0 1] border interval
        iv = iv + 1; % MATLAB counts from 1
    else
        % find v-interval in variably spaced v-axis
        i0 = nvm1;
        iv = 0;
        while 1
            im = floor((iv+i0)/2);
            if im > iv
                if pvi <  v(im+1)
                    i0 = im;
                else
                    iv = im;
                end
            else
                break
            end
        end
        iv = iv + 1; % MATLAB counts from 1
        dv = (pvi-v(iv))/(v(iv+1)-v(iv));
        vi = min(max(0, dv), 1);
    end

    % evaluate z(u, v) by bilinear interpolation
    % using a special NaN handling to avoid undesired NaN propagation
    % because of 0*NaN resulting in NaN instead of 0 at corners (edges)

    % the 4 corners to work with
    z00 = double(z(iu  , iv  ));
    z10 = double(z(iu+1, iv  ));
    z01 = double(z(iu  , iv+1));
    z11 = double(z(iu+1, iv+1));

    % check if any corner is NaN (any NaN will be propagated to d11)
    d11 = z11 - z10 - z01 + z00;
    if ~isnan(d11)
        % standard interpolation without any NaN corner
        d10 = z10 - z00;
        d01 = z01 - z00;
        piz = (d11*vi + d10)*ui + d01*vi + z00;
    else
        % snap to corner (edge) if rather close
        uw = ui;  vw = vi;
        if uw < ceps0, uw = 0; elseif uw > ceps1, uw = 1; end
        if vw < ceps0, vw = 0; elseif vw > ceps1, vw = 1; end

        % identify NaN(s)
        n00 = isnan(z00);
        n10 = isnan(z10);
        n01 = isnan(z01);
        n11 = isnan(z11);

        if (n00 && uw<1 && vw<1) || (n10 && uw>0 && vw<1) || ...
           (n01 && uw<1 && vw>0) || (n11 && uw>0 && vw>0)

            % at least one NaN corner is relevant
            % NaN is propagated
            piz = NaN;
        else
            % all NaN corners (edges) are irrelevant and are replaced by 0

            if n00, z00 = 0; end
            if n10, z10 = 0; end
            if n01, z01 = 0; end
            if n11, z11 = 0; end

            % standard interpolation (as above)
            d11 = z11 - z10 - z01 + z00;
            d10 = z10 - z00;
            d01 = z01 - z00;
            piz = (d11*vw + d10)*uw + d01*vw + z00;
        end
    end

    % add slope
    if nrz > 0
        piz = piz + rz(iu) + ui*(rz(iu+1)-rz(iu));
    else
        piz = piz + zbeg + (min(max(ubeg, pui), uend)-ubeg)*sbeg;
    end

    % add banking
    if nb > 1
        pib = b(iu) + ui*(b(iu+1)-b(iu));
    else
        pib = bbeg;
    end
    piz = piz + min(max(vmin, pvi), vmax)*pib;

    % extrapolating border mode in u-direction
    if ui ~= du % ui was limited to [0 1] border interval
        switch bdmu % border_mode_u
            case 1 % set zero
                piz = bdou;
            case 2 % keep last
                piz = piz + bdou;
        end
    end

    % extrapolating border mode in v-direction
    if vi ~= dv % vi was limited to [0 1] border interval
        switch bdmv % border_mode_v
            case 1 % set zero
                piz = bdov;
            case 2 % keep last
                piz = piz + bdov;
        end
    end

    % smoothing zone at start
    urel = max(0, pui-ubeg);
    if bdss>urel % inside smoothing zone
        piz = urel/bdss*(piz-zbeg) + zbeg;
    end

    % smoothing zone at end
    urel = max(0, uend-pui);
    if bdse>urel % inside smoothing zone
        piz = urel/bdse*(piz-zend) + zend;
    end

    if (bdmu==0 && ui~=du) || (bdmv==0 && vi~=dv) % NaN border mode and ui or vi was outside [0 1] border interval
        pz(ip) = NaN;
    else
        pz(ip) = piz;
    end
end

end
