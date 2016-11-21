% Build a band pass filter by the window method
% N: size of filter
% fc1: left cut frequence, in Hz
% fc2: rigth cut frequence, in Hz. It must be greater than fc2
% w: window used to build the filter. It must be of size N
function h = window_band_pass(N, fc1, fc2, w, varargin)
    hlp = window_low_pass(N,fc2,w);
    hhp = window_high_pass(N,fc1,w);
    h = hhp - hlp';
    plot = 0;
    if not(isempty(varargin))
        plot = varargin{1,1};
    end
    if plot == 1
        spectrum_plot(h,1,'All',1024,0);
    end
end