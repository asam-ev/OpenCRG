function [ier] = ipl_write(data, filename, type)
% IPL_WRITE Write IPLOS file.
%   IER = IPL_WRITE(DATA, FILENAME, TYPE) writes IPLOS data file
%
%   Inputs:
%   DATA        is a struct array with
%       DATA.struct     (optional) cell array of struct data lines
%       DATA.kd_ind     (optional) cell array of virtual channel definitions
%       DATA.kd_def     cell array of data channel definitions
%       DATA.kd_oth     (optional) cell array of other definitions
%       DATA.kd_dat     data array (single or double)
%   FILENAME    is the file to write
%   TYPE        is the data representation type to use
%               'KRBI'  binary float32
%               'KDBI'  binary float64
%               'LRFI'  ascii single precision
%               'LDFI'  ascii double precision
%
%   Outputs:
%   IER         error return code
%               = 0     successful
%               = -1    not successful
%
%   Example
%   ier = ipl_write(data, filename, type)
%      Writes an IPLOS file.
%
%   See also IPL_READ, IPL_DEMO.

% *****************************************************************
% ASAM OpenCRG Matlab API
%
% OpenCRG version:           1.2.0
%
% package:               lib
% file name:             ipl_write.m 
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

[nr, nc] = size(data.kd_dat);

% IPLOS file machineformat: ieee-be (IEEE floating point with big-endian byte ordering)
% IPLOS file encoding: ISO-8859-1 (latin1, explicitly supported since Matlab R2006a)
try
  fid = fopen(filename,'w','ieee-be','ISO-8859-1');
catch
  fid = fopen(filename,'w','ieee-be');
end
if fid < 0
    error('file %s could not be opened for write', filename)
end

% write structured data

if isfield(data, 'struct')
    for i = 1:length(data.struct)
        hc = data.struct{i};
        if length(hc) > 72
            hc = hc(1:72);
            warning('IPL:recLengthExceeded', ...
            'data.struct{%d} too long:\n %s\nwill only be used as:\n %s', ...
            i, data.struct{i}, hc)
        end
        fprintf(fid, '%s\n', data.struct{i});
    end
end

% write date

fprintf(fid, '* written by %s at %s\n', mfilename, datestr(now, 31));

% write definition block for sequential data

fprintf(fid, '%s\n', '$KD_DEFINITION');

fprintf(fid, '#:%s\n', type);

if isfield(data, 'kd_ind')
    for i = 1:length(data.kd_ind)
        hc = data.kd_ind{i};
        if length(hc) > 72
            hc = hc(1:72);
            warning('IPL:recLengthExceeded', ...
            'data.kd_ind{%d} too long:\n %s\nwill only be used as:\n %s', ...
            i, data.kd_ind{i}, hc)
        end
        fprintf(fid, 'U:%s\n', data.kd_ind{i});
    end
end

if nc ~= length(data.kd_def)
    error('wrong number of data definitions')
end

for i = 1:length(data.kd_def)
        hc = data.kd_def{i};
        if length(hc) > 72
            hc = hc(1:72);
            warning('IPL:recLengthExceeded', ...
            'data.kd_def{%d} too long:\n %s\nwill only be used as:\n %s', ...
            i, data.kd_def{i}, hc)
        end
    fprintf(fid, 'D:%s\n', data.kd_def{i});
end

if isfield(data, 'kd_oth')
    for i = 1:length(data.kd_oth)
        hc = data.kd_oth{i};
        if length(hc) > 72
            hc = hc(1:72);
            warning('IPL:recLengthExceeded', ...
            'data.kd_oth{%d} too long:\n %s\nwill only be used as:\n %s', ...
            i, data.kd_oth{i}, hc)
        end
        fprintf(fid, '%s\n', data.kd_oth{i});
    end
end

fprintf(fid, '%s\n', '$');

% write separator

hc(1:72) = '$';
fprintf(fid, '%s\n', hc);

% write sequential data

switch type
    case 'KRBI'
        try
            fwrite(fid, data.kd_dat', 'float32');
        catch
            % transposing big data.kd_dat can result in "Out of memory"
            % problems. A workaround is to write it record by record,
            % which gives a second chance:
            for ir = 1:nr
                fwrite(fid, data.kd_dat(ir, :), 'float32');
            end
        end
        % pad with NaN to full multiple of 80 data bytes
        for i = 1:mod(-nc*nr,20)
            fwrite(fid, NaN, 'float32');
        end
    case 'KDBI'
        try
            fwrite(fid, data.kd_dat', 'float64');
        catch
            % transposing big data.kd_dat can result in "Out of memory"
            % problems. A workaround is to write it record by record,
            % which gives a second chance:
            for ir = 1:nr
                fwrite(fid, data.kd_dat(ir, :), 'float64');
            end
        end
        % pad with NaN to full multiple of 80 data bytes
        for i = 1:mod(-nc*nr,10)
            fwrite(fid, NaN, 'float64');
        end
    case 'LRFI'
        for ir = 1:nr
            for ic = 1:nc
                if isnan(data.kd_dat(ir, ic))
                    fprintf(fid, '**********');
                else
                    fprintf(fid, ' %s', str_num2strn(double(data.kd_dat(ir, ic)), 9));
                end
                if (mod(ic, 8) == 0)
                    fprintf(fid, '\n');
                end
            end
            if (mod(nc, 8) ~= 0)
                fprintf(fid, '\n');
            end
        end
    case 'LDFI'
        for ir = 1:nr
            for ic = 1:nc
                if isnan(data.kd_dat(ir, ic))
                    fprintf(fid, '********************');
                else
                    fprintf(fid, ' %s', str_num2strn(double(data.kd_dat(ir, ic)), 19));
                end
                if (mod(ic, 4) == 0)
                    fprintf(fid, '\n');
                end
            end
            if mod(nc, 4) ~= 0
                fprintf(fid, '\n');
            end
        end
     otherwise
        error('type %s is not supported', type)
end

ier = fclose(fid);
