% Aplies a window w (time domain) to a given signal x (time domain)
% A fft of size 1024 is aplied on both x and w, and the results are 
% multiplied together
% TODO: make size of fft an optionl parameter
function Y = windowing(x,w)
    X = fft(x,1024);
    W = fft(w,1024);
    Y = X.*W;
end