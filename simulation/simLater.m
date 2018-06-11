function data = simLater( n, mu, sigma, flgSorted )
%SIMLATER   Simulates a reaction time experiment using the LATER model.
% DATA = SIMLATER(N,MU,SIGMA,FLGSORTED) returns a random sample of reaction
% times from a reci-normal distribution, which is defined as the
% distribution of a random variable X, whose reciprocal Y = 1/X is normally
% distributed and which can be used to describe reaction time distributions
% (LATER model; Noorani & Carpenter, 2016). The input argument N specifies
% the number of sample points. The reci-normal distribution is defined by
% input arguments MU and SIGMA. If no input arguments are provided, a set
% of default parameters is used. The output argument DATA is a sorted
% column vector of reaction times. If the optional input argument FLGSORTED
% is set to 0, DATA is returned unsorted.
%
% Reference:
% Noorani & Carpenter (2016). The LATER model of reaction time and
% decision. Neuroscience and Biobehavioral Reviews, 64, 229-251.
%
% See also: demo02_later, simRace, simRaceSimple

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

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
    if ~isscalar( mu )
        error('The input argument MU needs to be a scalar.')
    end
else
    % Default values
    mu = 2.5;
end

% Check input argument SD
if exist( 'sigma', 'var' )
    if ~isscalar( sigma )
        error('The input argument SIGMA needs to be a scalar.')
    end
else
    % Default values
    sigma = 0.4;
end

if ~exist( 'flgSorted', 'var' )
    flgSorted = 1;
end

% Random sample of rates (LATER model)
data = mu + sigma * randn(n,1);

% Get reaction times (reciprocal of rates) and sort DATA
data( data<0 ) = 0;
data =  1 ./ data;

% Sort DATA
if flgSorted
    data = sort( data );
end

end