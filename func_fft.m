function [mag,f,NFFT,phase] = func_fft(ts,Fs)
L=length(ts);                             % Length of Ts
NFFT = 2^(nextpow2(L+1)-1);                % NFFT
y = fft(ts(1:NFFT),NFFT)/NFFT*2;          % fft
f = Fs/2*linspace(0,1,NFFT/2+1)';         % generate freq
mag=abs(y(1:length(f)));                  % Mag
phase=angle(y(1:length(f)))*1000; % Phase
end