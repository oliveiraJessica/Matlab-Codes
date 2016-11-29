function w = windows(N)
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
    W = fft(w,1024);
    WdB = zeros(size(W));
    for i = 1 : size(W,2)
        WdB(:,i) = mag2db(abs(W(:,i))/max(abs(W(:,i))));
    end
    Fs = 1;    
    f = linspace(-Fs/2,Fs/2,N);
    figure;plot(f,WdB(1:length(f),:));
    xlabel('digital frequency');
    ylim([-90 0]);
    ylabel('dB');
    legend('Retangular', 'Bartlett', 'Hanning', 'Hamming', 'Blackman')
    grid on;
end