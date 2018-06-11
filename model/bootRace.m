function [ bootci, y ] = bootRace( data, x, bootn )
%BOOTRACE   Bootstrapping 95% confidence intervals for race model fits.
% [BOOTCI,Y] = BOOTRACE(DATA,X,BOOTN) uses a bootstrap procedure to return
% 95% confidence intervals (CIs) for maximum likelihood estimates (MLEs) of
% the race model (Otto & Mamassian, 2012). Input argument DATA is an N-by-3
% matrix that contains reaction times in the two single signal conditions
% (columns 1 and 2) and the redundant signals condition (column 3). If DATA
% has more than two columns, columns 1 to 3 are used. Output argument
% BOOTCI returns the 95% confidence intervals for MLEs of the race model
% parameters rho and eta. For values in the optional input argument X, 95%
% CIs on the fitted distribution are estimated and returned in optional
% output Y. Optional input argument BOOTN sets the number of Bootstrap
% samples (default is 1000).
%
% Reference:
% Otto & Mamassian (2012). Noise and correlations in parallel perceptual
% decision making. Current Biology, 22(15), 1391-1396.
%
% See also demo03_race, simRace, fitRace, raceCDF, bootLater

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check input argument DATA
if size( data, 2 ) > 3
    warning('DATA has more than 3 columns, will use columns 1 to 3.')
    data = data(:,1:3);
end

% Check input argument NBOOT
if ~exist( 'bootn', 'var' )
    bootn = 1000;
end

% Check input argument X
if ~exist( 'x', 'var' )
    if nargout > 1
        warning('Input argument X is needed to compute Y.')
    end
    flgX = 0;
    y = NaN;
else
    if ~isvector( x )
        error('Input argument X needs to be a vector.')
    end
    flgX = 1;
end

% Sample size
n = size( data, 1 );

% Bootstrap samples
bootdata = zeros( n, bootn, 3 );
for i = 1:3
    d = data(:,i);
    bootdata(:,:,i) = d( randi( n, n, bootn ) );
end

% Index for 95% CI
ci = round( bootn * [0.025, 0.975] ); 

% Fit model to bootstrap samples
later = zeros( 2, 2, bootn );
bootci = zeros( bootn, 2 );
for b = 1:bootn
    later(:,1,b) = fitLater( bootdata(:,b,1) );
    later(:,2,b) = fitLater( bootdata(:,b,2) );
    bootci(b,:) = fitRace( bootdata(:,b,3), later(1,:,b), later(2,:,b) );
end

% Get 95% CI on best fitting distribution
if flgX
    y = zeros( bootn, length( x ) );
    for b = 1:bootn
        y(b,:) = raceCDF( x, later(1,:,b), later(2,:,b) + bootci(b,2), bootci(b,1) );
    end
    y = sort( y );
    y = y(ci,:);
end

% Get 95% CIs on best fitting model parameters
bootci = sort( bootci );
bootci = bootci(ci,:);

end