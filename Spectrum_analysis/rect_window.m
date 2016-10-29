function rect_window(N)
    n = -N :1: N;
   w = [zeros(1,floor(N/2)), ones(1,N), zeros(1,ceil(N/2))];

   % 1024 points FFT
   Y = fft(w,1024);
   W = fftshift(Y);
   figure;
   subplot(3,1,1);
   stem(w);
   xlabel('n');
   ylabel('amplitude');
   title('Rectangular window' );
   subplot(3,1,2);
   plot(abs(W));
   xlabel('Digital frequency');
   ylabel('magnitude');
   subplot(3,1,3);
   plot(mag2db(abs(W)));
   xlabel('digital frequency');
   title('Magnitude spectrum for rectangular window	N')

   end