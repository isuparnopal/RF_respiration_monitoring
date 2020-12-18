## Strengths and Weaknesses

The main strength of our experimental set up lies in its simplicity: it is clean, accurate and repeatable. Moreover, it provides a proof of concept for passive respiratory rate estimation using COTS radios. Our results indicate that our implementation delivered accurate and reliable respiratory rate mesurements. Moreover, our combined use of both the FFT peak and peaksearch based methods managed to reduce the MAE in respiratory rate estimation. However, we still believe that our project can be further refined. 

Our raw respiratory rates can be better estimated by respiration monitor belts, instead of manually counting the breaths per minute. Additonally, we believe that we can further improve our estimation accuracy by combining several other algorithms based on received signal strength, phase change, and by using multiple transmitters and receivers. We could then design an optimization function by providing varying weights to estimates obtained from each individual method. Another promising approach is by training an ML model based on phase/amplitude changes in IQ signal with varying carrier frequencies. This method was not followed due to our difficulty in generating labels for our training data. Further, our implementation of the Fresnel zones was not as successful as we expected, and did not deliver all of the benefits promised. We believe that incorporating some of these things can further improve our obtained results.
