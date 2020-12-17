## RF Based Respiration Monitoring

UCLA ECE M202A Project, Fall 2020  
Website URL:  

<!-- TABLE OF CONTENTS -->

  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#Overall Project Goals">Overall Project Goals</a>
      <ul>
        <li><a href="#abstract">Abstract</a></li>
        <li><a href="#current-work">Current Work</a></li>
      </ul>
    </li>
    <li>
      <a href="#technical-approach">Technical Approach</a>
      <ul>
        <li><a href="#system-modelling">System Modelling</a></li>
        <li><a href="#extracting-the-respiration-signal">Extracting the Respiration Signal</a></li>
        <li><a href="#estimating-respiratory-rate">Estimating Respiratory Rate</a></li>   
        <li><a href="#attempted-but-discontinued-approaches">Attempted but Discontinued Approaches</a></li> 
      </ul>
    </li>
    <li>
      <a href="#evaluation">Evaluation</a>
      <ul>
        <li><a href="#experimental-setup">Experimental Setup</a></li>
        <li><a href="#results">Results</a></li>
      </ul>
    </li>
    <li><a href="#strengths-and-weaknesses">Strengths and Weaknesses</a></li>
    <li><a href="#future-directions">Future Directions</a></li>
    <li><a href="#references">References</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## Overall Project Goals

### Abstract

Respiratory rate (the number of breaths you take per minute) is an important physiological indicator of a person's health. It is regularly used in monitoring health conditions such as sleep apnea, chronic obstructive pulmonary disease and asthama. Additionally, in the current environment of COVID-19 - a respiratory virus infection, respiratory rate is one of the most important vital signs that is monitored in patients. Currently, there are well developed methods for monitoring respiratory rate in clinical settings, such as by using a respiratory chest band. However, these methods involve placing instruments on the body and do not lend themselves well to applications involving continous and non-invasive monitoring of respiratory rate. The purpose of this project is to demonstrate non-invasive and passive monitoring of respiratory rate using RF signals. By using a 2.4 GHz RF carrier signal generated on a Pluto SDR - which lies in the commercial WiFi frequency range, and a receiver, we study how transmitted message signals are modulated by a person's respiration and extract these respiration related features from the received baseband signal using filtering techniques. We develop a pipeline combining various signal processing approaches suggested in literature to estimate respiratory rate from these extracted features and finally, validate the accuracy of our measurements. 

### Current Work

The research community is currently focused on the use of two different techniques for vital signs detection by means of RF signals: continuous wave (CW) radars and ultra-wideband(UWB) radars. UWB radars transmit short pulses with pulse duration of the order of nanoseconds. These type of radars, as well as CW radars, are able to detect the movement of a target by measuring the low-Doppler variation that affects the received backscattered signal. UWB radars also provide a range resolution that permits to eliminate the interfering pulses due to reflections of other targets in the field of view. CW radars are more simple systems than the UWB radars and the receiver is independent of the target distance [5].  Work has been done by Kaltiokallio et al. to extract breathing with very low error over a single TX/RX link [6]. Similarly, microwave sensors used in the frequency range of 2.42 GHz detect the I and Q components of the backscattered field due to breathing when placed directly above the user’s chest at a distance of 1m.

[7] shows experimentally that standard wireless networks which measure received signal strength (RSS) can also be used to reliably detect human breathing and estimate the respiratory rate. Additonally, techniques that exploit the amplitude modulation of a transmitted RF signal by respiration have also shown to accurately estimate respiratory rate [1]. Work done by [7] shows that beyond link amplitudes and network-wide frequency estimates, there is also information to be gathered in the phase of the sinusoidal signal due to the person’s breathing, in particular for links which have a high amplitude. [8] shows that if the heartbeat and breathing signals are to be monitored, demodulating the phase will then give a signal that is proportional to the chest-wall position that contains information about movement due to heartbeat and respiration. 


## Techical Approach

### System Modelling

The approach we have chosen to pursue involves studying the amplitude related changes of a transmitted message signal due to a person's respiration, as proposed in WiBreathe [1]. The system is modelled as shown below.  





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

The main objective at the Pluto receiver is to extract this respiration signal m(t) from the demodulated baseband signal. Pluto provides access to the the in-phase (I) and quadrature (Q) components of the received baseband signal which are processed through a configureable quadrature demodulator and baseband processing block located inside the Pluto hardware. We configure our TX-RX pair with a baseband sampling rate of 1 Msps and a gain of 15 dB which was experimentally found to be sensitive enough to discern the effects of amplitude modulation on our received signal, while still maintaining the noise floor at acceptably low levels.  
  
The amplitude of the baseband signal is reconstructed from the I and Q components of the demodulated signal, using the formula below:

<p align="center">
<img width="136" alt="Screenshot 2020-12-14 at 6 48 44 PM" src="https://user-images.githubusercontent.com/73725580/102161900-0b649380-3e3d-11eb-93ee-cfd25ad582f4.png">
</p>

The spectrum of the demodulated signal is shown below after filtering around our chosen baseband frequency.

<p align="center">
<img width="1920" alt="Baseband Signal Spectrum" src="https://user-images.githubusercontent.com/73725580/102162211-a3627d00-3e3d-11eb-8ca6-17aabfc182c5.png">
Fig.1. Spectrum of Baseband Signal
</p>

The extracted amplitude of this baseband signal is plotted against time using a Simulink time scope for a 30s window and it shows the amplitude modulation effect of respiration.

<p align="center">
<img width="1920" alt="Baseband Signal Time" src="https://user-images.githubusercontent.com/73725580/102162568-3e5b5700-3e3e-11eb-973f-057bdffe7a24.png">
Fig.2. Amplitude of Baseband Signal vs. Time 
</p>

The above steps are all accomplished by designing filtering and mathematical blocks in Simulink, in conjunction with the RX model of Pluto.  

As the signal above is modulated by respiration, extracting its envelope will provide a good approximation of the respiration signal r(t). We have thus designed an envelope detector in simulink by squaring the signal and further downsampling it from 1 Msps to 200 Hz. This is sufficient as the normal range of respiration in humans is between 0.16 to 0.6 Hz [2]. We further low pass filter the signal using an FIR LPF block to eliminate the high frequency energy and the square root of the resultant signal provides us with the desired envelope. The envelope data and sampling times are transferred to a MATLAB workspace for post processing to estimate respiratory rate. The designed Simulink workspace is shown below.

<p align="center">
<img width="1181" alt="Screenshot 2020-12-15 at 3 44 44 PM" src="https://user-images.githubusercontent.com/73725580/102286270-d44dbb00-3eec-11eb-8cc1-8558335a2e4f.png">
Fig.3. Simulink Processing Block
</p>

The figure below shows the real-time extracted envelope plotted against time using a Simulink time scope for a 30s window. The initial peaking in the envelope is caused because the envelope detector takes some time to stabilize. We do not consider these envelope samples in our processing script described in the following section. 

<p align="center">
<img width="1920" alt="Envelope" src="https://user-images.githubusercontent.com/73725580/102267874-5c24cc80-3ecf-11eb-9aa7-bef022a9b0ae.png">
Fig.4. Extracted real-time envelope
</p>

### Estimating Respiratory Rate

The envelope above contains information about the respiration signal r(t). However, it is also corrupted by reflections of the RF signal from nearby objects, minor movements in the user's body and interfering devices in the 2.4 GHz band. Therefore, to separate the respiration signal from these interferences, we apply the Variational Mode Decomposition (VMD) algorithm to decompose the signal into its various frequency modes, similar to that suggested in V2iFi[2]. The VMD algorithm decomposes the envelope into a number of signals around a central frequency with a narrow bandiwdth, and is implemented in MATLAB. Separating the envelope signal into its narrowband intrinsic mode functions (IMFs), we obtain the following modes: 

<p align="center">
<img width="1920" alt="VMD" src="https://user-images.githubusercontent.com/73725580/102282750-f09a2980-3ee5-11eb-9ff5-2769a29524a1.png">
Fig.5. Intrinsic modes of the Envelope
</p>

The noisy envelope signal has been decomposed above to provide us with the respiration signal r(t) (IMF3), and various other noise components - verified by taking FFT's of each of the IMF's and checking whether they lie in the human respiration frequency band between 0.16 to 0.6 Hz. To estimate the respiratory rate from this signal, we divide it into 30s windows and calculate the FFT of the 30s window signal. We select the peak frequency of this IMF in the range of 0.16 to 0.6 Hz as our respiratory rate, following a method similar to that suggested in WiBreathe [1]. The FFT of IMF3 is shown below with the amplitude in decibels, exhibiting a clear peak. The peak frequency of this IMF corresponds to a respiratory rate of 0.269 Hz or 16.14 breaths per minute.

<p align="center">
<img width="1451" alt="Screenshot 2020-12-15 at 3 22 02 PM" src="https://user-images.githubusercontent.com/73725580/102284685-7370b380-3ee9-11eb-9a62-60f83bcd4980.png">
Fig.6. FFT of Respiration IMF
</p>

Alternatively, another approach to estimate respiratory rate from IMF3 in the time domain is through the method of peaksearch. In this technique, we observe a 30s window of the above IMF3. Using MATLAB's internal function 'findpeaks' and specifying a minimum threshold separation of 1s (less than the period corresponding to 0.6 Hz), respiratory rate is estimated by taking the average of horizontal distance of consecutive peaks as the time period of our signal and dividing 60 by this time period. The estimated respiratory rate using this method for our example is 15.79 breaths per minute.

Our final estimate is obtained by taking the average of respiratory rates obtained from the time and frequency domain methods outlined above, and is 15.96 breaths per minute. This is very close to our measured respiratory rate of 16 breaths per minute. 

### Attempted but Discontinued Approaches

Attempts were made to estimate respiratory rate using other methods suggested in literature such as Received Signal Strength (RSS) and phase modulation. The RSS based method was found to provide too low a sensitivity to differentiate between respiratory signals through experimental evaluation in our application. For the phase based method, the phase of the baseband signal was deconstructed from the I and Q components through the arctan of Q/I in Simulink. The phase based method relies on the change in phase between the transmitted and received signal caused due to the chest movements associated with respiration. The change in phase ϕ(t) between transmitted and received RF signal of wavelength λ, for varying distances d(t) is related as [3]:

<p align="center">
<img width="151" alt="Screenshot 2020-12-15 at 8 11 39 PM" src="https://user-images.githubusercontent.com/73725580/102304228-d37b5000-3f11-11eb-9508-201c89d542d9.png">
</p>

Although this method seemed promising, it was discontinued due to problems of uncertain phase noise and insufficient sensitivity to varying respiratory rates. 

## Evaluation

### Experimental Setup

Our experiments are conducted with the Pluto SDR. The radio is configured to continuously transmit a message signal on a 2.4 GHz carrier. We set the baseband sampling rate to 1 Msps and use 5000 samples per frame. Our radio is connected to a computer to visualize the received baseband signal, and its envelope in real time. The post processing steps are performed after data collection. In our investigation, two different setups were explored: single radio setup and two radio Fresnel zone setup.

In the single radio set up a pluto SDR was kept 45 cm from the users chest. This is meant to miror a use case in which respiration monitoring happens passively, multiple times a day, as the user works on their laptop. Each reading of respiratory rate is estimated using the algorithm described above by monitoring the user's breathing for a period of 30 seconds. Concurrently, the number of breaths that the user takes is counted manually. At the end, the counted number of breaths and the respritory rate determined by our algorithm is compared to determine if we have accurately measured the respiratory rate. A picture of our experimental setup is shown below.

<p align="center">
<img width="453" alt="Screenshot 2020-12-16 at 8 49 57 PM" src="https://user-images.githubusercontent.com/73725580/102446278-3fc58480-3fe2-11eb-8fe5-f76c114e2fc7.png">  
</p>

<p align="center">
Fig. 7. Single Radio Set Up
</p>  

In the two radio set up, an attempt was made to replicate the concept of Freznel zones suggested in [4]. We placed two Pluto radios at a distance of appproximately 140 cm apart. Taking these two radio positions as our focii, concentric ellipses are approximately estimated using the formula from [4] shown below corresponding to our carrier wavelength of 12.5 cm (2.4 GHz).

<p align="center">
<img width="457" alt="Screenshot 2020-12-16 at 9 28 03 PM" src="https://user-images.githubusercontent.com/73725580/102447808-a4361300-3fe5-11eb-9472-b572b3f8429b.png">
</p>  

P<sub>1</sub> and P<sub>2</sub> are the loacation of the radio's and Q<sub>n</sub> represents a point on the ellipse. The first fresnel zone is the region inside the first ellipse. The subsequent Fresnel zones are the elliptical annuli between the confocal ellipsoids. Noting resuls from the paper, we tried our best to place our user in the middle of an inner Fresnel zone. A picture of our experimental setup is shown below. This approach was later abandoned due to the low strength of received signal and an increase in spurious reflections.

<p align="center">
<img width="519" alt="Screenshot 2020-12-16 at 9 55 13 PM" src="https://user-images.githubusercontent.com/73725580/102449567-6cc96580-3fe9-11eb-857c-edc6b844c3f9.png">
</p> 

<p align="center">
Fig. 8. Attempted Two Radio Set Up
</p> 

### Results

Using the experimental technique described above for a single radio set up, respiratory rate of a subject was estimated using our algorithm by purposely varying respiratory rate between 9 breaths per minute to 22 breaths per minute. We collect 30 seconds of the user's breathing data and feed it into our algorithm. The table below lists the results obtained.

<p align="center">
<img width="648" alt="Screenshot 2020-12-16 at 11 02 30 PM" src="https://user-images.githubusercontent.com/73725580/102454396-ceda9880-3ff2-11eb-998f-0aff9c410266.png">
</p> 

In the table above, counted BPM is the breaths per minute obtained by manual counting, the FFT peak breaths per minute is obtained by multiplying the peak frequency estimate from the FFT peak method by 60, and peak search BPM is the breaths per minute obtained by the peaksearch method described in the earlier section. Our final estimated respiratory rate is obtained by averaging the results from the FFT peak and peaksearch methods. The last column displays the absolue error in estimation using our algorithm. 

We obtain a mean absolute error (MAE) of **0.11 bpm** using our estimation algorithm. This is lower than an MAE of 0.24 bpm and 0.29 bpm obtained individually from the FFT peak method and peaksearch methods respectively. The absolute estimation errors using the various methods are visualized in the graph below. 

<p align="center">
<img width="566" alt="Screenshot 2020-12-16 at 11 48 49 PM" src="https://user-images.githubusercontent.com/73725580/102458582-4f03fc80-3ff9-11eb-9da4-bd9272ae249d.png">
</p> 

## Strengths and Weaknesses

The main strength of our experimental set up lies in its simplicity: it is clean, accurate and repeatable. Moreover, it provides a proof of concept for passive respiratory rate estimation using COTS radios. Our results indicate that our implementation delivered accurate and reliable respritory rate mesurements. Moreover, our combined use of both the FFT peak and peaksearch based methods managed to reduce the MAE in respiratory rate estimation. However, we still believe that our project can be further refined. 

Our raw respiratory rates can be better estimated by respiration monitor belts, instead of manually counting the breaths per minute. Additonally, we believe that we can further improve our estimation accuracy by combining several other algorithms based on received signal strength, phase change, and by using multiple transmitters and receivers. We could then design an optimization function by providing varying weights to estimates obtained from each individual method. Another promising approach is by training an ML model based on phase/amplitude changes in IQ signal with varying carrier frequencies. This method was not followed due to our difficulty in generating labels for our training data. Further, our implementation of the Fresnel zones was not as successful as we expected, and did not deliver all of the benefits promised. We believe that incorporating some of these things can further improve our obtained results.

## Future Directions

Future work on this project could be focused on tailoring our results to specific applications. As mentioned previously there are numerous applications where our design could be used. We will discuss some uses in the market for the breathing rate monitor and how we may have to change our design to implement these solutions. 

First, respiratory rates are one of the conditions for COVID-19 patients to be taken off of a ventilator. If there respiratory rate “remains above 35 breaths per minute for 5 minutes” or more then they cannot be removed from the ventilator footnote [9] . Our system would be able to monitor the breathing of the patient and tell the doctor if they can or cannot meet this requirement. Very little would have to be changed to implement our design through certification from the Federal Communications Commission (FCC) and FDA. Second, athletes often monitor breathing as it is very important to tracking the progress and preformance during conditioning. It has been studied  that the breathing rate is an important factor corelated to physical fitness [10]. Here, we would likely have to do some miniturization of the device to make it wearable though implemtation in its current form could be used inside a gym for certain sports. Finally, sleep can be monitored best by tracking breathing patterns [11]. Good sleep is essential to avoid mental illness and other health issues. Many wearable technologies are already trying to accomplish this, and our device can help with this aim. It could potentially also be used in detection of conditions such as sleep apnea. In conclusion, we believe that there are many marketable applications for our device that would be valuable to many potential customers.

## References

[1] Ravichandran, Ruth, et al. "WiBreathe: Estimating respiration rate using wireless signals in natural settings in the home." 2015 IEEE International Conference on Pervasive Computing and Communications (PerCom). IEEE, 2015.

[2] Zheng, Tianyue, et al. "V2iFi: in-Vehicle Vital Sign Monitoring via Compact RF Sensing." Proceedings of the ACM on Interactive, Mobile, Wearable and Ubiquitous Technologies 4.2 (2020): 1-27.

[3] Michler, Fabian, et al. "A clinically evaluated interferometric continuous-wave radar system for the contactless measurement of human vital parameters." Sensors 19.11 (2019): 2492.

[4] Zhang, Daqing, Hao Wang, and Dan Wu. "Toward centimeter-scale human activity sensing with Wi-Fi signals." Computer 50.1 (2017): 48-57.

[5] Dei, Devis, et al. "Non-contact detection of breathing using a microwave sensor." Sensors 9.4 (2009): 2574-2585.

[6] Kaltiokallio, Ossi, et al. "Catch a breath: Non-invasive respiration rate monitoring via wireless communication." arXiv preprint arXiv:1307.0084 (2013).

[7] Patwari, Neal, et al. "Monitoring breathing via signal strength in wireless networks." IEEE Transactions on Mobile Computing 13.8 (2013): 1774-1786.

[8] Xiao, Yanming, et al. "Frequency-tuning technique for remote detection of heartbeat and respiration using low-power double-sideband transmission in the Ka-band." IEEE Transactions on Microwave Theory and Techniques 54.5 (2006): 2023-2032.

[9] Nitta, Kenichi, et al. "A comprehensive protocol for ventilator weaning and extubation: a prospective observational study." Journal of intensive care 7.1 (2019): 50.

[10] Nicolò, Andrea, Carlo Massaroni, and Louis Passfield. "Respiratory frequency during exercise: the neglected physiological measure." Frontiers in physiology 8 (2017): 922.

[11] De Zambotti, Massimiliano, et al. "Wearable sleep technology in clinical and research settings." Medicine and science in sports and exercise 51.7 (2019): 1538.







