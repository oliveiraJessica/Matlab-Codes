%% Overlap and Add / Overlap and Save methods
% Code done by Jéssica Oliveira (https://github.com/oliveiraJessica)
% for a Digital Signal Process Discipline.
%%
% Implementation of both methods (Overlap and save and overlap and add)
% for discrete convolution, also compared
% with the regular linear convolution
%%
close all;
clear all;

%% Initial parameters
P = 2;      % Impulse response size
M = 12;     % Input sequence size M>>P
t = 0 : 0.01 : 100;
h = cos(2*pi*60*t);% Impulse response
h = h(1:P);
x = cos(2*pi*20*t);% Input sequence
x = x(1:M);

%%%%%%%%%%%%%%%%%%%%%%
%% Linear Convolution%
%%%%%%%%%%%%%%%%%%%%%%
ycl = conv(x,h);

figure(1)
subplot(2,3,1)
stem(x)
title('input x[n]');
subplot(2,3,2)
stem(h)
title('impulse response h[n]');
subplot(2,3,4)
stem(ycl)
title('linear convolution');

%%%%%%%%%%%%%%%%%%%%%%
% DFT                %
%%%%%%%%%%%%%%%%%%%%%%
x_fft = fft(x,M);
h_fft = fft(h,M);

y_fft = x_fft .* h_fft;
ydft = ifft(y_fft, M);

%subplot(2,3,4)
%stem(y_fft)

%%%%%%%%%%%%%%%%%%%%%%
%% Overlap and add   %
%%%%%%%%%%%%%%%%%%%%%%
L = 4;
%Zero padding of length mod(L,M) if M is not multiple of L
x1 = x;
if mod(M,L) > 0
   x1 = [x zeros(1,L-mod(M,L))]; % line vector
end

ya = zeros(1,M+P-1);

for i=1:ceil(M/L)
    % Input divided into blocks of size L 
    xp = x1((i-1)*L+1:i*L);
    
    % Convolution of each block with the impulse response - L < P
    yp = conv(xp,h);
    % Sum conv. result with a shift of i*L    
    ya((i-1)*L+1:(i-1)*L+L+P-1) = yp + ya((i-1)*L+1:(i-1)*L+L+P-1);
end

subplot(2,3,5)
stem(ya)
title('overlap and add')

%%%%%%%%%%%%%%%%%%%%%%
%% Overlap and save  %
%%%%%%%%%%%%%%%%%%%%%%
% Input (of size M) divided into blocks of size N = L+P-1. Each block
% overlaps of p-1 samples
N = L+P-1;

%Zero padding of length mod(L,M) if M is not multiple of L
x1 = x;
% P-1 zeros of the previous block
x1 = [zeros(1,P-1) x1];
if mod(length(x1)-(P-1),L) > 0
   x1 = [x1 zeros(1,L-mod(length(x1)-(P-1),L))]; % line vector
end
ys = 0;

max = ceil((length(x1)-(P-1))/L)-1
for i=0:max
    xp = x1(i*L+1:i*L+N)
    % linear convolution
    yp = conv(xp,h)
    % Each conv. result is the summation of y(n - r) 
    % ( in this case, linear conv. is not equal to circ. conv)
    % discard the P-1 first samples
    % only L valid samples
    yp = yp(:,P:N)
    
    ys = [ys yp];
    
    if i == max
        if xp(N-P-1:N) ~= zeros(1,P-1)
           xp = [xp(N-P-1:N) zeros(1,N-P-1)]
           yp = conv(xp,h);
           yp = yp(:,P:N);
           ys = [ys yp];
        end
    end
end
ys =ys(2:length(ys));
subplot(2,3,6)
stem(ys)
title('overlap and save')