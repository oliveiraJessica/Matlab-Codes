%% BER comparison between ZF-LE, ZR-DFE and MLSE equalization
N = 10000; % msg length
preamble = [1 1]; % used in the mlse function
msg = randi([0 1] , 1, N) *2 - 1; % BPSK modulation
tx = [preamble msg];
N = length(tx);

M = [1 0.5 0.2]; % M(z)
z = filter(M,1,tx); 

EbNo = 0:16; % dB
ber_zf = zeros(1,length(EbNo));
ber_dfe = zeros(1,length(EbNo));
ber_mlse = zeros(1,length(EbNo));

for i=1:length(EbNo)
data = awgn(z, EbNo(i));
    
%% ZF-LE
a_eq = ZF_LE(M, data);
a_zf = BPSK_demod(a_eq);
ber_zf(i) = sum(a_zf-tx ~= 0)/N;

%% ZE-DFE
a_dfe = ZF_DFE(M,data);
ber_dfe(i) = sum(a_dfe(3:end)-tx ~= 0)/N;

%% Viterbi
const = [-1 1];
tblen = 2;  
a_mlse = mlseeq(data, M',const,tblen,'rst',1,preamble,[]);
ber_mlse(i) = sum(a_mlse-tx ~= 0)/N;
end

figure;
semilogy(EbNo,ber_zf);
hold on
semilogy(EbNo,ber_dfe);
hold on
semilogy(EbNo,ber_mlse);
legend('ZF-LE', 'ZF-DFE', 'MLSE')
xlabel('SNR (dB)')
ylabel('BER')
title('Comparison between ZF-LE, ZF-DFE and MLSE')

