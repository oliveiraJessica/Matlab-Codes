% Plots the spectrum of the given signal w (time domain).
% [W, WdB] = spectrum(w,Fs) 
% Plots the signal in time domain and its both linear and dB magnitude 
% in frequency domain
% [W, WdB] = spectrum(w,Fs,plots) 
% Where plots is a string to specify which plots must be shown. 
% Possibles strings: 'All' and 'Linear'. 'All' is the default value.
%
% [W, WdB] = spectrum(w,Fs,plots,N) 
% N is size of FFT. 1024 is the default value
%
% [W, WdB] = spectrum(w,Fs,plots,N, infreq) 
% infreq specifies is the input signal is in frequency domain (infreq = 1)
% or in time domain (infreq = 0), default value.
function varargout = spectrum_plot(w,Fs,varargin)
% TODO: adapt to accept vectors of w

% Optional arg control
nVars = length(varargin);

if nVars < 1
  plots = 'All';
else
  plots = varargin{1};
end
op_plots = {'All', 'Linear'};

if nVars < 2
  N = 1024;  
else
  N = varargin{2};
end

if nVars < 3
  infreq = 0;
else
  infreq = varargin{3};
end

%%%%%%%%%%%%%%%%%
if infreq == 0
    Y = fft(w,N);
else
    Y = w;
end
W = fftshift(Y);
maxW = max(abs(W));
WdB = mag2db(abs(W)/maxW);
f = linspace(-Fs/2,Fs/2,N);

varargout{1} = W;
varargout{2} = WdB;

if strcmp(plots, op_plots(2))
    Nplot = 2;
elseif strcmp(plots, op_plots(1))
    Nplot = 3;
else
    Nplot = 3;
    plots = 'All';
    disp('Choose one of the following: All(Default) or Linear');
end

Nplot = Nplot - infreq;
figure;
if infreq == 0
    subplot(Nplot,1,1);
    plot(w);
    xlabel('n');
    ylabel('amplitude');
    title('Time domain');
    grid on;
end

subplot(Nplot,1,2 - infreq);
plot(f,abs(W));
xlabel('Digital frequency');
ylabel('amplitude spectrum');
grid on;
if not(strcmp(plots, op_plots(2)))
    subplot(Nplot,1,3 - infreq);
    plot(f,WdB);
    xlabel('digital frequency');
    ylim([-50 0]);
    ylabel('dB');
    grid on;
end

end