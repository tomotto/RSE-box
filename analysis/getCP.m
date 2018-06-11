function p = getCP( inputArg )
%GETCP   Computation of cumulative probabilities.
% P = GETCP(INPUTARG) returns cumulative probabilities P to estimate a
% distribution function from a random sample with size N. If the input
% argument INPUTARG is a scalar, N is specified by the value of the scalar.
% If INPUTARG is a vector, N is specified by the length of the vector.
%
% See also: demo01_quantiles

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check if INPUTARG is a scalar or vector (to get the sample size N)
if isscalar( inputArg )
    % Check if INPUTARG is a positive integer
    if rem( inputArg, 1 )==0 && inputArg>0
        n = inputArg;
    else
        error( 'The input argument needs to be a positive integer.' )
    end
elseif isvector( inputArg )
    n = length( inputArg );  
else
    error('The input argument needs to be a scalar or a vector.')
end

% Compute cumulative probabilities for N sample points
p = ( (1:n)' - 0.5 ) / n;

end