function [raab, p] = getRaab( data )
%GETRAAB   Computation of Raab's independent race model.
% [RAAB, P] = GETRAAB(DATA) returns Raab's independent race model
% prediction to analyse a redundant signals experiment (Raab, 1962). Input
% argument DATA is an N-by-2 matrix that contains reaction times in the two
% single signal conditions (if DATA has more than two columns, columns 1
% and 2 are used). The output argument RAAB is a time vector that defines
% the model prediction. The output argument P provides corresponding
% cumulative probabilities.
%
% Reference: 
% Raab (1962). Statistical Facilitation of Simple Reaction Times.
% Transactions of the New York Academy of Sciences, 24(5), 574-590.
%
% See also demo01_quantiles, getCP, getGain, sampleDown

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check input argument DATA
if size( data, 2 ) > 2
    warning('DATA has more than 3 columns, will use columns 1 and 2.')
    data = data(:,1:2);
end

% Sample size
n = size( data, 1 );

% Sort DATA
data = sort( data, 1 );

% X-values for interpolation
x = unique( data(:) );
x( x > min(max(data)) ) = [];

% Linear interpolation of DATA
y1 = interpCDF( x, data(:,1), 1 );
y2 = interpCDF( x, data(:,2), 1 );

% Compute prediction using probability summation
p = getCP( n );
raab = interp1( y1+y2-y1.*y2, x, p );

end


