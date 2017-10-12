function RA = relativeAccuracy(trueValue,predictedValue)
% RA = relativeAccuracy(true,predicted)
%	Computes relative accuracy given true and predicted values
%	
%	See also: plotAlphaLambda, convergence, computeMetrics.

RA = 1 - abs(trueValue-predictedValue)./trueValue;
