function gain = getGain( data )
%GETGAIN   Computation of redundancy gain.
% GAIN = GETGAIN(DATA) returns the redundancy gain in a redundant signals
% experiment. Input argument DATA is an N-by-3 matrix that contains
% reaction times in the two single signal conditions (columns 1 and 2) and
% the redundant signals condition (column 3). If DATA has more than three
% columns, columns 1 to 3 are used. Output argument GAIN is the speed-up of
% reaction times in the redundant signals condition using Grice's bound as
% baseline (Otto, Dassy, & Mamassian, 2013).
%
% Reference: 
% Otto, Dassy, & Mamassian (2013). Principles of multisensory behavior.
% Journal of Neuroscience, 33(17), 7463-7474.
%
% See also demo01_quantiles, getCP, getGrice, sampleDown

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check input argument DATA
if size( data, 2 ) > 3
    warning('DATA has more than 3 columns, will use columns 1 to 3.')
    data = data(:,1:3);
end

% Sort sample points in DATA
if size( data, 1) > 1
    data = sort( data );
end

% Get Grice's bound as baseline
grice = getGrice( data(:,1:2) );

% Compute the redundancy gain
gain = mean( grice - data(:,3) );

end