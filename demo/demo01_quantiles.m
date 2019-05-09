function demo01_quantiles
%DEMO01_QUANTILES   Demonstration of the RSE-box: Basic RT analysis
% DEMO01_QUANTILES demonstrates the functionality of key functions in the
% RSE toolbox in four steps: (1) Simulation of a redundant signals
% experiment. (2) Plotting of cumulative distribution functions. (3)
% Measuring the redundancy gain (the speed-up of reaction times in the
% redundant compared to the single signal conditions). (4) Estimating
% violations of Miller's bound. Documentation of exemplified toolbox
% functions can be obtained using the HELP function.
%
% See also: simRace, getCP, getGrice, getGain, getMiller, getViolation,
% fillArea

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% -------------------------------------------------------------------------
%  (1) Simulate RSE
% -------------------------------------------------------------------------

% Sample size (trials per condition) 
n = 50;

% LATER model parameters to simulate the single signal conditions
mu    = [ 2.5, 2.5 ];
sigma = [ 0.4, 0.4 ];

% Race model parameters to simulate the redundant signals condition
% (set both parameters to 0 for the independent race model)
rho = -0.5;
eta =  0.1;

% Simulate RSE experiment using a race model
data = simRace( n, mu, sigma, rho, eta );

% Get cumulative probabilities
p = getCP( n );


% -------------------------------------------------------------------------
%  (2) Plot cumulative distribution functions
% -------------------------------------------------------------------------

% Figure size
figSize = [0.25 0.25 0.5 0.6];

% Open new figure
figure( 'units', 'normalized', 'outerposition', figSize )
hold on

% X-axis limits (min, max)
xLim = [ 0.1 0.7 ];

% Colors for the three conditions (green, blue, black)
color = 'gbk';
grey = [0.8 0.8 0.8];


% Plot RSE data (as quantiles)
lh = zeros(1,3);
for ii=1:3 
    lh(ii) = plot( data(:,ii), p, ['-o' color(ii)], 'MarkerSize', 7, 'MarkerFaceColor', 'w' );
end

% Info text and figure format
legendText = { 'Signal 1', 'Signal 2', 'Redundant'};
figFormat( xLim, lh, legendText )


% -------------------------------------------------------------------------
%  (3) Measuring redundancy gain
% -------------------------------------------------------------------------

% Open new figure
figure( 'units', 'normalized', 'outerposition', figSize )
hold on

% Take Grice's bound as reference
grice = getGrice( data(:,1:2) );

% Redundancy gain
gain = getGain( data );
gain = round( gain, 3, 'significant' );

% Plot data
fillArea( [ data(:,3), grice ] );
for ii=1:2
    plot( data(:,ii), p, '-o', 'Color', grey, 'MarkerSize', 7, 'MarkerFaceColor', 'w' );
end
lh(1) = plot( grice,     p, '-or', 'MarkerSize', 7, 'MarkerFaceColor', 'w' );
lh(2) = plot( data(:,3), p, '-ok', 'MarkerSize', 7, 'MarkerFaceColor', 'w' );

% Info text and figure format
text( 0.05, 0.90, 'Redundancy gain', 'units', 'normalized')
text( 0.05, 0.85, [num2str(gain) ' s'], 'FontWeight', 'bold', 'units', 'normalized')
legendText = { 'Grice bound', 'Redundant'};
figFormat(xLim, lh(1:2), legendText)


% -------------------------------------------------------------------------
%  (4) Violation of Miller's bound
% -------------------------------------------------------------------------

% Open new figure
figure( 'units', 'normalized', 'outerposition', figSize )
hold on

% Take Miller's bound as reference
miller = getMiller( data(:,1:2) );

% Violation area
violation = getViolation( data );
violation = round( violation, 3, 'significant' );

% Plot data
for ii=1:2
    plot( data(:,ii), p, '-o', 'Color', grey, 'MarkerSize', 7, 'MarkerFaceColor', 'w' );
end
fillArea( [ data(:,3), miller ], [], 1 );
lh(1) = plot( miller,    p, '-or', 'MarkerSize', 7, 'MarkerFaceColor', 'w' );
lh(2) = plot( data(:,3), p, '-ok', 'MarkerSize', 7, 'MarkerFaceColor', 'w' );

% Info text and figure format
text( 0.05, 0.90, 'Violation area', 'units', 'normalized')
text( 0.05, 0.85, [num2str(violation) ' s'], 'FontWeight', 'bold', 'units', 'normalized')
legendText = { 'Miller bound', 'Redundant'};
figFormat( xLim, lh(1:2), legendText )

end


% -------------------------------------------------------------------------
%  Figure formating
% -------------------------------------------------------------------------

function figFormat( xLim, lh, legendText )

% General figure settings
xlabel( 'Reaction time (s)', 'FontWeight', 'bold' )
ylabel( 'Cumulative probability', 'FontWeight', 'bold' )
legend( lh, legendText, 'Location', 'southeast' )
legend( 'boxoff' )
set( gca, 'xlim', xLim, 'ylim', [0 1] )
drawnow;

end
