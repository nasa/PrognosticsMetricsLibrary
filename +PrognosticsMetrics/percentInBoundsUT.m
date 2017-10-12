function [p,yesno] = percentInBoundsUT(X,W,lower,upper,UTParams,Beta)
% p = percentInBounds(X,lower,upper)
%	Returns percent of values in X that are in [lower,upper]

% gives the actual overlap between the prediction and acceptable bounds

%the ideal number for the overlap, "p" is 1
% the minimum desirable number for overlap is specified by Beta


%yesno returns a binary variable, success if p is greater than the desired threshold Beta


import PrognosticsMetrics.*;

% compute wmean and wcov
Pxx = wcov(X,W,UTParams(1),UTParams(2));
mx = wmean(X,W);
skew = wskew(X,W);

% check skew
if isnan(skew)
	% could happen if Pxx is zero
	skew = 0;
end

% sample from distribution, and give that value to percentInBounds
X = skewgen(mx,Pxx,skew,10000);
p = percentInBounds(X,lower,upper,Beta);

if p>Beta
    yesno=1;
else
    yesno=0;
end
