function [ w ] = window_kaiser( N, beta, L, varargin )
%WINDOW_KAISER Summary of this function goes here
%   Detailed explanation goes here
n = 0:L-1;
M = (N-1)./2;
w = besseli(0,beta.*sqrt(1-(2.*(n-M)./(N-1)).^2))./besseli(0,beta);
plot = 0;
    if not(isempty(varargin))
        plot = varargin{1,1};
    end
    if plot == 1
        spectrum_plot(w,1,'All',1024,0)
    end
end

