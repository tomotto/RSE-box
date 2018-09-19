function x = laterINV( y, mu, sigma )
%LATERINV   Reci-normal inverse cumulative distribution function.
% X = LATERINV(Y,MU,SIGMA) returns the inverse cdf of a reci-normal
% distribution, which is defined as the distribution of a random variable,
% whose reciprocal is normally distributed with mean MU and standard
% deviation SIGMA (LATER model; Noorani & Carpenter, 2016). The function
% computes the inverse cdf at each value in Y using the specified values
% for the mean MU and standard deviation SIGMA. Y contains cummulative
% probabilities (with values between 0 nd 1). SIGMA must be positive
%
% Reference:
% Noorani & Carpenter (2016). The LATER model of reaction time and
% decision. Neuroscience and Biobehavioral Reviews, 64, 229-251.
%
% See also demo02_later, laterCDF, simLater, fitLater

% © 2018 Logical Calculus Lab, University of St Andrews
%        http://lclab.wp.st-andrews.ac.uk/

% Compute inverse cdf
x = 1 ./ norminv( 1 - y , mu, sigma );

% Check for out of bound values 
x( x<=0 ) = NaN;

end