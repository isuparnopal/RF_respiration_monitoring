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

The research community is currently focused on the use of two different techniques for vital signs detection by means of RF signals: continuous wave (CW) radars and ultra-wideband(UWB) radars. UWB radars transmit short pulses with pulse duration of the order of nanoseconds. These type of radars, as well as CW radars, are able to detect the movement of a target by measuring the low-Doppler variation that affects the received backscattered signal. UWB radars also provide a range resolution that permits to eliminate the interfering pulses due to reflections of other targets in the field of view. CW radars are more simple systems than the UWB radars and the receiver is independent of the target distance.  Work has been done by Kaltiokallio et al. to extract breathing with very low error over a single TX/RX link [9]. Similarly, microwave sensors used in the frequency range of 2.42 GHz detect the I and Q components of the backscattered field due to breathing when placed directly above the user’s chest at a distance of 1m.

[1109.3898] shows experimentally that standard wireless networks which measure received signal strength (RSS) can also be used to reliably detect human breathing and estimate the respiratory rate. Additonally, techniques that exploit the amplitude modulation of a transmitted RF signal by respiration have also shown to accurately estimate respiratory rate [1]. Work done by [1109.3898] shows that beyond link amplitudes and network-wide frequency estimates, there is also information to be gathered in the phase of the sinusoidal signal due to the person’s breathing, in particular for links which have a high amplitude. [01629044] shows that if the heartbeat and breathing signals are to be monitored, demodulating the phase will then give a signal that is proportional to the chest-wall position that contains information about movement due to heartbeat and respiration. 


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

The noisy envelope signal has been decomposed above to provide us with the respiration signal r(t) (IMF3), and various other noise components - verified by taking FFT's of each of the IMF's and checking whether they lie in the human respiration frequency band between 0.16 to 0.6 Hz. To estimate the respiratory rate from this signal, we divide it into 30s windows and calculate the FFT of the 30s window signal. We select the peak frequency of this IMF in the range of 0.16 to 0.6 Hz as our respiratory rate, following a method similar to that suggested in WiBreathe [1]. The FFT of IMF3 is shown below, exhibiting a clear peak. The peak frequency of this IMF corresponds to a respiratory rate of 0.269 Hz or 16.14 breaths per minute.

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
Experimental setup is a key portion of any scientific study. It is important to main a clean set up without and variations to ensure that all results are accurate and repeatable. In this investigation two different setups were used: single radio setup and two radio fresnal zone setup.

In the single radio set up a pluto SDR was kept 45 cm from the users chest. Breathing is monitored via amplitude modulation as described in the Extracting the Respiration Signal section for a period of 30 seconds. Concurrently, the number of breaths that the user takes is counted manually. At the end the counted number of breaths and the respritory rate determined by our algorithm is compared to determine if we have accurately messured the respritory rate.

In the two radio set up was an attempt to implement the Fresnel zones. We refer to footnote 1 for a brief explanation of fresnel zones, and used this approach in out implementation. 

“Fresnel zones refer to the series of concentric ellipsoids of alternating strength that are caused by a light or radio wave following multiple paths as it propagates in free space, resulting in constructive and destructive interference as the different-length paths go in and out of phase. Assuming P1 and P2 are two radio transceivers (see Figure 1a), the Fresnel zones are the concentric ellipsoids with foci in the pair of transceivers. For a given radio wavelength λ, Fresnel zones containing n ellipsoids can be constructed by ensuring that |P1Qn| + | QnP2| – | P1P2| = nλ/2 , where Qn is a point in the nth ellipse”
We implemented these fresnal zones with our two Pluto SDR, positioning them accordingly. 

footnote [1] Zhang, D., Wang, H., & Wu, D. (2017). Toward Centimeter-Scale Human Activity Sensing with Wi-Fi Signals. Computer, 50(1), 48-57. doi:10.1109/mc.2017.7



### Results


## Strenghts and Weaknesses

## Future Directions

































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
