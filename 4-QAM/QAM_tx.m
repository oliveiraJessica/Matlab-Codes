%% A 4-QAM transmitter
% Code done by Jéssica Oliveira (https://github.com/oliveiraJessica)
% for a Digital Communcation discipline.

%% Paramiters
N = 16; % length of data to be transmited
T = 5; % sample time
m = log2(4);
oversample = 100; % oversample factor of the shape pulse
fc = oversample/(T*2)-5; %% max of oversample/(T*2)

% random data
bits = round(rand(1,N));
%% Mapper

r = mod(N,m);
if r
    bits = [bits zeros(1,m-r)]
end

bits_agr = zeros(ceil(length(bits)/m),m);
for i=1:length(bits_agr)
    bits_agr(i,:) = bits(m*(i-1)+1:m*i);
end
mappr_out = bi2de(bits_agr,'left-msb');
mapping = [1+j 1-j -1+j -1-j];
mappr_out = mapping(mappr_out+1);

mapper = zeros(1,length(mappr_out)*oversample);
for i=0:length(mappr_out)-1
   mapper(1,i*oversample+1) = mappr_out(i+1);
end

% Constelation
figure
scatter(real(mappr_out),imag(mappr_out));
title('Output signal constelation');

%% Interpolador
t = [-4*T/2:T/oversample:4*T/2]
rco = raisedcos(t,T,0.8);
aki = conv(real(mapper),rco);
akq = conv(imag(mapper),rco);

 figure
 subplot(1,3,1)
 stem(real(mapper));
 subplot(1,3,2)
 stem(rco)
 subplot(1,3,3)
 x= [1:oversample:length(mapper)];
 plot(x+length(rco)/2,real(mapper(1:oversample:end)),'o',[1:length(aki)],aki,'k');
 title('Real Parte');

 figure
 subplot(1,3,1);
 stem(imag(mapper),'g');
 subplot(1,3,2);
 stem(rco,'g');
 subplot(1,3,3);
 x= [1:oversample:length(mapper)];
 plot(x+length(rco)/2,imag(mapper(1:oversample:end)),'og',[1:length(akq)],akq,'k');
 title('Imaginary Parte');

% Eye diagram
 shift = length(rco)+length(oversample);
 eyediagram(aki(shift:end-shift),oversample);
 title('Shape pulse eye diagram - Quadrature')
 eyediagram(akq(shift:end-shift),oversample);
 title('Shape pulse eye diagram - Phase')

 
%% Upconverter
t = [0:T/oversample:(length(aki)-1)*T/oversample];

si = sqrt(2)*aki.*cos(2*pi*fc*t);
sq = sqrt(2)*akq.*sin(2*pi*fc*t);
s = si-sq;
figure;plot(s);

% Espectrum
figure
subplot(1,2,1);
bb = aki-akq;
pwelch(bb,[],[],[],oversample/T,'centered');
title('Base band spectrum');
subplot(1,2,2);
pwelch(s,[],[],[],oversample/T,'twosided');
title('Pass Band spectrum');