function y = maxNormPDF( x, mu, sigma, rho )
%MAXNORMPDF   Maximum of two correlated Gaussian random variables.
% Y = MAXNORMPDF(X,MU,SIGMA,RHO) returns the pdf of the maximum of two
% correlated Gaussian random variables (Nadarajah & Kotz, 2008). Input
% variables MU and SIGMA are two-element vectors to specify the mean and
% standard deviation of the two Gaussian distributions. Input argument RHO
% is a scalar to set the correlation coefficient (between -1 and 1).
% 
% Reference:
% Nadarajah & Kotz (2008). Exact distribution of the max/min of two
% Gaussian random variables. IEEE Transactions on Very Large Scale
% Integration (VLSI) Systems, 16(2), 210-212.
%
% Prerequisites:
% Requires functions NORMPDF and NORMCDF (Matlab's Statistics and Machine
% Learning Toolbox)
%
% See also maxNormCDF, minNormPDF, minNormCDF

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details


% Check input argument MU
if ~isvector( mu ) || length( mu )~=2
    error('Input argument MU needs to be a two-element vector.')
end

% Check input argument SIGMA
if ~isvector( sigma ) || length( sigma )~=2
    error('Input argument SIGMA needs to be a two-element vector.')
end
if any( sigma<=0 )
    warning('Values in SIGMA must be positive.')
    sigma( sigma<=0 ) = NaN;
end

% Check input argument RHO
if ~isscalar( rho )
    error('Input argument RHO needs to be a scalar.')
end
if abs( rho )>1
    % RHO must be between -1 and 1, will use the closest bound and continue...
    rho = sign( rho );
end

x1 = ( -x + mu(1) ) / sigma(1);
x2 = ( -x + mu(2) ) / sigma(2);

r  = sqrt( 1 - rho^2 );

y1 = normpdf( x1 ) / sigma(1) .* normcdf( (rho * x1 - x2) / r );
y2 = normpdf( x2 ) / sigma(2) .* normcdf( (rho * x2 - x1) / r );

y = y1 + y2;


end