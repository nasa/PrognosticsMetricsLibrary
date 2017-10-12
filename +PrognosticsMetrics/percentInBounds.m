function [p,yesno] = percentInBounds(X,lower,upper,Beta)
% p = percentInBounds(X,lower,upper)
%	Returns percent of values in X that are in [lower,upper]
% gives the actual overlap between the prediction and acceptable bounds

%the ideal number for the overlap, "p" is 1
% the minimum desirable number for overlap is specified by Beta


%yesno returns a binary variable, success if p is greater than the desired threshold Beta

s = sum(X >= lower & X <= upper);
p = s/length(X);

if p>Beta
    yesno=1;
else
    yesno=0;
end
    