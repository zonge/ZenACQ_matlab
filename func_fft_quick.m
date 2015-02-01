function [mag] = func_fft_quick(ts,f)
NFFT=length(ts);                             % Length of Ts
y = fft(ts(1:NFFT),NFFT)/NFFT*2;          % fft
%f = Fs/2*linspace(0,1,NFFT/2+1)';         % generate freq
mag=abs(y(1:length(f)));                  % Mag
%phase=angle(y(1:length(f)))*1000; % Phase
end