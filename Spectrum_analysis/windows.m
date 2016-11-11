r = rectwin(100); %new boxcar function
b = bartlett(100);
h = hanning(100);
m = hamming(100);
k = blackman(100);
w = [r,b,h,m,k];

% Time analysis
n= [1:100];
figure;plot(n,w);
legend('Retangular', 'Bartlett', 'Hanning', 'Hamming', 'Blackman')
% Spectrum analysis
Y = fft(w,1024);
W = fftshift(Y);
WdB = zeros(size(W));
for i = 1 : size(W,2)
    WdB(:,i) = mag2db(abs(W(:,i))/max(abs(W(:,i))));
end
figure;plot(WdB);
xlim([415 615]);
legend('Retangular', 'Bartlett', 'Hanning', 'Hamming', 'Blackman')