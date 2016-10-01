%% A 4-QAM Receiver
% Code done by Jéssica Oliveira (https://github.com/oliveiraJessica)
% for a Digital Communcation discipline.

%% Downconverter        
ri = sqrt(2)*r.*cos(2*pi*fc*t);
rq = -sqrt(2)*r.*sin(2*pi*fc*t);

figure; title('Pass Band. Downconverter Output');
subplot(1,2,1); plot(ri);
subplot(1,2,2); plot(rq);
%% Matched Filter
t = [-4*T/2:T/oversample:4*T/2]
rco = flipdim(raisedcos(t,T,0.8),2);
yhi = conv(ri,rco,'valid');
yhq = conv(rq,rco,'valid');

figure; title('Matched filter output');
subplot(1,2,1); plot(yhi);
subplot(1,2,2); plot(yhq);

eyediagram(yhi,oversample);
title('Eye diagram - real part')
eyediagram(yhq,oversample);
title('Eye diagram - imaginary part')

yhi = yhi(1:oversample:end);
yhq = yhq(1:oversample:end);
figure
subplot(1,2,1);stem(yhi);
subplot(1,2,2);stem(yhq);

%% Slicer
E = sum(rco)/mean(rco);

figure;
scatter(yhi/E,yhq/E);
title('Output constelation');


y_out = zeros(1,2*length(yhi));

for i = 2:2:length(y_out)
    if yhi(i/2) > 0    
        y_out(i-1) = 0;
    else
        y_out(i-1) = 1;       
    end

    if yhq(i/2) > 0
        y_out(i) = 0;    
    else
        y_out(i) = 1;       
    end
end

