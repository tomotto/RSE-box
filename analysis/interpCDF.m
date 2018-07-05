function y = interpCDF( x, data, flgExtrap )
%INTERPCDF   Linear interpolation of a cumulative distribution function.
% Y = INTERPCDF(X,DATA,FLGEXTRAP) returns an interpolated cumulative
% distribution function from a data sample. The input argument X is a
% vector of values for which cumulative probabilities Y are linearly
% interpolated (see Matlab function INTERP1). The input argument DATA is a
% vector containing sample points for interpolation. For out of range
% values in X, Y is set to NaN (default) or to 0 or 1 (if the optional
% input argument FLGEXTRAP is set to 1).
%
% See also: getCP, sampleDown

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check if input argument X is a vector
if ~isvector( x )
    error('The input argument X needs to be a vector.')
end

% Check if input argument DATA is a vector
if ~isvector( data )
    error('The input argument DATA needs to be a vector.')
end

% Check for input argument FLGEXTRAP and set to 0 (default) if not provided
if ~exist( 'flgExtrap', 'var' )
    flgExtrap = 0;
end

% Sort data 
data = sort( data );

% Get cumulative probabilities
p  = getCP( data );

% Get unique values in data
[u, iU] = unique( data );

% Resolve ties (if needed)
if length( u ) < length( data )
    for i = 1:length( u )
        idx = data == u( i );
        p( idx ) = mean( p( idx ) );
    end
    p = p( iU );
end

% Linear interpolation of cumulative probabilities
y = interp1( u, p, x );

% Handling of values in X outside the range of DATA
if flgExtrap
    y( x<min(data) ) = 0;
    y( x>max(data) ) = 1;
end

end
