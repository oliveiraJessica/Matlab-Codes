% Makes a rectangular windown with size N
% Plot its spectrum if plot is 1. Default value is 0
function w = rect_window(N, varargin)
   n = -N :1: N;
   w = [zeros(1,floor(N/2)), ones(1,N), zeros(1,ceil(N/2))];

   nVars = length(varargin);

if nVars >= 1
   if varargin{1}== 1
    spectrum_plot(w,'Linear',1024); 
   end
end
end