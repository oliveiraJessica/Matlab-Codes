% Aplies a window w (time domain) to a given signal x (time domain)
% A fft of size 1024 is aplied on both x and w, and the results are 
% multiplied together
% TODO: make size of fft an optionl parameter
function y = windowing(x,w)
    figure;
    title('Windowing (time domain)');
    subplot(3,1,1);
    plot(x);
    subplot(3,1,2);plot(w);
    y = x(1:length(w)).*w;
    subplot(3,1,3);plot(y);
end