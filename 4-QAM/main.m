%% A 4-QAM transceiver
% Code done by Jéssica Oliveira (https://github.com/oliveiraJessica)
% for a Digital Communcation discipline.
%%
% Implementation of a 4-QAM receiver and transmitter using raised cossine
% for the shape pulse.
%%
clear all;
close all;

QAM_tx;

%% AWGN Channel
No = 0.2;        
r = s + No*randn(1,length(s)); 
figure; plot(r);
title('Noised Signal')

QAM_rx;

stem(y_out-bits);
title('Sended and received bits');