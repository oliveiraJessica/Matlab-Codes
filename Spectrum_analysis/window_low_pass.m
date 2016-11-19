% Build a low pass filter by the window method
% N: size of filter
% fc: cut frequence, in Hz
% w: window used to build the filter. It must be of size N
function h = window_low_pass(N, fc, w) 
    n = 0:N-1;   
    lp = 2*fc.*sinc((n-floor(N/2))*(2*fc));
    b = w;
    h = lp(:).*b(:);
    spectrum_plot(h,1,'All',1024,0);
end