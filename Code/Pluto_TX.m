
%Transmit 5 burst pulses and then continuously transmit

fs = 1e6;
sw = dsp.SineWave;
sw.Amplitude = 0.5;
sw.Frequency = 5e3;
sw.ComplexOutput = true;
sw.SampleRate = fs;
sw.SamplesPerFrame = 5000; % to meet waveform size requirements
tx_waveform = sw();

radio = sdrtx('Pluto');
radio.CenterFrequency = 2.4e9;
radio.BasebandSampleRate = fs;
radio.Gain = 0;

runtime = tic;
while toc(runtime) < 5
    transmitRepeat(radio,tx_waveform);
end

