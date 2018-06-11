function [miller, p] = getMiller( data )
%GETMILLER   Computation of Miller's bound.
% [MILLER, P] = GETMILLER(DATA) returns Miller's bound to analyse a
% redundant signals experiment (Miller, 1982). Input argument DATA is an
% N-by-2 matrix that contains reaction times in the two single signal
% conditions (if DATA has more than two columns, columns 1 and 2 are used).
% The output argument MILLER is a time vector that defines Miller's bound.
% The output argument P provides corresponding cumulative probabilities.
%
% Reference: 
% Miller (1982). Divided attention: evidence for coactivation with
% redundant signals. Cognitive Psychology, 14(2), 247-279.
%
% See also demo01_quantiles, getCP, getViolation, sampleDown

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

% Linear interpolation of DATA
y1 = interpCDF( x, data(:,1), 1 );
y2 = interpCDF( x, data(:,2), 1 );

% Compute Miller bound
p = getCP( n );
miller = interp1( y1+y2, x, p );

end


