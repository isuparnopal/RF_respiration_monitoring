## Evaluation

### Experimental Setup

Our experiments are conducted with the Pluto SDR. The radio is configured to continuously transmit a message signal on a 2.4 GHz carrier. We set the baseband sampling rate to 1 Msps and use 5000 samples per frame. Our radio is connected to a computer to visualize the received baseband signal, and its envelope in real time. The post processing steps are performed after data collection. In our investigation, two different setups were explored: single radio setup and two radio Fresnel zone setup.

In the single radio set up a pluto SDR was kept 45 cm from the users chest. This is meant to miror a use case in which respiration monitoring happens passively, multiple times a day, as the user works on their laptop. Each reading of respiratory rate is estimated using the algorithm described above by monitoring the user's breathing for a period of 30 seconds. Concurrently, the number of breaths that the user takes is counted manually. At the end, the counted number of breaths and the respiratory rate determined by our algorithm is compared to determine if we have accurately measured the respiratory rate. A picture of our experimental setup is shown below.

<p align="center">
<img width="453" alt="Screenshot 2020-12-16 at 8 49 57 PM" src="https://user-images.githubusercontent.com/73725580/102446278-3fc58480-3fe2-11eb-8fe5-f76c114e2fc7.png">  
</p>

<p align="center">
Fig. 8. Single Radio Set Up
</p>  

In the two radio set up, an attempt was made to replicate the concept of Freznel zones suggested in [4]. We placed two Pluto radios at a distance of appproximately 140 cm apart. Taking these two radio positions as our focii, concentric ellipses are approximately estimated using the formula from [4] shown below corresponding to our carrier wavelength of 12.5 cm (2.4 GHz).

<p align="center">
<img width="457" alt="Screenshot 2020-12-16 at 9 28 03 PM" src="https://user-images.githubusercontent.com/73725580/102447808-a4361300-3fe5-11eb-9472-b572b3f8429b.png">
</p>  

P<sub>1</sub> and P<sub>2</sub> are the location of the radios and Q<sub>n</sub> represents a point on the ellipse. The first Freznel zone is the region inside the first ellipse. The subsequent Freznel zones are the elliptical annuli between the confocal ellipsoids. Noting resuls from the paper, we tried our best to place our user in the middle of an inner Fresnel zone. A picture of our experimental setup is shown below. This approach was later abandoned due to the low strength of received signal and an increase in spurious reflections.

<p align="center">
<img width="519" alt="Screenshot 2020-12-16 at 9 55 13 PM" src="https://user-images.githubusercontent.com/73725580/102449567-6cc96580-3fe9-11eb-857c-edc6b844c3f9.png">
</p> 

<p align="center">
Fig. 9. Attempted Two Radio Set Up
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
