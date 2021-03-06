% Build a low pass filter by the window method
% N: size of filter
% fc: cut frequence, in Hz
% w: window used to build the filter. It must be of size N
function h = window_low_pass(N, fc, w, varargin) 
    n = 1:N;   
    lp = 2*fc.*sinc((n-ceil(N/2)).*(2*fc));
    b = w;
    h = lp(:).*b(:);
    plot = 0;
    if not(isempty(varargin))
        plot = varargin{1,1};
    end
    if plot == 1
        spectrum_plot(h,1,'All',1024,0);
    end
end