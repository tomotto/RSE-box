function demo02_later
%DEMO02_LATER   Demonstration of the RSE toolbox (2)
% DEMO02_LATER demonstrates the functionality of the LATER model functions
% in the RSE toolbox in three steps: (1) Simulation of reaction times using
% the LATER model. (2) Fitting the LATER model to a random sample. (3)
% Plotting of the fitting results. Documentation of exemplified toolbox
% functions can be obtained using the HELP function.
%
% See also simLater, fitLater, bootLater, laterCDF

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% -------------------------------------------------------------------------
%  (1) Simulate LATER model
% -------------------------------------------------------------------------

% Sample size 
n = 50;

% LATER model parameters to simulate the single signal conditions
mu    = 2.5;
sigma = 0.4;

% Simulate RTs using the LATER model (random data sample)
data = simLater( n, mu, sigma );

% Get cumulative probabilities
p = getCP( n );


% -------------------------------------------------------------------------
%  (2) Model fitting
% -------------------------------------------------------------------------

% x-values for plotting
xLim = [0.2 0.7];
x = linspace( xLim(1), xLim(2), 1000 );

% Fitting the later model
fit = fitLater( data );

% Bootstrap 95% CI
[ bootci, y ] = bootLater( data, x, 1000 );


% -------------------------------------------------------------------------
%  (3) Plot data and model fit
% -------------------------------------------------------------------------

% Figure size
figSize = [0.25 0.25 0.5 0.6];

% Open new figure
figure( 'units', 'normalized', 'outerposition', figSize )
hold on

% Plot 95% CI area of best model fit
xFill = [ x,      fliplr( x )      ];
yFill = [ y(1,:), fliplr( y(2,:) ) ]; 
lh(4) = fill( xFill, yFill, [0.8 1 0.8], 'EdgeColor', 'None' ); 

% Plot best model fit
y = laterCDF( x, fit(1), fit(2) );
lh(3) = plot( x, y, 'g', 'LineWidth', 2 );

% Plot original distribution
y = laterCDF( x, mu, sigma );
lh(1) = plot( x, y, 'k' );

% Plot random data sample
lh(2) = plot( data, p, 'ok', 'MarkerSize', 7, 'MarkerFaceColor', 'w' );


% -------------------------------------------------------------------------
%  Info text and figure formatting
% -------------------------------------------------------------------------

% Info text
textFit = round( fit,    3, 'significant' );
textCI  = round( bootci, 3, 'significant' );  
text( 0.05, 0.90, 'Simulation parameters',      'units','normalized', 'FontWeight','bold' )
text( 0.05, 0.85, ['\mu = '    num2str(mu)],    'units','normalized' )
text( 0.05, 0.80, ['\sigma = ' num2str(sigma)], 'units','normalized' )
text( 0.15, 0.85, ['n = ' num2str(n)],          'units','normalized' )
text( 0.05, 0.70, 'Parameter recovery',         'units','normalized', 'FontWeight','bold' )
text( 0.05, 0.65, ['\mu = ' num2str(textFit(1))],    'units','normalized' )
text( 0.05, 0.60, ['\sigma = ' num2str(textFit(2))], 'units','normalized' )
text( 0.15, 0.65, ['[' num2str(textCI(1,1)) ' ' num2str(textCI(2,1)) ']'], 'units','normalized' )
text( 0.15, 0.60, ['[' num2str(textCI(1,2)) ' ' num2str(textCI(2,2)) ']'], 'units','normalized' )

% Axes, labels, etc.
xlabel( 'Reaction time (s)',     'FontWeight', 'bold' )
ylabel( 'Cumulative probability', 'FontWeight', 'bold' )
legendText = { 'True distribution', 'Random sample', 'Best Fit', '95% CI (Bootstrap)'};
legend( lh, legendText, 'Location', 'southeast' )
legend( 'boxoff' )
set( gca, 'xlim', xLim, 'ylim', [0 1] )

end