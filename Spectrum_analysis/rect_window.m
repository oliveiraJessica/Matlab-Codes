% Makes a rectangular windown with size N
% Plot its spectrum if plot is 1. Default value is 0
function w = rect_window(N,Fs, varargin)
% TODO: make Fs an optional parameter
%       adapt to accept vectors of N

   n = -N :1/Fs: N;
   w = [zeros(1,floor(N/2)), ones(1,N), zeros(1,ceil(N/2))];

   nVars = length(varargin);

if nVars >= 1
   if varargin{1}== 1
    [W, Wb] = spectrum_plot(w,Fs,'All',1024);      
    x = floor(3/(2*N)*length(Wb)+length(Wb)/2);
    max_sidelobe = Wb(floor(3/(2*N)*length(Wb)+length(Wb)/2));    
    title(['Janela retangular, ', num2str(N)]);    
    hold on
    plot(3/(2*N),max_sidelobe, '.r');
    legend('magnitude', ['max sidelobe (' num2str(max_sidelobe) ')'])
   end
end
end