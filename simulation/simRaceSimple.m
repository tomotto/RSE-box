function data = simRaceSimple( n, mu, sigma )
%SIMRACESIMPLE   Simulates a redundant signals experiment with a race model.
% DATA = SIMRACESIMPLE(N,MU,SIGMA) returns a random sample of reaction
% times in the three conditions of the redundant signals paradigm (two
% single signal conditions, one redundant signals condition). The input
% argument N specifies the number of sample points. Input arguments MU and
% SIGMA are two element vectors that specify the mean and standard
% deviation of reci-normal distributions to sample reaction times in the
% single signal conditions (LATER model; Noorani & Carpenter, 2016). If
% MU/SIGMA are scalars, both single signal conditions are sampled from the
% same distribution. The independent race model is used to sample reaction
% times in the redundant signals condition (Raab, 1962). If no input
% arguments are provided, a set of default parameters is used. The output
% argument DATA is a sorted N-by-3 matrix of reaction times, with the first
% two columns for the two single signal conditions and the third column for
% the redundant signals condition.
%
% References:
% Noorani & Carpenter (2016). The LATER model of reaction time and
% decision. Neuroscience and Biobehavioral Reviews, 64, 229-251.
% Raab (1962). Statistical Facilitation of Simple Reaction Times.
% Transactions of the New York Academy of Sciences, 24(5), 574-590.
%
% See also simRace, simLater

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
    if isscalar( mu )
        mu(2) = mu(1);
    elseif length( mu )>2 || ~isvector( mu )
        error('The input argument MU needs to be a scalar or a two element vector.')
    end
else
    % Default values
    mu = [ 2.5 2.5 ];
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
    sigma = [ 0.4 0.4 ];
end

% Random sample of reaction times in the two single signal conditions
data(:,1) = simLater( n, mu(1), sigma(1) );
data(:,2) = simLater( n, mu(2), sigma(2) );

% Random sample of reaction times in the redundant signals conditions
race = [ simLater( n, mu(1), sigma(1), 0 ) ,...
         simLater( n, mu(2), sigma(2), 0 ) ];
data(:,3) = min( race, [], 2 );

% Sort DATA
data = sort( data );

end