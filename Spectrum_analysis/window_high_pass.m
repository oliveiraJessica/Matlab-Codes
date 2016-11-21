% Build a low pass filter by the window method
% N: size of filter
% fc: cut frequence, in Hz
% w: window used to build the filter. It must be of size N
function h = window_high_pass(N, fc, w, varargin)        
    hlp = window_low_pass(N,fc,w);
    imp = all_pass(N);
    h = hlp'-imp;
    plot = 0;
    if not(isempty(varargin))
        plot = varargin{1,1};
    end
    if plot == 1
        spectrum_plot(h,1,'All',1024,0)
    end
end

function imp = all_pass(N)
    imp = [zeros(1,floor(N/2)), 1, zeros(1,floor(N/2)-not(mod(N,2)))];
end