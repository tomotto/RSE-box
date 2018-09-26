function rseBox_info
%RSEBOX  Displays a list of all RSE-box functions. 
%
% Demonstration of RSE-box functions:
%   demo01_quantiles  - Demonstration of the RSE-box: Basic RT analysis
%   demo02_later      - Demonstration of the RSE-box: LATER model
%   demo03_race       - Demonstration of the RSE-box: Race model
%
%
% Simulation of reaction times:
%   simLater          - Simulation of reaction times using the LATER model
%   simRace           - Simulation of RSE data with a race model
%   simRaceSimple     - Simulation of RSE data with the independent race model
%
%
% Cumulative distribution functions (CDFs):
%   outCorrect        - Outlier correction
%   sampleDown        - Down-sampling of an empirical CDF
%   getCP             - Computation of cumulative probabilities
%   interpCDF         - Linear interpolation of an empirical CDF
%   laterCDF          - Reci-normal CDF (LATER model)
%   laterINV          - Reci-normal inverse CDF (LATER model)
%   raceCDF           - Race model CDF
%
%
% Basic RSE analysis:
%   getRaab           - Computation of Raab's independent race model
%   getGrice          - Computation of Grice's bound
%   getGain           - Computation of redundancy gain (the RSE)
%   getMiller         - Computation of Miller's bound
%   getViolation      - Computation of Miller's bound violation
%
%
% Model fitting:
%   fitLater          - Fitting of the LATER model
%   bootLater         - Bootstrapping 95% confidence intervals for LATER model fits
%   fitRace           - MLE of the race model (using LATER model fits)
%   bootRace          - Bootstrapping 95% confidence intervals for race model fits
%   fitRaceEta        - MLE of the nested model (eta only)
%   fitRaceRho        - MLE of the nested model (rho only)
%   fitRse            - Fitting of all 3 RSE conditions (6 parameter model)
%   bootRse           - Bootstrapping 95% confidence intervals for race model fits
%   fitRseEta         - MLE of the nested model (5 parameters, eta as only race model parameter)
%   fitRseRho         - MLE of the nested model (5 parameters, rho as only race model parameter)
%   fitRseRaab        - MLE of the nested model (4 parameters, independent race model)
%
%
% Model functions:
%   maxNormPDF        - Computes the PDF of the maximum of two Gaussian random
%   maxNormCDF        - Computes the CDF of the maximum of two Gaussian random
%   minNormPDF        - Computes the PDF of the minimum of two Gaussian random
%   minNormCDF        - Computes the CDF of the minimum of two Gaussian random
%   t-function        - Owen's t-function (external code)
%
%
% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

help rseBox_info

end