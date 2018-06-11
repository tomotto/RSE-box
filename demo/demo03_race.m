function demo03_race
%DEMO03_RACE   Demonstration of the RSE-box: LATER model
% DEMO03_RACE demonstrates the functionality of the race model functions in
% the RSE toolbox in three steps: (1) Simulation of a redundant signals
% experiment. (2) Fitting the race model to a random RSE data set. (3)
% Plotting of the fitting results. Documentation of exemplified toolbox
% functions can be obtained using the HELP function.
%
% See also simRace, fitRace, bootRace, raceCDF

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% -------------------------------------------------------------------------
%  (1) Simulate RSE
% -------------------------------------------------------------------------

% Sample size 
n = 50;

% LATER model parameters to simulate the single signal conditions
mu    = [ 2.5, 2.5 ];
sigma = [ 0.4, 0.4 ];

% Race model parameters to simulate the redundant signals condition
% (set both parameters to 0 for the independent race model)
rho = -0.5;
eta =  0.1;

% Simulate RSE experiment using a race model (Otto & Mamassian, 2012)
data = simRace( n, mu, sigma, rho, eta );

% Get cumulative probabilities
p = getCP( n );


% -------------------------------------------------------------------------
%  (2) Model fitting
% -------------------------------------------------------------------------

% x-values for plotting
xLim = [0.2 0.7];
x = linspace( xLim(1), xLim(2), 1000 );

% Fitting the later model to the single signal conditions
laterfit = zeros(2,3);
for ii=1:2
    laterfit(:,ii) = fitLater( data(:,ii) );
end

% Fitting the race model to the redundant signals condition
racefit = fitRace( data(:,3), laterfit(1,1:2), laterfit(2,1:2) );

% Bootstrap 95% CI
[ bootci, y ] = bootRace( data, x, 1000 );


% -------------------------------------------------------------------------
%  (3) Plot data and model fit
% -------------------------------------------------------------------------

% Figure size
figSize = [0.25 0.25 0.5 0.6];

% Colors for the three conditions
color = 'gbk';

% Open new figure
figure( 'units', 'normalized', 'outerposition', figSize )
hold on

% Plot 95% CI area of best fit
xFill = [ x,      fliplr( x )      ];
yFill = [ y(1,:), fliplr( y(2,:) ) ]; 
lh(6) = fill( xFill, yFill, [1 0.8 0.7], 'EdgeColor','None' ); 

% Plot LATER fit
for ii=1:2
    y = laterCDF( x, laterfit(1,ii), laterfit(2,ii) );
    plot( x, y, color(ii) );
end

% Plot original distribution
y = raceCDF( x, mu, sigma+eta, rho );
lh(4) = plot( x, y, 'k' );

% Plot race fit
race = raceCDF( x, laterfit(1,1:2), laterfit(2,1:2)+racefit(2), racefit(1) );
lh(5) = plot( x, race, 'r', 'LineWidth',2 );

% Plot data
for ii=1:3
    lh(ii) = plot( data(:,ii), p, 'o', 'Color',color(ii), 'MarkerSize', 7, 'MarkerFaceColor','w' );
end


% -------------------------------------------------------------------------
%  Info text and figure formatting
% -------------------------------------------------------------------------

% Info text
textFit = round(racefit, 2, 'significant');
textCI  = round(bootci,  2, 'significant'); 
text( 0.05, 0.90, 'Simulation parameters',  'units','normalized', 'FontWeight','bold' )
text( 0.05, 0.85, ['\rho = ' num2str(rho)],	'units','normalized' )
text( 0.05, 0.80, ['\eta = ' num2str(eta)],	'units','normalized' )
text( 0.15, 0.85, ['n = '    num2str(n)],   'units','normalized' )
text( 0.05, 0.70, 'Parameter recovery',     'units','normalized', 'FontWeight', 'bold' )
text( 0.05, 0.65, ['\rho = ' num2str(textFit(1))], 'units', 'normalized' )
text( 0.05, 0.60, ['\eta = ' num2str(textFit(2))], 'units', 'normalized' )
text( 0.15, 0.65, ['[' num2str(textCI(1,1)) ' ' num2str(textCI(2,1)) ']'], 'units','normalized' )
text( 0.15, 0.60, ['[' num2str(textCI(1,2)) ' ' num2str(textCI(2,2)) ']'], 'units','normalized' )

% Axes, labels, etc.
set( gca, 'xlim', xLim, 'ylim', [0 1]  )
xlabel( 'Reaction time (s)',      'FontWeight','bold' )
ylabel( 'Cumulative probability', 'FontWeight','bold' )
legendText = { 'Signal 1', 'Signal 2', 'Redundant', 'True distribution', 'Best Fit', '95% CI (Bootstrap)' };
legend( lh, legendText, 'Location','southeast' )
legend( 'boxoff' )

end