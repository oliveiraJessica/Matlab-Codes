%% Spectrum Analysis
% Code done by Jéssica Oliveira (https://github.com/oliveiraJessica)
% for a Digital Processing discipline.
%%
% This project contain the following subjects:
% - Windowing 
%%

close all;
%% Windowing
% Windowing aplied to anti-aliasing. Limit band to sampling - fs/2
% Mainlobe width and sidelobes hights are main parameters to measure filter
% quality

% For the rectangular window lengths 16,32,41 e 64 compute the DTFT
% and plot the magnitude spectrum on a dB scale. Use the 
% subplot command to put the plots in the same figure

%Rectangular window
N = [16,32,41,64];
for i = 1:length(N)
    rect_window(N(i),1,1);
end

% Plot the magnitude spectrum on linear and dB scale of a couple 
% different types of windows. Use the subplot command to put 
% the plots in the same figure
windows(100);

% Windowing example with one tone cos signal
N = 128;
w_vector = windows(N);
for i=1:size(w_vector,2)
    w = w_vector(:,i);
    fs = 128e3;
    t = -length(w)/(2*fs):1/fs:length(w)/(2*fs)-(1/fs);
    f0 = 30e3;
    x = cos(2*pi*f0*t);
    y = windowing(x,w');
    title('Janelamento - One tone cossine');
    spectrum_plot(y,fs,'All',1024,0);    
end

% Windowing example with two tones cossine signal
% focus only on the Rectangular and Hanning windows
N = 128;
w_vector = windows(N); % rect (1), Hannin (3)
f0 = 30e3;
fs = 128e3;
df = 10e3;
t = -N/(2*fs):1/fs:N/(2*fs)-(1/fs);
x = cos(2*pi*f0*t) + cos(2*pi*(f0+df)*t);
spectrum_plot(x,fs,'All',1024,0);
% Rectangular
y = windowing(x,w_vector(:,1)');
spectrum_plot(y,fs,'All',1024,0);
% Hanning
y = windowing(x,w_vector(:,3)');
spectrum_plot(y,fs,'All',1024,0);
title('Janelamento - Two tone cossine');

% Minimum separation
% decrease df until you can no longer distinguish two separate frequency
% components Do this for both windows
df = 10e3;
x = cos(2*pi*f0*t) + cos(2*pi*(f0+df)*t);
spectrum_plot(x,fs,'All',1024,0);
% Rectangular
y = windowing(x,w_vector(:,1)');
spectrum_plot(y,fs,'All',1024,0);
% Hanning
y = windowing(x,w_vector(:,3)');
spectrum_plot(y,fs,'All',1024,0);
title('Janelamento - Two tone cossine');

%% Filtering
% Low pass filter
N = 41;
fc = 1/8;
window_low_pass(N,fc, rectwin(N));

% High pass filter
% Ref: http://www.labbookpages.co.uk/audio/firWindowing.html
% all pass - low pass
N = 61;
fc = 7/16;
window_high_pass(N,fc,rectwin(N))

% Band pass
% high pass - low pass
% fclp > fchp 
fc1 = 1/4;
fc2 = 1/8;
N = 61;
h = window_band_pass(N, fc1, fc2, w);
N = 23;
h = window_band_pass(N, fc1, fc2, w);
N = 401;
h = window_band_pass(N, fc1, fc2, w);

