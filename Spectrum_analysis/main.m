%% Spectrum Analysis
% Code done by Jéssica Oliveira (https://github.com/oliveiraJessica)
% for a Digital Processing discipline.
%%
% This project contain the following subjects:
% - Windowing 
%%

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
fs = 128e3;
t = -length(w)/(2*fs):1/fs:length(w)/(2*fs)-(1/fs);
f0 = 30e3;
x = cos(2*pi*f0*t);
w_vector = windows(128);
for i=1:size(w_vector,2)
    y = windowing(x,w_vector(:,i)');
    [Y, YdB] = spectrum_plot(y,fs,'All',1024,0);
end