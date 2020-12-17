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
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
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

In the single radio set up a pluto SDR was kept 45 cm from the users chest. This is meant to miror a use case in which respiration monitoring happens passively, multiple times a day, as the user works on their laptop. Each reading of respiratory rate is estimated using the algorithm described above by monitoring the user's breathing for a period of 30 seconds. Concurrently, the number of breaths that the user takes is counted manually. At the end, the counted number of breaths and the respritory rate determined by our algorithm is compared to determine if we have accurately messured the respiratory rate. A picture of our experimental setup is shown below.

<p align="center">
<img width="453" alt="Screenshot 2020-12-16 at 8 49 57 PM" src="https://user-images.githubusercontent.com/73725580/102446278-3fc58480-3fe2-11eb-8fe5-f76c114e2fc7.png">  
</p>

<p align="center">
Fig. 7. Single Radio Set Up
</p>  

In the two radio set up, an attempt was made to replicate the concept of Fresnel zones suggested in [4]. We placed two Pluto radios at a distance of appproximately 140 cm apart. Taking these two radio positions as our focii, concentric ellipses are approximately estimated using the formula from [4] shown below corresponding to our carrier wavelength of 12.5 cm (2.4 GHz).

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

In the table above, counted BPM is the breaths per minute obtained by manual counting, the FFT peak breaths per minute is obtained by multiplying the peak frequency estimate from the FFT peak method by 60, and peak search BPM is the breaths per minute obtained by the peaksearch method described in the earlier section. Our final estimated respiratory rate is obtained by averaging the results from the FFT peak and peaksearch methods. The last column displays the absolue error in estimation using our algorithm. We obtain a mean absolute error (MAE) of **0.11 bpm** using our estimation algorithm. This is lower than an MAE of 0.24 bpm and 0.29 bpm obtained individually from the FFT peak method and peaksearch methods respectively. 












## Strenghts and Weaknesses
The single radio set up clearly delivered the best results. The experimental set up was clean, accirate and easy to repeate. From the results section it is easy to see that this implementation delivered accurate and reliable respritory rate mesurements. Our use of both FFT and peak detection offers innovative algorithm to determine the respiritory rates to a high degree of accuracy. On the other hand our baseline could have been done more professionally than simply counting breaths. We ordered a breathing belt to help take these measurements but due to a delay in the shipping we were not able to use it. Further our implementation of the fresnel zones was not as successful as we expected and did not deliver all of the benefits promised in the Zhang, wang, Wu 2017 paper. Overall we are very pleased with the promissing results of the our project and belive that our implentation is an elegant solution.

## Future Directions
Future work on this project would be focused tailoring our promising results to specific applications. As mentioned previously there are numerous applications where our design could be used. We will discuss some uses in the market for the breathing rate monitor and how we may have to change our design to implement these solutions. 

First, breathing rates are one of the conditions for COVID-19 patients to be taken off of a ventilator. If there
breathing rate “remains above 35 breaths per minute for 5 minutes” or more then the cannot be removed from the ventilator footnote [2] . Our system would be able to monitor the breathing of the patient and tell the doctor if they can orcannot meet this requirement. Very little would have to be changed to implement our design though certification through the Federal Communications Commission (FCC) and FDA. Second, Athletes often monitor breathing as it is very important to tracking the progress and preformance during conditioning. It has been studied (footnote [3]) that the breathing rate is an important factor corelated to physical fitness. Here we would likely have to do some miniturization of the device to make it wearable though implemtation in its current form could be used inside a gym for certain sports. Finally, sleep can be monitored best by tracking breathing patterns(footnote [4]). Good sleep is essential to stay avoid mental issness and other health issues. Many wearable technologies are already trying to accomplish this. In conclusion we beleive there are many marketable applications for our device that would be valuable to many potential customers.

footnotes:
[2] M. Khamiees, P., Nishimura, M., &amp; Y. Zhu, H. (1970, January 01). A comprehensive protocol
for ventilator weaning and extubation: A prospective observational study. Retrieved
December 08, 2020, from
https://jintensivecare.biomedcentral.com/articles/10.1186/s40560-019-0402-4

[3] Nicolò, A., Massaroni, C., &amp; Passfield, L. (2017). Respiratory Frequency during Exercise: The
Neglected Physiological Measure. Frontiers in Physiology, 8.
doi:10.3389/fphys.2017.00922

[4]Cellini, M., &amp; Goldstone, A. (2019, July). Wearable Sleep Technology in Clinical and Research
Settings. Retrieved December 08, 2020, from https://pubmed.ncbi.nlm.nih.gov/30789439/

### References

[1] Ravichandran, Ruth, et al. "WiBreathe: Estimating respiration rate using wireless signals in natural settings in the home." 2015 IEEE International Conference on Pervasive Computing and Communications (PerCom). IEEE, 2015.

[2] Zheng, Tianyue, et al. "V2iFi: in-Vehicle Vital Sign Monitoring via Compact RF Sensing." Proceedings of the ACM on Interactive, Mobile, Wearable and Ubiquitous Technologies 4.2 (2020): 1-27.

[3] Michler, Fabian, et al. "A clinically evaluated interferometric continuous-wave radar system for the contactless measurement of human vital parameters." Sensors 19.11 (2019): 2492.

[4] Zhang, Daqing, Hao Wang, and Dan Wu. "Toward centimeter-scale human activity sensing with Wi-Fi signals." Computer 50.1 (2017): 48-57.

[5] Dei, Devis, et al. "Non-contact detection of breathing using a microwave sensor." Sensors 9.4 (2009): 2574-2585.

[6] Kaltiokallio, Ossi, et al. "Catch a breath: Non-invasive respiration rate monitoring via wireless communication." arXiv preprint arXiv:1307.0084 (2013).

[7] Patwari, Neal, et al. "Monitoring breathing via signal strength in wireless networks." IEEE Transactions on Mobile Computing 13.8 (2013): 1774-1786.

[8] Xiao, Yanming, et al. "Frequency-tuning technique for remote detection of heartbeat and respiration using low-power double-sideband transmission in the Ka-band." IEEE Transactions on Microwave Theory and Techniques 54.5 (2006): 2023-2032.


























### Prerequisites

This is an example of how to list things you need to use the software and how to install them.
* npm
  ```sh
  npm install npm@latest -g
  ```

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/github_username/repo_name.git
   ```
2. Install NPM packages
   ```sh
   npm install
   ```



<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_



<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/github_username/repo_name/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Your Name - [@twitter_handle](https://twitter.com/twitter_handle) - email

Project Link: [https://github.com/github_username/repo_name](https://github.com/github_username/repo_name)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* []()
* []()
* []()





<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/github_username/repo.svg?style=for-the-badge
[contributors-url]: https://github.com/github_username/repo/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/github_username/repo.svg?style=for-the-badge
[forks-url]: https://github.com/github_username/repo/network/members
[stars-shield]: https://img.shields.io/github/stars/github_username/repo.svg?style=for-the-badge
[stars-url]: https://github.com/github_username/repo/stargazers
[issues-shield]: https://img.shields.io/github/issues/github_username/repo.svg?style=for-the-badge
[issues-url]: https://github.com/github_username/repo/issues
[license-shield]: https://img.shields.io/github/license/github_username/repo.svg?style=for-the-badge
[license-url]: https://github.com/github_username/repo/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/github_username
