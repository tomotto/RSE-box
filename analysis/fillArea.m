function h = fillArea( data, colSpec, flgPositive )
%FILLAREA   Plot area between two functions.
% H = FILLAREA(DATA,COLSPEC,FLGPOSITIVE) fills the area between two
% cumulative distribution functions (see also Matlab function FILL). Input
% argument DATA is an N-by-2 matrix that contains two data samples (if DATA
% has more than two columns, columns 1 and 2 are used). The optional input
% argument COLSPEC allows to specify the colour of the area. If the
% optional input argument FLGPOSITIVE is set to 1, the area is only plotted
% if the first distribution is above the second. The output argument H
% provides a handle for the graphic object.
%
% See also: demo01_quantiles, getCP, interpCDF, sampleDown

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check input argument DATA
if size( data, 2 ) > 2
    warning('DATA has more than 2 columns, will use columns 1 and 2.')
    data = data(:,1:2);
end

% Check for input argument COLSPEC
if ~exist( 'colSpec', 'var' )
    colSpec = [ 0.8 0.8 0.8 ];
elseif isempty( colSpec ) 
    colSpec = [ 0.8 0.8 0.8 ];
end

% Check for input argument FLGPOSITIVE and set to 0 (default) if not provided
if ~exist( 'flgPositive', 'var' )
    flgPositive = 0;
end

% Sample size
n = size( data, 1 );

% Get cumulative probabilities
p = getCP( n );

% X-values for interpolation
x = unique( data(:) )';

% Interpolate y-values
y(1,:) = interpCDF( x, data(:,1), 1 );
y(2,:) = interpCDF( x, data(:,2), 1 );
    
% Upper/lower bound of the area
y( y==0 ) = min( p );
y( y==1 ) = max( p );

% Check if sample 1 is above sample 2
if flgPositive
    idx = y(1,:) <= y(2,:);
    y(2,idx) = y(1,idx);
end

% Specify coordintates of area
xFill = [ x,      fliplr( x ) ];
yFill = [ y(1,:), fliplr( y(2,:) ) ]; 

% Fill area
h = fill( xFill, yFill, colSpec, 'EdgeColor', 'None' ); 

end