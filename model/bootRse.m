function [ bootci, y ] = bootRse( rt1, rt2, rtR, x, bootn )
%BOOTRSE   Bootstrapping 95% confidence intervals for race model fits.
% [BOOTCI,Y] = BOOTRSE(RT1,RT2,RTR,X,BOOTN) uses a bootstrap procedure to
% return 95% confidence intervals (CIs) for maximum likelihood estimates
% (MLEs) of the race model (Otto & Mamassian, 2012). Input arguments RT1,
% RT2, and RTR are vectors that contain reaction times in the two single
% signal and the redundant signals conditions, respectively. Output
% argument BOOTCI returns the 95% confidence intervals of the MLEs for the
% two LATER units as well as for the race model parameters, which are
% organized in columns in the order: mu1, mu2, sigma1, sigma2, rho, and
% eta. For values in the optional input vector X, 95% CIs on the three
% fitted distributions are estimated and returned in the optional output
% arguments Y, which is a 2-by-X-by-3 matrix (CIs, number of values in X, 3
% distributions). The optional input argument BOOTN sets the number of
% Bootstrap samples (default is 1000).
%
% Reference:
% Otto & Mamassian (2012). Noise and correlations in parallel perceptual
% decision making. Current Biology, 22(15), 1391-1396.
%
% See also demo03_race, simRace, fitRse, laterCDF, raceCDF

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details


% Check input argument DATA
if ~isvector( rt1 )
    error( 'The input argument RT1 needs to be a vector.' )
end
if ~isvector( rt2 )
    error( 'The input argument RT2 needs to be a vector.' )
end
if ~isvector( rtR )
    error( 'The input argument RTR needs to be a vector.' )
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
n = [ length(rt1), length(rt2), length(rtR) ];

% Generate bootstrap samples
bootRT1 = rt1( randi( n(1), n(1), bootn ) );
bootRT2 = rt2( randi( n(2), n(2), bootn ) );
bootRTR = rtR( randi( n(3), n(3), bootn ) );

% Index for 95% CIs
ci = round( bootn * [0.025, 0.975] ); 

% Fit model to bootstrap samples
bootci = zeros( bootn, 6 );
fprintf( 'Progress:    ' );
for b = 1:bootn
    bootci(b,:) = fitRse( bootRT1(:,b), bootRT2(:,b), bootRTR(:,b) );
    % Monitor progress
    p = num2str( round(100*b/bootn) );
    for j=0:length(p)
        fprintf( '\b' );
    end
    fprintf( [p '%%'] );
end
fprintf( '\n' )

% Get 95% CI on best fitting distributions
if flgX
    y = zeros( bootn, length( x ), 3 );
    for b = 1:bootn
        y(b,:,1) = laterCDF( x, bootci(b,1), bootci(b,3) );
        y(b,:,2) = laterCDF( x, bootci(b,2), bootci(b,4) );
        y(b,:,3) = raceCDF( x, bootci(b,1:2), bootci(b,3:4), bootci(b,5), bootci(b,6) );
    end
    y = sort( y );
    y = y(ci,:,:);
end

% Get 95% CIs on best fitting model parameters
bootci = sort( bootci );
bootci = bootci(ci,:);

end