function a = BPSK_demod( data )
    a = zeros(1,length(data));
    for j = 1:length(data)
        if data(j)>0
            a(j) = 1;
         else
            a(j) = -1;     
        end   
    end
end

