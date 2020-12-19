env = [];

if mod(length(envelope.data),2) == 0 %Ensuring l is always even as FFT requires an even length
    l = length(envelope.data);
else
    l = length(envelope.data)-1;
end
    
for i = 801:l  %Discarding the first few samples from 30s envelope due to instability
    env = [env; envelope.data(:,:,i)];
end

t = envelope.time;

% Code for FFT of envelope

Fs = 200;            % Sampling frequency                    
T = 1/Fs;            % Sampling period       
L = length(env);     % Length of signal

Y = fft(env);
 
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;

plot(f,20*log10(P1)) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
xlim([0.1 1])





