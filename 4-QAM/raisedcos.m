function [ y ] = raisedcos( t,T,b )
for i=1:length(t)
    if t(i) == 0
        y(i) = 1;
     elseif  (2*b*t(i)/T == 1) | (2*b*t(i)/T == -1)
         y(i) = (sin(pi*t(i)/T)/(pi*t(i)/T))*pi/4;
    else
        y(i) = (sin(pi*t(i)/T)/(pi*t(i)/T))*(cos(pi*b*t(i)/T)/(1-(2*b*t(i)/T).^2));
    end
end

