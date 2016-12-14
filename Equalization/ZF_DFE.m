% Implements a DFE Zero Forcing equalization for a BPSK modulation
%
% a_zf = ZF_DFE(M, data) returns the data equalized by a zero forcing
% DFE equalizer. Where M is a vector representing the channel
% coeficients and data is a vector with the input data to be equalized
function a_dfe = ZF_DFE( M, data )
mem = M(2:end);
N = length(data);
a_dfe = zeros(1,N+2);
for  i=3:length(data)+2    
     z_2 = a_dfe(i-2)*mem(2);
     z_1 = a_dfe(i-1)*mem(1);
     
     data_eq = data(i-2)-z_1-z_2;
     if data_eq < 0
        a_dfe(i) = -1;
     else
         a_dfe(i) = 1;     
     end 
     %a_dfe(i) = BPSK_demod( data_eq );   
end

end

