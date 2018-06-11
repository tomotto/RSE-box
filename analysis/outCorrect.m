function [iOut, corr, criteria] = outCorrect( data, factor )
%OUTCORRECT   Outlier correction.
% [IOUT,CORR,CRITERIA] = OUTCORRECT(DATA,FACTOR) performs an outlier
% correction on reaction times on the reciprocal scale (1/RT) and using the
% median and the median absolute deviation (Leys et al., 2013). Input
% argument DATA is a vector that contains reaction times. Optional input
% argument FACTOR sets the criterion for outlier correction (3 by default).
% Output argument IOUT returns an index of the same size as DATA with
% labels valid (1), fast outlier (3), and slow outlier (4). Optional output
% argument CORR contains the corrected data sample with outliers removed.
% Optional output argument CRITERIA rerurns the applied bounds for outlier
% removal (in RT space).
%
% Reference: 
% Leys, Ley, Klein, Bernard, & Licata (2013). Detecting outliers: Do not
% use standard deviation around the mean, use absolute deviation around the
% median. Journal of Experimental Social Psychology, 49(4), 764-766.
%
% See also getCP, interpCDF, sampleDown

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check input argument FACTOR
if exist( 'factor', 'var' )
    if isscalar( factor )
        if factor<=0
            error( 'The input argument FACTOR needs to be positive.' )
        end
    else
        error( 'The input argument FACTOR needs to be a scalar.' )
    end
else
    % Default value
    factor = 3;
end

% Check input argument DATA
if ~isvector( data )
    error('The input argument DATA needs to be a vector.')
end

% Transform data
inverseRT = 1 ./ data;

% Limit based on MAD
lim = factor * 1.4826 * mad( inverseRT, 1 );
med = median( inverseRT );

% Criteria for outlier correction
criteria(1) = med + lim;
criteria(2) = med - lim;

% Index of outliers (3 = fast outlier, 4 = slow outlier)
iOut = ones( size(data) );
iOut( inverseRT > criteria(1) ) = 3;
iOut( inverseRT < criteria(2) ) = 4;

% Corrected data (optional output)
corr = data( iOut==1 );

% Criteria for outliers in RT space (optional output)
criteria = 1 ./ criteria;

end