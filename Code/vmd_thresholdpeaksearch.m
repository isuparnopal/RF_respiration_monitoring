env = [];
rr_peak = 0;

if mod(length(envelope.data),2) == 0 %Ensuring l is always even as FFT requires an even length
    l = length(envelope.data);
else
    l = length(envelope.data)-1;
end
    
for i = 551:l  %Discarding the first few samples from 30s envelope due to instability
    env = [env; envelope.data(:,:,i)];
end

t = envelope.time(551:l);

imf  = vmd(env,'NumIMFs',4);

[pks,locs]  = findpeaks(imf(:,3),t, 'MinPeakDistance', 2, 'MinPeakProminence', 0);
for i = 2:length(locs)
    rr_peak = rr_peak + locs(i) - locs(i-1);
end

RR = ((length(locs)-1)/rr_peak)*60

    


