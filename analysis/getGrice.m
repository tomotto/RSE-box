function [grice, p] = getGrice( data )
%GETGRICE   Computation of Grice's bound.
% [GRICE, P] = GETGRICE(DATA) returns Grice's bound (as defined in Townsend
% & Wenger, 2004) to analyse a redundant signals experiment. Input argument
% DATA is an N-by-2 matrix that contains reaction times in the two single
% signal conditions (if DATA has more than two columns, columns 1 and 2 are
% used). The output argument GRICE is a time vector that defines Grice's
% bound. The output argument P provides corresponding cumulative
% probabilities.
%
% Reference: 
% Townsend & Wenger (2004). A theory of interactive parallel processing:
% New capacity measures and predictions for a response time inequality
% series. Psychological Review, 111(4), 1003-1035.
%
% See also demo01_quantiles, getCP, getGain, sampleDown

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details


% Check input argument DATA
if size( data, 2 ) > 2
    warning('DATA has more than 2 columns, will use columns 1 and 2.')
    data = data(:,1:2);
end

% Sample size
n = size( data, 1 );

% Sort sample points in DATA
data = sort( data, 1 );

% Compute Grice bound
p = getCP( n );
grice = min( data, [], 2 );


end