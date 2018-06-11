function violation = getViolation( data )
%GETVIOLATION   Computation of Miller's bound violation.
% VIOLATION = GETVIOLATION(DATA) returns the amount of vioalation of
% Miller's bound in a redundant signals experiment (Miller, 1982). To
% quantify the violation, the size of the area between the cumulative RT
% distribution in the redundant signal condition and Miller's bound is used
% (Colonius & Diederich, 2006). Input argument DATA is an N-by-3 matrix
% that contains reaction times in the two single signal conditions (columns
% 1 and 2) and the redundant signals condition (column 3). If DATA has more
% than three columns, columns 1 to 3 are used. Output argument VIOLATION is
% the size of the violation area.
%
% References: 
% Miller (1982). Divided attention: evidence for coactivation with
% redundant signals. Cognitive Psychology, 14(2), 247-279.
% Colonius, & Diederich (2006). The race model inequality: interpreting a
% geometric measure of the amount of violation. Psychological Review,
% 113(1), 148-154.
%
% See also demo01_quantiles, getMiller, sampleDown

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

% Get Miller's bound as baseline
miller = getMiller( data(:,1:2) );

% Differnce between redundant signals condition and Miller's bound
violation = miller - data(:,3);

% Consider only the area in excess of Miller's bound
violation( violation<0 ) = 0;

% Get the size of the violation area
violation = mean( violation );

end