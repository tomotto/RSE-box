function [fit, logL] = fitRse( rt1, rt2, rtR, nStart, nGrid )
%FITRSE   Maximum likelihood estimation of the overall RSE model.
% [FIT, LOGL] = FITRSE( RT1, RT2, RTR, NSTART, NGRID ) performs a joint
% model fitting for the three conditions of the redundant signals paradigm.
% It returns maximum likelihood estimates (MLEs) for the two LATER units
% (mu1, mu2, sigma1, and sigma2) as well as for the race model parameters
% (rho and eta; see Otto & Mamassian, 2012). Input arguments RT1, RT2, and
% RTR are vectors that contain reaction times in the paradigm's three
% conditions. The optional input argument NSTART specifies the number of
% fitting procedures with different start values (default is 4). The
% optional input argument NGRID specifies the resolution of the initial
% grid search (default is 10). Output argument FIT returns the MLEs of the
% parameters in the order mu1, mu2, sigma1, sigma2, rho, and eta. LOGL
% contains the log-likelihood of the MLE.
%
% Reference:
% Otto & Mamassian (2012). Noise and correlations in parallel perceptual
% decision making. Current Biology, 22(15), 1391-1396.
%
% Prerequisites:
% Requires function MLE (Matlab's Statistics and Machine Learning Toolbox)
%
% See also demo03_race, simRace, bootRace, raceCDF, fitRace, fitLater

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details


% -------------------------------------------------------------------------
%  Check input arguments and prepare data
% -------------------------------------------------------------------------

if ~isvector( rt1 )
    error( 'The input argument RT1 needs to be a vector.' )
end
if ~isvector( rt2 )
    error( 'The input argument RT2 needs to be a vector.' )
end
if ~isvector( rtR )
    error( 'The input argument RTR needs to be a vector.' )
end

% Compute the reciprocal of RTs and collate data
data = 1 ./ [ rt1(:); rt2(:); rtR(:) ];

% Create index of RSE conditions
idx = [     ones( length(rt1), 1 ); ...
        2 * ones( length(rt2), 1 ); ...
        3 * ones( length(rtR), 1 ) ];

% Check input argument NSTART
if exist( 'nStart', 'var' )
    if ~isscalar( nStart ) || rem( nStart, 1 )~=0 || nStart<=0
        error( 'Input argument NSTART needs to be a positive integer.' )
    end
else
    % Default value
    nStart = 4;
end

% Check input argument NGRID
if exist( 'nGrid', 'var' )
    if ~isscalar( nStart ) || rem( nStart, 1 )~=0 || nGrid<=0
        error('The input argument NGRID needs to be a positive integer.')
    end
else
    % Default value
    nGrid = 10;
end


% -------------------------------------------------------------------------
%  Fitting procedure
% -------------------------------------------------------------------------

% Start values for LATER model parameters [ MU1, MU2, SIGMA1, SIGMA2 ]
startL = zeros(1,4);
for cc=1:2
    startL(cc)   = mean( data(idx==cc) );
    startL(cc+2) =  std( data(idx==cc) );
end

% Select start values for RHO and ETA using a grid search
startR = getStartVal( data, idx, startL, nStart, nGrid );

% Lower bound for ETA (to prevent negative SIGMA values)
etaLow = -0.74 * min( startL(3:4) );

% Collate lower and upper bounds for the fitting procedure
lowBound = [ 0.75 * startL, -0.99999,  etaLow ];
uppBound = [ 1.25 * startL,  0.99999,  Inf      ];

% Function handel for the fitting procedure
custpdf = @( data, mu1, mu2, sigma1, sigma2, rho, eta ) ...
   modelpdf( data, mu1, mu2, sigma1, sigma2, rho, eta, idx );

% Initilisation of fitting variables
nFail = 0;
logL = -Inf;
fit = [];

for ss=1:nStart
    
    try  
        % Set start values
        startVal = [ startL, startR(ss,:) ];
        % Get the MLE...
        newFit = mle( data, 'pdf',        custpdf,  ... 
                            'start',      startVal, ...
                            'lowerbound', lowBound, ...
                            'upperbound', uppBound, ...
                            'optimfun',   'fmincon' );
        % Get the log-likelihood
        newLogL = sum( log( modelpdf( data, newFit(1), newFit(2), newFit(3), newFit(4), newFit(5), newFit(6), idx ) ) );
    catch lastError     
        % Fitting procedure failed
        newLogL = -Inf;
        nFail = nFail + 1;
    end

    % Update best-fit
    if newLogL>logL
        logL = newLogL;
        fit  = newFit;
    end
    
end


% -------------------------------------------------------------------------
%  Error messages and warnings
% -------------------------------------------------------------------------

% Messages if fitting procedures have failed
if nFail==nStart
    disp( lastError.message )
    error( 'RSE-box: Fitting failed (see also last error message above)' )
elseif nFail  
    fprintf( '\n RSE-box: Fitting failed with %d of %d start values.', nFail, nStart )
    fprintf( '\n RSE-box: Consider inspection of the data set. \n')
end

end



% -------------------------------------------------------------------------
%  Model PDF function
% -------------------------------------------------------------------------
function y = modelpdf( data, mu1, mu2, sigma1, sigma2, rho, eta, idx )
        
% Single signal conditions
y1 = normpdf( data(idx==1), mu1, sigma1 );
y2 = normpdf( data(idx==2), mu2, sigma2 );

% Redundant signals condition
yR = maxNormPDF( data(idx==3), [mu1 mu2], [sigma1 sigma2] + eta, rho );

% Collate likelihoods
y = [ y1; y2; yR];

end



% -------------------------------------------------------------------------
%  Function to select start values
% -------------------------------------------------------------------------
function startR = getStartVal( data, idx, startL, nStart, nGrid )
    
% Range of start values for RHO and ETA
rhoVal = linspace( -0.95, 0.95, nGrid );
etaVal = linspace( -0.2,  0.5,  nGrid );
[ rhoVal, etaVal ] = meshgrid( rhoVal, etaVal );

% Grid search
logL = zeros( nGrid );
for ii=1:nGrid^2
    logL(ii) = sum( log( modelpdf( data, startL(1), startL(2), startL(3), startL(4), rhoVal(ii), etaVal(ii), idx ) ) );
end
logLsorted = sort( logL(:), 'descend' );

% Select start values based on grid search
startR = zeros(nStart,2);
for ss=1:nStart
    iStart = logL==logLsorted(ss);
    startR(ss,:) = [ rhoVal(iStart) etaVal(iStart) ];
end

% Code to show the result of the grid search
% figure
% hold on
% s = surf( rhoVal, etaVal, logL );
% s.EdgeColor = 'none';
% colormap copper 
% plot( startR(:,1), startR(:,2), 'ko' )
% plot( startR(1,1), startR(1,2), 'ro' )
% axis square
% drawnow

end
