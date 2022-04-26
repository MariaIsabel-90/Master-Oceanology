## Master-Oceanology

In this repository I present a summary of the methodology and results from my Masters in Oceanology taken in the University of Rio Grande, as well as the Matlab scripts.

## Main goal of this work 

From my dissertation: 
>  I used daily sea level anomaly maps from January 2008 to December 2013 to identify Agulhas rings. Data from ARGO floats that were caught or crossed the rings path were used for he reconstruction of the mean vertical structure of the ring.

## Eddy tracking

The eddy tracking was done with Evan Mason's python toolbox py-eddytracker described in:
 [https://www.researchgate.net/publication/262797488]


## Vertical reconstruction

The Matlab scripts for eddies vertical temperature and salinity reconstruction are available in this repository. The steps were:
- Read and clean Argo floats data 
- Find Argo profiles that crossed the ediies whithin +-2 days and 2 times their radius
- Put weigths on this data in order to assemble them into a single, mean, cross-section
- Calculate temperature and salinity anomalies
- Calculate heat and salt transport

## Code's repository

### Matlab
- Plot of the study area and the eddie's tracks
- Argo floats data analysis
- Locating the right Argo profiles
- Data assemblage
- Cross-section
- Temperature and salinity anomaly



