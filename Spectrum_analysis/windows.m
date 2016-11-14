function w = winndows(N)
    r = rectwin(N); %new boxcar function
    b = bartlett(N);
    h = hanning(N);
    m = hamming(N);
    k = blackman(N);
    w = [r,b,h,m,k];

    % Time analysis
    n= [1:N];
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
end