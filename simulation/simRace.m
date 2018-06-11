function data = simRace( n, mu, sigma, rho, eta )
%SIMRACE   Simulates a redundant signals experiment with a race model.
% DATA = SIMRACE(N,MU,SIGMA,RHO,ETA) returns a random sample of reaction
% times in the three conditions of the redundant signals paradigm (two
% single signal conditions, one redundant signals condition). The input
% argument N specifies the number of sample points. Input arguments MU and
% SIGMA are two element vectors that specify the mean and standard
% deviation of reci-normal distributions to sample reaction times in the
% single signal conditions (LATER model; Noorani & Carpenter, 2016). If
% MU/SIGMA are scalars, the same value is used for both single signal
% conditions. To sample reaction times in the redundant signals condition,
% the input arguments RHO (correlation) and ETA (noise) specify the race
% model (Otto & Mamassian, 2012). If no input arguments are provided, a set
% of default parameters is used. The output argument DATA is a sorted
% N-by-3 matrix of reaction times, with the first two columns for the two
% single signal conditions and the third column for the redundant signals
% condition.
%
% References:
% Noorani & Carpenter (2016). The LATER model of reaction time and
% decision. Neuroscience and Biobehavioral Reviews, 64, 229-251.
% Otto & Mamassian (2012). Noise and correlations in parallel perceptual
% decision making. Current Biology, 22(15), 1391-1396.
%
% Prerequisites:
% Requires functions MVNRND (Matlab's Statistics and Machine Learning
% Toolbox)
%
% See also: demo01_quantiles, demo03_race, simRaceSimple, simLater

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check for required functions
if ~exist( 'mvnrnd', 'file' )
    error( 'Requires function MVNRND (Statistics and Machine Learning Toolbox)' )
end

% Check input argument N
if exist( 'n', 'var' )
    if rem( n, 1 )~=0 || n<=0
        error( 'The input argument N needs to be a positive integer.' )
    elseif ~isscalar( n )
        error( 'The input argument N needs to be a scalar.' )
    end
else
    % Default value
    n = 50;
end

% Check input argument MU
if exist( 'mu', 'var' )
    if isscalar( mu )
        mu(2) = mu(1);
    elseif length( mu )>2 || ~isvector( mu )
        error('The input argument MU needs to be a scalar or a two element vector.')
    end
else
    % Default values
    mu = [2.5 2.5];
end

% Check input argument SD
if exist( 'sigma', 'var' )
    if isscalar( sigma )
        sigma(2) = sigma(1);
    elseif length( sigma )>2 || ~isvector( sigma )
        error('The input argument SIGMA needs to be a scalar or a two element vector.')
    end
else
    % Default values
    sigma = [0.4 0.4];
end

% Check input argument RHO
if exist( 'rho', 'var' )
    if ~isscalar( rho )
        error('The input argument RHO needs to be a scalar')
    end
else
    % Default value
    rho = 0;
end

% Check input argument ETA
if exist( 'eta', 'var' )
    if ~isscalar( eta )
        error('The input argument ETA needs to be a scalar')
    end
else
    % Default value
    eta = 0;
end

% Rates in the two single signal conditions 
% (random sample using the LATER model)
data(:,1) = simLater( n, mu(1), sigma(1) );
data(:,2) = simLater( n, mu(2), sigma(2) );

% Rates in the redundant signal condition
% (random sample using the race model)
sigma = sigma + eta;
sigma = [ sigma(1)^2,  rho*sigma(1)*sigma(2); rho*sigma(1)*sigma(2), sigma(2)^2 ];
rate = max( mvnrnd( mu, sigma, n ), [], 2 );
rate( rate<0 ) = 0;

% Get reaction times from the reciprocal of the rates 
% and sort DATA
data(:,3) = sort( 1 ./ rate );

end