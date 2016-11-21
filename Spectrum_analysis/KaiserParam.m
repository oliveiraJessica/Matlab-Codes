function [N, beta] = KaiserParam(delta, delta_omega)

A = -20.*log10(delta)

beta = zeros(1,length(delta));
for i=1:length(delta)
if A(1,i) > 50
    beta(1,i) = 0.1102*(A(1,i) - 8.7);
elseif A(1,i) > 21
    beta(1,i) = 0.5842*(A(1,i) - 21)^0.4 + 0.7886*(A(1,i)-21);
end

N = (A-8)./(2.285.*delta_omega) + 1;
% plot beta vs omega
end

