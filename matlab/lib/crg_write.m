function [ier] = crg_write(data, file, type)
% CRG_WRITE Write OpenCRG file.
%   IER = CRG_WRITE(DATA, FILE) writes OpenCRG data to file. The data must be of
%   type single.
%
%   Inputs:
%   DATA    struct array as defined in CRG_INTRO.
%   FILE    file to write
%   TYPE    file type, either binary 'KRBI' (default) or ascii 'LRFI'
%
%   Outputs:
%   IER     error flag
%           = 0: o.k.
%           =-1: error
%
%   Example:
%   ier = crg_write(data, file) writes CRG data structure to CRG file.
%
%   See also CRG_INTRO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             crg_write.m 
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

%% set default
if nargin < 3
  type = 'KRBI';
end

%% force check

data = crg_check(data);
if ~isfield(data, 'ok')
    error('CRG:checkError', 'check of DATA was not completely successful')
end

%% generate struct data blocks

crgdat.struct = cell(1,0);

%% generate struct data block $CT with comment text

c = cell(1,0);

if isfield(data, 'ct')
    for i=1:length(data.ct)
        c{end+1} = data.ct{i}; %#ok<AGROW>
    end
else
    error('CRG:writeError', 'comment text in DATA.ct missing')
end

crgdat.struct = sdf_add(crgdat.struct, 'CT', c);

%% generate struct data block $OPTS with option data

opts = data.opts;

% get,check or remove default options
default = struct;
default = crg_check_opts(default);
f = fieldnames(opts);
for i = 1:size(f)
    if isfield(default.opts, f{i}) && (opts.(f{i}) == default.opts.(f{i}))
        opts = rmfield(opts, f{i});
    end
end
clear f default

% generate struct data block lines

c = cell(1,0);

% CRG border modes in u and v directions
if isfield(opts, 'bdmu'), c{end+1} = sprintf('%s = %24.16e','border_mode_u       ', opts.bdmu); end
if isfield(opts, 'bdmv'), c{end+1} = sprintf('%s = %24.16e','border_mode_v       ', opts.bdmv); end
if isfield(opts, 'bdou'), c{end+1} = sprintf('%s = %24.16e','border_offset_u     ', opts.bdou); end
if isfield(opts, 'bdov'), c{end+1} = sprintf('%s = %24.16e','border_offset_v     ', opts.bdov); end
if isfield(opts, 'bdss'), c{end+1} = sprintf('%s = %24.16e','border_smooth_ubeg  ', opts.bdss); end
if isfield(opts, 'bdse'), c{end+1} = sprintf('%s = %24.16e','border_smooth_uend  ', opts.bdse); end

% CRG reference line continuation
if isfield(opts, 'rflc'), c{end+1} = sprintf('%s = %24.16e','refline_continuation', opts.rflc); end

% CRG reference line search strategy
if isfield(opts, 'sfar'), c{end+1} = sprintf('%s = %24.16e','refline_search_far  ', opts.sfar); end
if isfield(opts, 'scls'), c{end+1} = sprintf('%s = %24.16e','refline_search_close', opts.scls); end

% CRG message options
if isfield(opts, 'wmsg'), c{end+1} = sprintf('%s = %24.16e','warn_msgs           ', opts.wmsg); end
if isfield(opts, 'wcvl'), c{end+1} = sprintf('%s = %24.16e','warn_curv_local     ', opts.wcvl); end
if isfield(opts, 'lmsg'), c{end+1} = sprintf('%s = %24.16e','log_msgs            ', opts.lmsg); end
if isfield(opts, 'leva'), c{end+1} = sprintf('%s = %24.16e','log_eval            ', opts.leva); end
if isfield(opts, 'levf'), c{end+1} = sprintf('%s = %24.16e','log_eval_freq       ', opts.levf); end
if isfield(opts, 'lhst'), c{end+1} = sprintf('%s = %24.16e','log_hist            ', opts.lhst); end
if isfield(opts, 'lhsf'), c{end+1} = sprintf('%s = %24.16e','log_hist_freq       ', opts.lhsf); end
if isfield(opts, 'lsta'), c{end+1} = sprintf('%s = %24.16e','log_stat            ', opts.lsta); end
if isfield(opts, 'lstf'), c{end+1} = sprintf('%s = %24.16e','log_stat_freq       ', opts.lstf); end

% CRG check options
if isfield(opts, 'ceps'), c{end+1} = sprintf('%s = %24.16e','check_eps           ', opts.ceps); end
if isfield(opts, 'cinc'), c{end+1} = sprintf('%s = %24.16e','check_inc           ', opts.cinc); end
if isfield(opts, 'ctol'), c{end+1} = sprintf('%s = %24.16e','check_tol           ', opts.ctol); end
if isfield(opts, 'cpro'), c{end+1} = sprintf('%s = %24.16e','check_pro           ', opts.cpro); end
if isfield(opts, 'cwgs'), c{end+1} = sprintf('%s = %24.16e','check_wgs           ', opts.cwgs); end

% write only non-empty struct data block
if size(c, 2) > 0
    crgdat.struct = sdf_add(crgdat.struct, 'ROAD_CRG_OPTS', c);
end

clear c opts

%% generate struct data block $MODS with modifier data

mods = data.mods;

% generate struct data block lines

c = cell(1,0);

% CRG scaling
if isfield(mods, 'szgd'), c{end+1} = sprintf('%s = %24.16e','scale_z_grid         ', mods.szgd); end
if isfield(mods, 'sslp'), c{end+1} = sprintf('%s = %24.16e','scale_slope          ', mods.sslp); end
if isfield(mods, 'sbkg'), c{end+1} = sprintf('%s = %24.16e','scale_banking        ', mods.sbkg); end
if isfield(mods, 'slth'), c{end+1} = sprintf('%s = %24.16e','scale_length         ', mods.slth); end
if isfield(mods, 'swth'), c{end+1} = sprintf('%s = %24.16e','scale_width          ', mods.swth); end
if isfield(mods, 'scrv'), c{end+1} = sprintf('%s = %24.16e','scale_curvature      ', mods.scrv); end

% CRG elevation grid NaN handling
if isfield(mods, 'gnan'), c{end+1} = sprintf('%s = %24.16e','grid_nan_mode       ', mods.gnan); end
if isfield(mods, 'gnao'), c{end+1} = sprintf('%s = %24.16e','grid_nan_offset     ', mods.gnao); end

% CRG re-positioning: reference line by offset
if isfield(mods, 'rlrx'), c{end+1} = sprintf('%s = %24.16e','refline_rotcenter_x ', mods.rlrx); end
if isfield(mods, 'rlry'), c{end+1} = sprintf('%s = %24.16e','refline_rotcenter_y ', mods.rlry); end
if isfield(mods, 'rlop'), c{end+1} = sprintf('%s = %24.16e','refline_offset_phi  ', mods.rlop); end
if isfield(mods, 'rlox'), c{end+1} = sprintf('%s = %24.16e','refline_offset_x    ', mods.rlox); end
if isfield(mods, 'rloy'), c{end+1} = sprintf('%s = %24.16e','refline_offset_y    ', mods.rloy); end
if isfield(mods, 'rloz'), c{end+1} = sprintf('%s = %24.16e','refline_offset_z    ', mods.rloz); end

% CRG re-positioning: reference line by reference point
if isfield(mods, 'rptu'), c{end+1} = sprintf('%s = %24.16e','refpoint_u         ', mods.rptu); end
if isfield(mods, 'rpfu'), c{end+1} = sprintf('%s = %24.16e','refpoint_u_fraction', mods.rpfu); end
if isfield(mods, 'rpou'), c{end+1} = sprintf('%s = %24.16e','refpoint_u_offset  ', mods.rpou); end
if isfield(mods, 'rptv'), c{end+1} = sprintf('%s = %24.16e','refpoint_v         ', mods.rptv); end
if isfield(mods, 'rpfv'), c{end+1} = sprintf('%s = %24.16e','refpoint_v_fraction', mods.rpfv); end
if isfield(mods, 'rpov'), c{end+1} = sprintf('%s = %24.16e','refpoint_v_offset  ', mods.rpov); end
if isfield(mods, 'rptx'), c{end+1} = sprintf('%s = %24.16e','refpoint_x         ', mods.rptx); end
if isfield(mods, 'rpty'), c{end+1} = sprintf('%s = %24.16e','refpoint_y         ', mods.rpty); end
if isfield(mods, 'rptz'), c{end+1} = sprintf('%s = %24.16e','refpoint_z         ', mods.rptz); end
if isfield(mods, 'rptp'), c{end+1} = sprintf('%s = %24.16e','refpoint_phi       ', mods.rptp); end

% write only non-default struct data block
default = struct;
default = crg_check_mods(default);
if ~isequal(mods, default.mods)
     crgdat.struct = sdf_add(crgdat.struct, 'ROAD_CRG_MODS', c);
end

clear c mods default

%% generate struct data block $ROAD_CRG with header data

head = data.head;

c = cell(1,0);

if isfield(head, 'ubeg'), c{end+1} = sprintf('%s = %24.16e','reference_line_start_u   ', head.ubeg); end
if isfield(head, 'uend'), c{end+1} = sprintf('%s = %24.16e','reference_line_end_u     ', head.uend); end
if isfield(head, 'uinc'), c{end+1} = sprintf('%s = %24.16e','reference_line_increment ', head.uinc); end
if isfield(head, 'vmin'), c{end+1} = sprintf('%s = %24.16e','long_section_v_right     ', head.vmin); end
if isfield(head, 'vmax'), c{end+1} = sprintf('%s = %24.16e','long_section_v_left      ', head.vmax); end
if isfield(head, 'vinc'), c{end+1} = sprintf('%s = %24.16e','long_section_v_increment ', head.vinc); end
if isfield(head, 'sbeg'), c{end+1} = sprintf('%s = %24.16e','reference_line_start_s   ', head.sbeg); end
if isfield(head, 'send'), c{end+1} = sprintf('%s = %24.16e','reference_line_end_s     ', head.send); end
if isfield(head, 'bbeg'), c{end+1} = sprintf('%s = %24.16e','reference_line_start_b   ', head.bbeg); end
if isfield(head, 'bend'), c{end+1} = sprintf('%s = %24.16e','reference_line_end_b     ', head.bend); end
if isfield(head, 'xbeg'), c{end+1} = sprintf('%s = %24.16e','reference_line_start_x   ', head.xbeg); end
if isfield(head, 'ybeg'), c{end+1} = sprintf('%s = %24.16e','reference_line_start_y   ', head.ybeg); end
if isfield(head, 'xend'), c{end+1} = sprintf('%s = %24.16e','reference_line_end_x     ', head.xend); end
if isfield(head, 'yend'), c{end+1} = sprintf('%s = %24.16e','reference_line_end_y     ', head.yend); end
if isfield(head, 'xoff'), c{end+1} = sprintf('%s = %24.16e','reference_line_offset_x  ', head.xoff); end
if isfield(head, 'yoff'), c{end+1} = sprintf('%s = %24.16e','reference_line_offset_y  ', head.yoff); end
if isfield(head, 'pbeg'), c{end+1} = sprintf('%s = %24.16e','reference_line_start_phi ', head.pbeg); end
if isfield(head, 'pend'), c{end+1} = sprintf('%s = %24.16e','reference_line_end_phi   ', head.pend); end
if isfield(head, 'poff'), c{end+1} = sprintf('%s = %24.16e','reference_line_offset_phi', head.poff); end
if isfield(head, 'zbeg'), c{end+1} = sprintf('%s = %24.16e','reference_line_start_z   ', head.zbeg); end
if isfield(head, 'zend'), c{end+1} = sprintf('%s = %24.16e','reference_line_end_z     ', head.zend); end
if isfield(head, 'zoff'), c{end+1} = sprintf('%s = %24.16e','reference_line_offset_z  ', head.zoff); end
if isfield(head, 'ebeg'), c{end+1} = sprintf('%s = %24.16e','reference_line_start_lon ', head.ebeg); end
if isfield(head, 'nbeg'), c{end+1} = sprintf('%s = %24.16e','reference_line_start_lat ', head.nbeg); end
if isfield(head, 'eend'), c{end+1} = sprintf('%s = %24.16e','reference_line_end_lon   ', head.eend); end
if isfield(head, 'nend'), c{end+1} = sprintf('%s = %24.16e','reference_line_end_lat   ', head.nend); end
if isfield(head, 'abeg'), c{end+1} = sprintf('%s = %24.16e','reference_line_start_alt ', head.abeg); end
if isfield(head, 'aend'), c{end+1} = sprintf('%s = %24.16e','reference_line_end_alt   ', head.aend); end
if isfield(head, 'rccl'), c{end+1} = sprintf('%s = %24.16e','reference_line_curv_check', head.rccl); end    % //TODO: flag name

crgdat.struct = sdf_add(crgdat.struct, 'ROAD_CRG', c);

clear c head

%% generate struct data blocks $MPRO_* with map projection data

if isfield(data, 'mpro') % mapping projection data is available
    
    c = cell(1,0);
    
    %% process GELL (global geodetic datum)
    
    gell = data.mpro.gell;

    % generate struct data block lines
    
    switch gell.nm
        case 'WGS84'
            %
        case 'USERDEFINED'
            c{end+1} = sprintf('%s = %24.16e', 'gell_a ', gell.a );
            if gell.b ~= gell.a
                c{end+1} = sprintf('%s = %24.16e', 'gell_b ', gell.b );
            end
        otherwise
            c{end+1} = sprintf('%s = ''%s''' , 'gell_nm', gell.nm);
    end
    
    clear gell
   
    %% process TRAN (datum transformation)
    
    tran = data.mpro.tran;

    % generate struct data block lines
    
    switch tran.nm
        case {'HL7','HN7','HS7'}
            c{end+1} = sprintf('%s = ''%s''' , 'tran_nm', tran.nm);
            if tran.ds ~= 0, c{end+1} = sprintf('%s = %24.16e', 'tran_ds', tran.ds); end
            if tran.rx ~= 0, c{end+1} = sprintf('%s = %24.16e', 'tran_rx', tran.rx); end
            if tran.ry ~= 0, c{end+1} = sprintf('%s = %24.16e', 'tran_ry', tran.ry); end
            if tran.rz ~= 0, c{end+1} = sprintf('%s = %24.16e', 'tran_rz', tran.rz); end
            if tran.tx ~= 0, c{end+1} = sprintf('%s = %24.16e', 'tran_tx', tran.tx); end
            if tran.ty ~= 0, c{end+1} = sprintf('%s = %24.16e', 'tran_ty', tran.ty); end
            if tran.tz ~= 0, c{end+1} = sprintf('%s = %24.16e', 'tran_tz', tran.tz); end
    end
    
    clear tran
   
    %% process LELL (local geodetic datum)
    
    lell = data.mpro.lell;

    % generate struct data block lines
    
    switch lell.nm
        case 'WGS84'
            %
        case 'USERDEFINED'
            c{end+1} = sprintf('%s = %24.16e', 'lell_a ', lell.a );
            if lell.b ~= lell.a
                c{end+1} = sprintf('%s = %24.16e', 'lell_b ', lell.b );
            end
        otherwise
            c{end+1} = sprintf('%s = ''%s''' , 'lell_nm', lell.nm);
    end
    
    clear lell
   
    %% process PROJ (map projection)
    
    proj = data.mpro.proj;

    % generate struct data block lines
    
    c{end+1} = sprintf('%s = ''%s''' , 'proj_nm', proj.nm);
    
    if length(proj.nm) < 3
        if proj.l0 ~= 0, c{end+1} = sprintf('%s = %24.16e', 'proj_l0', proj.l0); end
    elseif strcmp(proj.nm(1:3), 'TM_')
        if proj.f0 ~= 1, c{end+1} = sprintf('%s = %24.16e', 'proj_f0', proj.f0); end
        if proj.p0 ~= 0, c{end+1} = sprintf('%s = %24.16e', 'proj_p0', proj.p0); end
        if proj.e0 ~= 0, c{end+1} = sprintf('%s = %24.16e', 'proj_e0', proj.e0); end
        if proj.n0 ~= 0, c{end+1} = sprintf('%s = %24.16e', 'proj_n0', proj.n0); end
    end

    clear proj
    
    %% write struct data block
    
    crgdat.struct = sdf_add(crgdat.struct, 'ROAD_CRG_MPRO', c);
    
    clear c
   
end

%% add further struct data if available

if isfield(data, 'struct')
    for i=1:length(data.struct)
        crgdat.struct{end+1} = data.struct{i};
    end
end

%% add timestamp

crgdat.struct{end+1} = ...
    sprintf('* written by %s at %s', mfilename, datestr(now, 31));

%% generate data for $KD_DEFINITION block and data array

%  generate virtual data channel definition
crgdat.kd_ind = cell(1,0);
crgdat.kd_ind{end+1} = sprintf('reference line u,m,%.3f,%.3f', data.head.ubeg, data.head.uinc);

%  generate dependant channel definitions and data array
crgdat.kd_def = cell(1,0);
crgdat.kd_dat = [];

%  generate dependant channel definitions: heading
if isfield(data, 'p') && length(data.p) > 1
    crgdat.kd_def{end+1} = 'reference line phi,rad';
    % first value will be ignored on reading
    crgdat.kd_dat = [crgdat.kd_dat [NaN('single') single(data.p)]'];
end

%  generate dependant channel definitions: slope
if isfield(data, 's') && length(data.s) > 1
    crgdat.kd_def{end+1} = 'reference line slope,m/m';
    % first value will be ignored on reading
    crgdat.kd_dat = [crgdat.kd_dat [NaN('single') single(data.s)]'];
end

%  generate dependant channel definitions: banking
if isfield(data, 'b') && length(data.b) > 1
    crgdat.kd_def{end+1} = 'reference line banking,m/m';
    crgdat.kd_dat = [crgdat.kd_dat single(data.b)'];
end

%  generate dependant channel definitions: long section position/number
nv = size(data.z, 2);
if isfield(data, 'v') && length(data.v) == nv
    for i = 1:nv
        crgdat.kd_def{end+1} = sprintf('long section at v = %.3f,m', double(data.v(i)));
    end
else
    for i = 1:nv
        crgdat.kd_def{end+1} = sprintf('long section %d,m', i);
    end
end
crgdat.kd_dat = [crgdat.kd_dat single(data.z)];

% write all CRG data as data file with specified type (default = 'KRBI')

ier = ipl_write(crgdat, file, type);

end
