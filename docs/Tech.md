## Techical Approach

### System Modelling

The approach we have chosen to pursue involves studying the amplitude related changes of a transmitted message signal due to a person's respiration, as proposed in WiBreathe [1]. The system is modelled as shown below.  

<p align="center">
<img width="1416" alt="Screenshot 2020-12-18 at 11 20 57 AM" src="https://user-images.githubusercontent.com/73725580/102653019-3859c480-4123-11eb-94bd-8277f5f0d3d4.png">
Fig.1. Overview of Developed System
</p>

A sinusoidal message signal, very close to baseband frequency, such as 5 kHz is continously transmitted on a 2.4 GHz carrier using an AM scheme on the Pluto SDR. As the frequency of the carrier signal is much higher than the message signal, the final transmitted signal can be approximated as:  

<p align="center">
Acos(2πf<sub>c</sub>t)
</p>

where A is the amplitude of the transmitted signal and f<sub>c</sub> is the frequency of the 2.4 GHz carrier signal. The transmitted signal is reflected from the user's body and chest movements caused due to respiration alter the magnitude of the reflected signal, presenting as an amplitude modulation of the transmitted signal. The amplitude modulated signal can be represented as:

<p align="center">
r(t)Acos(2πf<sub>c</sub>t)
</p>

where r(t) represents the respiration signal that modulates the transmitted RF signal. This signal is received at the Pluto receiver.

### Extracting the Respiration Signal

The main objective at the Pluto receiver is to extract this respiration signal r(t) from the demodulated baseband signal. Pluto provides access to the the in-phase (I) and quadrature (Q) components of the received baseband signal which are processed through a configureable quadrature demodulator and baseband processing block located inside the Pluto hardware. We configure our TX-RX pair with a baseband sampling rate of 1 Msps and a gain of 15 dB which was experimentally found to be sensitive enough to discern the effects of amplitude modulation on our received signal, while still maintaining the noise floor at acceptably low levels.  
  
The amplitude of the baseband signal is reconstructed from the I and Q components of the demodulated signal, using the formula below:

<p align="center">
<img width="136" alt="Screenshot 2020-12-14 at 6 48 44 PM" src="https://user-images.githubusercontent.com/73725580/102161900-0b649380-3e3d-11eb-93ee-cfd25ad582f4.png">
</p>

The spectrum of the demodulated signal is shown below after filtering around our chosen baseband frequency.

<p align="center">
<img width="1920" alt="Baseband Signal Spectrum" src="https://user-images.githubusercontent.com/73725580/102162211-a3627d00-3e3d-11eb-8ca6-17aabfc182c5.png">
Fig.2. Spectrum of Baseband Signal
</p>

The extracted amplitude of this baseband signal is plotted against time using a Simulink time scope for a 30s window and it shows the amplitude modulation effect of respiration.

<p align="center">
<img width="1920" alt="Baseband Signal Time" src="https://user-images.githubusercontent.com/73725580/102162568-3e5b5700-3e3e-11eb-973f-057bdffe7a24.png">
Fig.3. Amplitude of Baseband Signal vs. Time 
</p>

The above steps are all accomplished by designing filtering and mathematical blocks in Simulink, in conjunction with the RX model of Pluto.  

As the signal above is modulated by respiration, extracting its envelope will provide a good approximation of the respiration signal r(t). We have thus designed an envelope detector in simulink by squaring the signal and further downsampling it from 1 Msps to 200 Hz. This is sufficient as the normal range of respiration in humans is between 0.16 to 0.6 Hz [2]. We further low pass filter the signal using an FIR LPF block to eliminate the high frequency energy and the square root of the resultant signal provides us with the desired envelope. The envelope data and sampling times are transferred to a MATLAB workspace for post processing to estimate respiratory rate. The designed Simulink workspace is shown below.

<p align="center">
<img width="1181" alt="Screenshot 2020-12-15 at 3 44 44 PM" src="https://user-images.githubusercontent.com/73725580/102286270-d44dbb00-3eec-11eb-8cc1-8558335a2e4f.png">
Fig.4. Simulink Processing Block
</p>

The figure below shows the real-time extracted envelope plotted against time using a Simulink time scope for a 30s window. The initial peaking in the envelope is caused because the envelope detector takes some time to stabilize. We do not consider these envelope samples in our processing script described in the following section. 

<p align="center">
<img width="1920" alt="Envelope" src="https://user-images.githubusercontent.com/73725580/102267874-5c24cc80-3ecf-11eb-9aa7-bef022a9b0ae.png">
Fig.5. Extracted real-time envelope
</p>

### Estimating Respiratory Rate

The envelope above contains information about the respiration signal r(t). However, it is also corrupted by reflections of the RF signal from nearby objects, minor movements in the user's body and interfering devices in the 2.4 GHz band. Therefore, to separate the respiration signal from these interferences, we apply the Variational Mode Decomposition (VMD) algorithm to decompose the signal into its various frequency modes, similar to that suggested in V2iFi[2]. The VMD algorithm decomposes the envelope into a number of signals around a central frequency with a narrow bandiwdth, and is implemented in MATLAB. Separating the envelope signal into its narrowband intrinsic mode functions (IMFs), we obtain the following modes: 

<p align="center">
<img width="1920" alt="VMD" src="https://user-images.githubusercontent.com/73725580/102282750-f09a2980-3ee5-11eb-9ff5-2769a29524a1.png">
Fig.6. Intrinsic modes of the Envelope
</p>

The noisy envelope signal has been decomposed above to provide us with the respiration signal r(t) (IMF3), and various other noise components - verified by taking FFT's of each of the IMF's and checking whether they lie in the human respiration frequency band between 0.16 to 0.6 Hz. To estimate the respiratory rate from this signal, we divide it into 30s windows and calculate the FFT of the 30s window signal. We select the peak frequency of this IMF in the range of 0.16 to 0.6 Hz as our respiratory rate, following a method similar to that suggested in WiBreathe [1]. The FFT of IMF3 is shown below with the amplitude in decibels, exhibiting a clear peak. The peak frequency of this IMF corresponds to a respiratory rate of 0.269 Hz or 16.14 breaths per minute.

<p align="center">
<img width="1451" alt="Screenshot 2020-12-15 at 3 22 02 PM" src="https://user-images.githubusercontent.com/73725580/102284685-7370b380-3ee9-11eb-9a62-60f83bcd4980.png">
Fig.7. FFT of Respiration IMF
</p>

Alternatively, another approach to estimate respiratory rate from IMF3 in the time domain is through the method of peaksearch. In this technique, we observe a 30s window of the above IMF3. Using MATLAB's internal function 'findpeaks' and specifying a minimum threshold separation of 1s (less than the period corresponding to 0.6 Hz), respiratory rate is estimated by taking the average of horizontal distance of consecutive peaks as the time period of our signal and dividing 60 by this time period. The estimated respiratory rate using this method for our example is 15.79 breaths per minute.

Our final estimate is obtained by taking the average of respiratory rates obtained from the time and frequency domain methods outlined above, and is 15.96 breaths per minute. This is very close to our measured respiratory rate of 16 breaths per minute. 

### Attempted but Discontinued Approaches

Attempts were made to estimate respiratory rate using other methods suggested in literature such as Received Signal Strength (RSS) and phase modulation. The RSS based method was found to provide too low a sensitivity to differentiate between respiratory signals through experimental evaluation in our application. For the phase based method, the phase of the baseband signal was deconstructed from the I and Q components through the arctan of Q/I in Simulink. The phase based method relies on the change in phase between the transmitted and received signal caused due to the chest movements associated with respiration. The change in phase ϕ(t) between transmitted and received RF signal of wavelength λ, for varying distances d(t) is related as [3]:

<p align="center">
<img width="151" alt="Screenshot 2020-12-15 at 8 11 39 PM" src="https://user-images.githubusercontent.com/73725580/102304228-d37b5000-3f11-11eb-9508-201c89d542d9.png">
</p>

Although this method seemed promising, it was discontinued due to problems of uncertain phase noise and insufficient sensitivity to varying respiratory rates. 
