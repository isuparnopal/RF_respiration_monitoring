% Plot all variational modes of signal
% 
% imf  = vmd(env);
% 
% len = length(imf(1,:));
% 
% for i = 1:len
%     nexttile
%     plot(imf(:,i))
%     txt = ['IMF',num2str(i)];
%     ylabel(txt)
%     xlabel('Samples')
%     grid on
% end


% findpeaks(imf(:,5))
% xlabel('time')
% ylabel('Respiration Signal')
% title('Respiration Peaks')


% Pipeline code

env = [];

if mod(length(envelope.data),2) == 0 %Ensuring l is always even as FFT requires an even length
    l = length(envelope.data);
else
    l = length(envelope.data)-1;
end
    
for i = 801:l  %Discarding the first few samples from 30s envelope due to instability
    env = [env; envelope.data(:,:,i)];
end

imf  = vmd(env,'NumIMFs',4);

%Plotting each Variational Mode

len = length(imf(1,:));

for i = 1:len
    figure(1)
    nexttile
    plot(imf(:,i))
    txt = ['IMF',num2str(i)];
    ylabel(txt)
    xlabel('Samples')
    grid on
end


Fs = 200;            % Sampling frequency                    
T = 1/Fs;            % Sampling period   

L = length(imf(:,3));    % Length of signal
    
Y = fft(imf(:,3));

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;

figure(2)
nexttile
plot(f,20*log10(P1)) 
title('IMF3 FFT')
ylabel('|P1(f)|')
xlabel('f (Hz)')
xlim([0.1 1])
grid on

% Plotting FFT of each variational mode

% for i = 1:len      
%     L = length(imf(:,i));     % Length of signal
%     
%     Y = fft(imf(:,i));
% 
%     P2 = abs(Y/L);
%     P1 = P2(1:L/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
% 
%     f = Fs*(0:(L/2))/L;
%     
%     figure(2)
%     nexttile
%     plot(f,20*log10(P1)) 
%     txt = ['IMF',num2str(i),' FFT'];
%     title(txt)
%     ylabel('|P1(f)|')
%     xlabel('f (Hz)')
%     xlim([0.1 1])
%     grid on
% end

