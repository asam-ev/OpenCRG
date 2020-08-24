function [data] = crg_check_opts(data)
%CRG_CHECK_OPTS CRG check opts data.
%   [DATA] = CRG_CHECK_OPTS(DATA) checks CRG options data for consistency
%   of definitions and values.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO.
%
%   Outputs:
%   DATA    is a checked, purified, and eventually completed version of
%           the function input argument DATA
%
%   Examples:
%   data = crg_check_opts(data) checks CRG options data.
%
%   See also CRG_CHECK, CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_check_opts.m 
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

%% remove ok flag, initialize error/warning counter

if isfield(data, 'ok')
    data = rmfield(data, 'ok');
end
ierr = 0;

%% check for opts field

if ~isfield(data, 'opts')
        data.opts = struct;
end

%%  keep only what we know and want

opts = struct;

if isfield(data.opts, 'bdmu'), opts.bdmu = data.opts.bdmu; end
if isfield(data.opts, 'bdmv'), opts.bdmv = data.opts.bdmv; end
if isfield(data.opts, 'bdou'), opts.bdou = data.opts.bdou; end
if isfield(data.opts, 'bdov'), opts.bdov = data.opts.bdov; end
if isfield(data.opts, 'bdss'), opts.bdss = data.opts.bdss; end
if isfield(data.opts, 'bdse'), opts.bdse = data.opts.bdse; end
if isfield(data.opts, 'rflc'), opts.rflc = data.opts.rflc; end
if isfield(data.opts, 'sfar'), opts.sfar = data.opts.sfar; end
if isfield(data.opts, 'scls'), opts.scls = data.opts.scls; end
if isfield(data.opts, 'wmsg'), opts.wmsg = data.opts.wmsg; end
if isfield(data.opts, 'wcvl'), opts.wcvl = data.opts.wcvl; end
if isfield(data.opts, 'wcvg'), opts.wcvg = data.opts.wcvg; end
if isfield(data.opts, 'lmsg'), opts.lmsg = data.opts.lmsg; end
if isfield(data.opts, 'leva'), opts.leva = data.opts.leva; end
if isfield(data.opts, 'levf'), opts.levf = data.opts.levf; end
if isfield(data.opts, 'lhst'), opts.lhst = data.opts.lhst; end
if isfield(data.opts, 'lhsf'), opts.lhsf = data.opts.lhsf; end
if isfield(data.opts, 'lsta'), opts.lsta = data.opts.lsta; end
if isfield(data.opts, 'lstf'), opts.lstf = data.opts.lstf; end
if isfield(data.opts, 'ceps'), opts.ceps = data.opts.ceps; end
if isfield(data.opts, 'ctol'), opts.ctol = data.opts.ctol; end
if isfield(data.opts, 'cinc'), opts.cinc = data.opts.cinc; end
if isfield(data.opts, 'cpro'), opts.cpro = data.opts.cpro; end
if isfield(data.opts, 'cwgs'), opts.cwgs = data.opts.cwgs; end

data.opts = opts;

%% check singular value ranges

% CRG elevation grid border modes in u and v directions
if isfield(data.opts, 'bdmu')
    if data.opts.bdmu<0 || data.opts.bdmu>4 || data.opts.bdmu~=round(data.opts.bdmu)
        error('CRG:checkError', 'illegal option data "border_mode_u": %d', data.opts.bdmu)
    end
else
    data.opts.bdmu = 2;
end
if isfield(data.opts, 'bdmv')
    if data.opts.bdmv<0 || data.opts.bdmv>4 || data.opts.bdmv~=round(data.opts.bdmv)
        error('CRG:checkError', 'illegal option data "border_mode_v": %d', data.opts.bdmv)
    end
else
    data.opts.bdmv = 2;
end
if ~isfield(data.opts, 'bdou'), data.opts.bdou = 0; end
if ~isfield(data.opts, 'bdov'), data.opts.bdov = 0; end
if isfield(data.opts, 'bdss')
    if data.opts.bdss < 0
        error('CRG:checkError', 'illegal option data "border_smooth_ubeg": %d', data.opts.bdss)
    end
else
    data.opts.bdss = 0;
end
if isfield(data.opts, 'bdse')
    if data.opts.bdse < 0
        error('CRG:checkError', 'illegal option data "border_smooth_uend": %d', data.opts.bdse)
    end
else
    data.opts.bdse = 0;
end

% CRG reference line continuation
if isfield(data.opts, 'rflc')
    if data.opts.rflc<0 || data.opts.rflc>1 || data.opts.rflc~=round(data.opts.rflc)
        error('CRG:checkError', 'illegal option data "refline_continuation": %d', data.opts.rflc)
    end
else
    data.opts.rflc = 0;
end

% CRG reference line search strategy
if isfield(data.opts, 'sfar')
    if data.opts.sfar < 0
        error('CRG:checkError', 'illegal option data "refline_search_far": %d', data.opts.sfar)
    end
else
    data.opts.sfar = 1.5;
end
if isfield(data.opts, 'scls')
    if data.opts.scls<0 || data.opts.scls>=data.opts.sfar
        error('CRG:checkError', 'illegal option data "refline_search_close": %d', data.opts.scls)
    end
else
    data.opts.scls = data.opts.sfar/5;
end

% CRG message options
if isfield(data.opts, 'wmsg')
    if data.opts.wmsg<-1 || data.opts.wmsg~=round(data.opts.wmsg)
        error('CRG:checkError', 'illegal option data "warn_msgs": %d', data.opts.wmsg)
    end
else
    data.opts.wmsg = -1;
end
if isfield(data.opts, 'wcvl')
    if data.opts.wcvl<-1 || data.opts.wcvl~=round(data.opts.wcvl)
        error('CRG:checkError', 'illegal option data "warn_curv_local": %d', data.opts.wcvl)
    end
else
    data.opts.wcvl = -1;
end
if isfield(data.opts, 'wcvg')
    if data.opts.wcvg<-1 || data.opts.wcvg~=round(data.opts.wcvg)
        error('CRG:checkError', 'illegal option data "warn_curv_global": %d', data.opts.wcvg)
    end
else
    data.opts.wcvg = -1;
end
if isfield(data.opts, 'lmsg')
    if data.opts.lmsg<-1 || data.opts.lmsg~=round(data.opts.lmsg)
        error('CRG:checkError', 'illegal option data "log_msgs": %d', data.opts.lmsg)
    end
else
    data.opts.lmsg = -1;
end
if isfield(data.opts, 'leva')
    if data.opts.leva<-1 || data.opts.leva~=round(data.opts.leva)
        error('CRG:checkError', 'illegal option data "log_eval": %d', data.opts.leva)
    end
else
    data.opts.leva = 20;
end
if isfield(data.opts, 'levf')
    if data.opts.levf<1 || data.opts.levf~=round(data.opts.levf)
        error('CRG:checkError', 'illegal option data "log_eval_freq": %d', data.opts.levf)
    end
else
    data.opts.leva = 1;
end
if isfield(data.opts, 'lhst')
    if data.opts.lhst<-1 || data.opts.lhst~=round(data.opts.lhst)
        error('CRG:checkError', 'illegal option data "log_hist": %d', data.opts.lhst)
    end
else
    data.opts.lhst = 20;
end
if isfield(data.opts, 'lhsf')
    if data.opts.lhsf<1 || data.opts.lhsf~=round(data.opts.lhsf)
        error('CRG:checkError', 'illegal option data "log_hist_freq": %d', data.opts.lhsf)
    end
else
    data.opts.lhsf = 100000;
end
if isfield(data.opts, 'lsta')
    if data.opts.lsta<-1 || data.opts.lsta~=round(data.opts.lsta)
        error('CRG:checkError', 'illegal option data "log_stat": %d', data.opts.lsta)
    end
else
    data.opts.lhst = -1;
end
if isfield(data.opts, 'lstf')
    if data.opts.lstf<1 || data.opts.lstf~=round(data.opts.lstf)
        error('CRG:checkError', 'illegal option data "log_stat_freq": %d', data.opts.lstf)
    end
else
    data.opts.lstf = 100000;
end

% CRG check options
if isfield(data.opts, 'ceps')
    if data.opts.ceps<1.0e-6 || data.opts.ceps>1.0e-2
        error('CRG:checkError', 'illegal option data "check_eps": %d', data.opts.ceps)
    end
else
    data.opts.ceps = 1.0e-6;
end

midinc = 0.001; % must be consistent to current %.3f formatting for u and v in crg_write.m
mininc = midinc*(1-data.opts.ceps);
if isfield(data.opts, 'cinc')
    if data.opts.cinc<mininc || abs(round(data.opts.cinc/midinc)*midinc - data.opts.cinc) > data.opts.ceps*max(midinc, data.opts.cinc)
        error('CRG:checkError', 'illegal option data "check_inc": %d', data.opts.cinc)
    end
else
    data.opts.cinc = midinc;
end

if isfield(data.opts, 'ctol')
    if data.opts.ctol<data.opts.ceps*data.opts.cinc || data.opts.ctol>0.5*data.opts.cinc
        error('CRG:checkError', 'illegal option data "check_tol": %d', data.opts.ctol)
    end
else
    data.opts.ctol = 0.1*data.opts.cinc;
end

if isfield(data.opts, 'cpro')
    if data.opts.cpro<0.1*data.opts.cinc || data.opts.cpro>1
        error('CRG:checkError', 'illegal option data "check_pro": %d', data.opts.cpro)
    end
else
    data.opts.cpro = 5.0e-3;
end

if isfield(data.opts, 'cwgs')
    if data.opts.cwgs<0.1*data.opts.cinc || data.opts.cwgs>1000
        error('CRG:checkError', 'illegal option data "check_wgs": %d', data.opts.cwgs)
    end
else
    data.opts.cwgs = 10;
end


%% set ok-flag

if ierr == 0
    data.ok = 0;
end

end
