function y = minNormCDF( x, mu, sigma, rho )
%MAXNORMCDF   Minimum of two correlated Gaussian random variables.
% Y = MINNORMCDF(X,MU,SIGMA,RHO) returns the cdf of the minimum of two
% correlated Gaussian random variables (Nadarajah & Kotz, 2008). Input
% variables MU and SIGMA are two-element vectors to specify the mean and
% standard deviation of the two Gaussian distributions. Input argument RHO
% is a scalar to set the correlation coefficient (between -1 and 1).
%
% Warning: 
% Temporary function, the computation uses Owen's T function for a
% workaround, which is missing a mathematical proof.
%
% Reference:
% Nadarajah & Kotz (2008). Exact distribution of the max/min of two
% Gaussian random variables. IEEE Transactions on Very Large Scale
% Integration (VLSI) Systems, 16(2), 210-212.
% Owen (1956). Tables for computing bivariate normal probabilities. Annals
% of Mathematical Statistics, 27, 1075–1090
%
% Prerequisites:
% Requires functions NORMPDF and NORMCDF (Matlab's Statistics and Machine
% Learning Toolbox)
% Owen's T function needs to be known (tha.m can be downloaded from
% http://people.sc.fsu.edu/~jburkardt/m_src/asa076/asa076.html).
%
% See also minNormPDF, maxNormPDF, maxNormCDF

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

x1 = ( x - mu(1) ) / sigma(1);
x2 = ( x - mu(2) ) / sigma(2);

a1 = rho - x2 ./ x1;
a2 = rho - x1 ./ x2;

r = sqrt(1 - rho^2);

t1 = zeros( size(x) );
t2 = zeros( size(x) );
for i=1:length(x)
     t1(i) = tha( x1(i), 1,  a1(i), r );
     t2(i) = tha( x2(i), 1,  a2(i), r );
end

y = 0.5 * normcdf( x1 ) - t1 + ...
    0.5 * normcdf( x2 ) - t2;

% Shift the function for x-values between mu(1) and mu(2)
idx = ( x>mu(1) & x<mu(2) ) | ( x>mu(2) & x<mu(1) );
y(idx) = y(idx) + 0.5;

% Interpolation for x-values equal to mu(1) or mu(2)
idx = x==mu(1);
if sum(idx)>0
    y(idx) = mean( minNormCDF( mu(1)+[-1e-10 1e-10], mu, sigma, rho ) );
end
idx = x==mu(2);
if sum(idx)>0
    y(idx) = mean( minNormCDF( mu(2)+[1e-10 1e-10], mu, sigma, rho ) );
end

end
