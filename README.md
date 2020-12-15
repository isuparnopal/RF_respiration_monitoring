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

The approach we have chosen to pursue involves studying the amplitude related changes of a transmitted message signal due to a person's respiration, as proposed in WiBreathe [1]. The system is modelled as shown below:  





A sinusoidal message signal, very close to baseband frequency, such as 5 kHz is continously transmitted on a 2.4 GHz carrier using an AM scheme on the Pluto SDR. As the frequency of the carrier signal is much higher than the message signal, the final transmitted signal can be approximated as:  

A<sup>c</sup>cos(2\pif<sup>c</sup>t)  

where A<sup>c</sup> and f<sup>c</sup> are the amplitude and  frequency of the 2.4 GHz carrier signal. 





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
