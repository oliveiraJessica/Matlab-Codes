% Build a low pass filter by the window method
% N: size of filter
% fc: cut frequence, in Hz
% w: window used to build the filter. It must be of size N
function h = window_high_pass(N, fc, w)        
    hlp = window_low_pass(N,fc,w);
    imp = all_pass(N);
    h = hlp'-imp;
    spectrum_plot(h,1,'All',1024,0)
end

function imp = all_pass(N)
    imp = [zeros(1,floor(N/2)), 1, zeros(1,floor(N/2))];
end