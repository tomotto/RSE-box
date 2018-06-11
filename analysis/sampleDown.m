function data = sampleDown( data, n )
%SAMPLEDOWN   Down-sampling of an empirical CDF.
% DATA = SAMPLEDOWN(DATA,N) reduces the number of sample points of an
% empirical RT distribution using linear interpolation. Input argument DATA
% is a vector that contains reaction times. Input argument N specifies the
% number of sample points, which needs to be smaller than the original
% sample size of DATA. The output argument DATA returns the down-sampled
% version of the original data.
%
% See also getCP, interpCDF, outCorrect

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check input argument DATA
if ~isvector( data )
    error('The input argument DATA needs to be a vector.')
end

% Check input argument N
if isscalar( n )
    % Check if INPUTARG is a positive integer
    if rem( n, 1 )~=0 || n<=0
        error( 'The input argument N needs to be a positive integer.' )
    end
else
    error('The input argument N needs to be a scalar.')
end

% Original sample size
m = length( data );

% Compare sample sizes
if n>m
    error('N needs to be smaller that the original sample size.')
end

% Sort data 
data = sort( data );

% Down-sample the data using linear interpolation
data = interp1( getCP(m), data, getCP(n) );

end