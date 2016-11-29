%% Spectrum Analysis
% Code done by Jéssica Oliveira (https://github.com/oliveiraJessica)
% for a Digital Processing discipline.
%%
% This project contain the following subjects:
% - Windowing 
% - FIR and IIR filter implementation by windowing
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
windows_names = {'Retangular'; 'Bartlett'; 'Hanning'; 'Hamming'; 'Blackman'};
for i=1:size(w_vector,2)
    w = w_vector(:,i);
    fs = 128e3;
    t = -length(w)/(2*fs):1/fs:length(w)/(2*fs)-(1/fs);
    f0 = 30e3;
    x = cos(2*pi*f0*t);
    y = windowing(x,w');
    title(['Windowing - One tone cossine - ', windows_names{i}]);
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
%%%% Rectangular
y = windowing(x,w_vector(:,1)');
spectrum_plot(y,fs,'All',1024,0);

%%%% Hanning
y = windowing(x,w_vector(:,3)');
spectrum_plot(y,fs,'All',1024,0);
title('Windowing - Two tone cossine - Hanning');

% Minimum separation
% decrease df until you can no longer distinguish two separate frequency
% components Do this for both windows
df = 2e3;
x = cos(2*pi*f0*t) + cos(2*pi*(f0+df)*t);
spectrum_plot(x,fs,'All',1024,0);
% Rectangular
y = windowing(x,w_vector(:,1)');
spectrum_plot(y,fs,'All',1024,0);
title(['Windowing - Retangular - df = ', num2str(df), 'Hz']);
% Hanning
y = windowing(x,w_vector(:,3)');
spectrum_plot(y,fs,'All',1024,0);
title(['Windowing - Hanning - df = ', num2str(df), 'Hz']);

%% Filtering
%% FIR Designed by Windowing
% Low pass filter
N = 41;
fc = 1/8;
windows_names = {'Retangular'; 'Bartlett'; 'Hanning'; 'Hamming'; 'Blackman'};
w_vector = windows(N);
for i=1:size(w_vector,2)
    window_low_pass(N,fc, rectwin(N),1);
    title(['FIR - Low Pass - ', windows_names{i}]);
end

% High pass filter
% Ref: http://www.labbookpages.co.uk/audio/firWindowing.html
% all pass - low pass
N = 61;
fc = 7/16;
windows_names = {'Retangular'; 'Bartlett'; 'Hanning'; 'Hamming'; 'Blackman'};
w_vector = windows(N);
for i=1:size(w_vector,2)
    window_high_pass(N,fc,w_vector(:,i),1)   
    title(['FIR - High Pass - ', windows_names{i}]);
end

% Band pass
% high pass - low pass
% fclp > fchp 
fc1 = 1/8;
fc2 = 1/4;
N = 61;
w = hamming(N);
h = window_band_pass(N, fc1, fc2, w,1);
title('Band pass filter - Hamming - N = 61');
N = 23;
w = hamming(N);
h = window_band_pass(N, fc1, fc2, w,1);
title('Band pass filter - Hamming - N = 23');
N = 401;
w = hamming(N);
h = window_band_pass(N, fc1, fc2, w,1);
title('Band pass filter - Hamming - N = 401');

% Kaiser
delta = 0.0001:0.001:0.1;
delta_omega = 0.1;
[N, beta] = KaiserParam(delta, delta_omega);
figure; plot(delta, beta);
ylabel('beta');
xlabel('delta');
title('beta vs delta');

N = 61;
fc = 7/16;
beta = [2,6,9];
for i = 1:length(beta)
    window_high_pass(N,fc,transpose(kaiser(N,beta(i)))',1);
    title(['High pass filter - Kaiser window - ', num2str(beta(i))]);
end

fc = 7/16;
[N, beta] = KaiserParam(0.01, pi/10);
N = ceil(N);
k = kaiser(N,beta);
window_high_pass(N,fc,k,1);
title('High pass filter - Kaiser window');

windows_names = {'Retangular'; 'Bartlett'; 'Hanning'; 'Hamming'; 'Blackman'};
w_vector = windows(N);
for i=1:size(w_vector,2)
    window_high_pass(N,fc,w_vector(:,i)',1)   
    title(['FIR - High Pass - ', windows_names{i}]);
end
%% IIR
N = 5;
fc = 2048; % in Hz
fs = 8192; % in Hz
omega_n = (fc/fs)*2*pi;
Wn =  omega_n/pi;
Rp = 3; % in dB
Rs = 50;% in dB

[b, a] = butter(N,Wn);
p = roots(a);
z = roots(b);
plot_z(p,z);
title('Butterworth pole-zero plot');
figure;freqz(b,a,1024);
title('Butterworth Magnitude - Phase plot');

[b, a] = cheby1(N,Rp,Wn);
p = roots(a);
z = roots(b);
plot_z(p,z);
title('Chebyshev 1 pole-zero plot');
figure;freqz(b,a,1024);
title('Chebyshev 1 Magnitude - Phase plot');

[b, a] = cheby2(N,Rs,Wn);
p = roots(a);
z = roots(b);
plot_z(p,z);
title('Chebyshev 2 pole-zero plot');
figure;freqz(b,a,1024);
title('Chebyshev 2 Magnitude - Phase plot');

[b, a] = ellip(N,Rp,Rs,Wn);
p = roots(a);
z = roots(b);
plot_z(p,z);
title('Elliptic pole-zero plot');
figure;freqz(b,a,1024);
title('Elliptic Magnitude - Phase plot');