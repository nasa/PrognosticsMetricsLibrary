function M = computePrognosisMetrics(prognosisData,alphaBeta,sigma)
% M = computeMetrics(prognosisData,alpha,sigma)
%	Given data structure, computes metrics stored in metrics structure M
%	prognosisData is a struct with the following form:
%		.time = (1 x t) time vector of prediction time points
%		.EOL.true = (1 x t) true EOL values at each prediction time
%		.EOL.values = (N x t) EOL prediction values at each prediction
%			time.
%		.EOL.weights = (N x t) EOL prediction weights at each prediction
%			time.
%		.RUL.true = (1 x t) true RUL values
%		.RUL.values = (N x t) RUL prediction values at each prediction
%			time.
%		.RUL.weights = (N x t) RUL prediction weights at each prediction
%			time.
%		.cputime = (1 x t) EOL/RUL computation times (optional)
%	alphaBeta is a vector of two entities: they are the alpha and beta values, both in [0 1]; it is optional and defaults to 0.1 and 0.5 respectively.
%	sigma is a vector [alpha beta] used for sigma point variance
%		calculation. It must be included to obtain correct variance values
%		for sigma points. For particles, the argument should be omitted.
%
%	Warnings: do not trust median values, mad, rmad, percentInBounds if 
%	samples are not	equally weighted.
%	
%	See also: relativeAccuracy, percentInBounds, convergence, mad, rmad.

import PrognosticsMetrics.*;

if nargin<2
	alpha = 0.1;
    Beta=0.5;
else
    alpha = alphaBeta(1);
    Beta = alphaBeta(2);
end

M.RULsMean = zeros(size(prognosisData.time));
M.RULsMedian = zeros(size(prognosisData.time));
M.EOLsMean = zeros(size(prognosisData.time));
M.EOLsMedian = zeros(size(prognosisData.time));
M.MeanADs = zeros(size(prognosisData.time));
M.MedianADs = zeros(size(prognosisData.time));
M.PiAlphas = zeros(size(prognosisData.time));
M.RULsVar = zeros(size(prognosisData.time));
M.EOLsVar = zeros(size(prognosisData.time));
M.PHs = zeros(size(prognosisData.time));
for p=1:length(prognosisData.time)	
	M.RULsMean(p) = wmean(prognosisData.RUL.values(:,p),prognosisData.RUL.weights(:,p));
    M.RULMeanBasedAlpha(p)=alphacalculate(M.RULsMean(p),prognosisData.RUL.true(p),alpha);
    M.RULsMedian(p) = median(prognosisData.RUL.values(:,p));
	M.EOLsMean(p) = wmean(prognosisData.EOL.values(:,p),prognosisData.RUL.weights(:,p));
	M.EOLsMedian(p) = median(prognosisData.EOL.values(:,p));
	M.MeanADs(p) = mad(prognosisData.RUL.values(:,p));
	M.MedianADs(p) = mad(prognosisData.RUL.values(:,p),'median');
	M.RMeanADs(p) = wrmad(prognosisData.RUL.values(:,p),prognosisData.RUL.weights(:,p));
	M.RMedianADs(p) = rmad(prognosisData.RUL.values(:,p),'median');
	if nargin<3
		M.RULsVar(p) = wcov(prognosisData.RUL.values(:,p),prognosisData.RUL.weights(:,p));
		M.EOLsVar(p) = wcov(prognosisData.EOL.values(:,p),prognosisData.RUL.weights(:,p));
		[M.PiAlphas(p),M.Beta0vs1(p)] = percentInBounds(prognosisData.RUL.values(:,p),...
		prognosisData.RUL.true(p)*(1-alpha),...
		prognosisData.RUL.true(p)*(1+alpha),Beta);
        
	else
		M.RULsVar(p) = wcov(prognosisData.RUL.values(:,p),prognosisData.RUL.weights(:,p),sigma(1),sigma(2));
		M.EOLsVar(p) = wcov(prognosisData.EOL.values(:,p),prognosisData.RUL.weights(:,p),sigma(1),sigma(2));
		[M.PiAlphas(p),M.Beta0vs1(p)] = percentInBoundsUT(prognosisData.RUL.values(:,p),prognosisData.RUL.weights(:,p),...
		prognosisData.RUL.true(p)*(1-alpha),...
		prognosisData.RUL.true(p)*(1+alpha),...
		sigma,Beta);
	end
	M.PHs(p) = M.RULsMedian(p)>=prognosisData.RUL.true(p)*(1-alpha) && M.RULsMedian(p)<=prognosisData.RUL.true(p)*(1+alpha);
end
M.RAsMean = relativeAccuracy(prognosisData.RUL.true,M.RULsMean);
M.RAsEOLMean = relativeAccuracy(prognosisData.EOL.true,M.EOLsMean);
M.RAsMedian = relativeAccuracy(prognosisData.RUL.true,M.RULsMedian);
M.RAsEOLMedian = relativeAccuracy(prognosisData.EOL.true,M.EOLsMedian);
M.RULRSD = 100*sqrt(M.RULsVar)./M.RULsMean;
M.EOLRSD = 100*sqrt(M.EOLsVar)./M.EOLsMean;
M.PH = find(M.PHs==1,1); % set to first index at which PH is inside alpha-bounds
M.CMeanAD = convergence(prognosisData.time,M.MeanADs);
M.CMedianAD = convergence(prognosisData.time,M.MedianADs);
if isfield(prognosisData,'cputime')
	M.timeFactor = prognosisData.cputime./prognosisData.RUL.true;
end


