% Implements a Linear Zero Forcing equalization
%
% a_zf = ZF_LE(M, data) returns the data equalized by a zero forcing
% linear equalizer. Where M is a vector representing the channel
% coeficients and data is a vector with the input data to be equalized
function a_zf = ZF_LE( M, data )
    a_zf = filter(1,M,data); 
end

