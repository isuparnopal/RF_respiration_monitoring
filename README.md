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

Respiratory rate (the number of breaths you take per minute) is an important physiological indicator of a person's health. It is regularly used in monitoring health conditions such as sleep apnea, chronic obstructive pulmonary disease and asthama. Additionally, in the current environment of COVID-19 - a respiratory virus infection, respiratory rate is one of the most important vital signs that is monitored in patients. Currently, there are well developed methods for monitoring respiratory rate in clinical settings, such as by using a respiratory chest band. However, these methods involve placing instruments on the body and do not lend themselves well to applications involving continous and remote monitoring of respiratory rate. The purpose of this project is to demonstrate non-invasive and passive monitoring of respiratory rate using RF signals. By using a 2.4 GHz RF carrier signal generated on a Pluto SDR - which lies in the commercial WiFi frequency range, and a receiver, we study how transmitted message signals are modulated by a person's respiration and extract these respiration related features from the received baseband signal using filtering techniques. We develop a pipeline combining various signal processing approaches suggested in literature to estimate respiratory rate from these extracted features and finally, validate the accuracy of our measurements. 

### Current Work

Current methods to monitor respiratory rate using wireless signals typcially explore the amplitude/phase related changes of transmitted signals due to chest movements that accompany the process of respiration. <Chandan or Stephan> 


## Techical Approach

### System Modelling

The approach we have chosen to pursue involves studying the amplitude related changes of a transmitted message signal due to a person's respiration, as proposed in WiBreathe [1]. The system is modelled as shown below.  





A sinusoidal message signal, very close to baseband frequency, such as 5 kHz is continously transmitted on a 2.4 GHz carrier using an AM scheme on the Pluto SDR. As the frequency of the carrier signal is much higher than the message signal, the final transmitted signal can be approximated as:  

<p align="center">
Acos(2πf<sub>c</sub>t)
</p>

where A is the amplitude of the transmitted signal and f<sub>c</sub> is the frequency of the 2.4 GHz carrier signal. The transmitted signal is reflected from the user's body and chest movements caused due to respiration alter the magnitude of the reflected signal, presenting as an amplitude modulation of the transmitted signal. The amplitude modulated signal can be represented as:

<p align="center">
Ar(t)cos(2πf<sub>c</sub>t)
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

As the signal above is modulated by respiration, extracting its envelope will provide a good approximation of the respiration signal r(t). We have thus designed an envelope detector in simulink by squaring the signal and further downsampling it from 1 Msps to 200 Hz. This is sufficient as the normal range of respiration in humans is between 0.2 to 0.5 Hz. We further low pass filter the signal to eliminate the high frequency energy and the square root of the resultant signal provides us with the desired envelope. The envelope data and sampling times are transferred to a MATLAB workspace for post processing to estimate respiratry rate.

The figure below shows the real-time extracted envelope plotted against time using a Simulink time scope for a 30s window. The initial peaking in the envelope is caused because the envelope detector takes some time to stabilize. We do not consider these envelope samples in our processing script described in the following section. 

<p align="center">
<img width="1920" alt="Envelope" src="https://user-images.githubusercontent.com/73725580/102267874-5c24cc80-3ecf-11eb-9aa7-bef022a9b0ae.png">
Fig.3. Extracted real-time envelope
</p>

### Estimating Respiratory Rate













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
