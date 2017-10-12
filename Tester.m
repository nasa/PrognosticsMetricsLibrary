%This is a dummy file that create prognostics outputs, representative of
%what comes out of a prognostic algorithm
clc
clear

import PrognosticsMetrics.*;

%% Simulate the results of Prognostics - This should come from an actual Prognostic algorithm
N_sam=25;
Time_Max=10;
CoV=0.1;

%	Given data structure, computes metrics stored in metrics structure M
%	prognosisData is a struct with the following form:
%		.time = (1 x t) time vector of prediction time points
    prognosisData.time=1:1:Time_Max;
%		.EOL.true = (1 x t) true EOL values at each prediction time
    prognosisData.EOL.true=ones(1,Time_Max)*Time_Max;
%		.EOL.values = (N x t) EOL prediction values at each prediction
%			time.
    prognosisData.EOL.values=randn(N_sam,Time_Max).*(Time_Max*CoV)+Time_Max;
%		.EOL.weights = (N x t) EOL prediction weights at each prediction
%			time.
    prognosisData.EOL.weights=ones(N_sam,Time_Max).*1/N_sam;  %The weights should add up to one!!
%		.RUL.true = (1 x t) true RUL values
    prognosisData.RUL.true=prognosisData.EOL.true - prognosisData.time;
%		.RUL.values = (N x t) RUL prediction values at each prediction
%			time.
    prognosisData.RUL.values=prognosisData.EOL.values - prognosisData.time;
%		.RUL.weights = (N x t) RUL prediction weights at each prediction
%			time.
    prognosisData.RUL.weights=prognosisData.EOL.weights;
    
    for i = 1:size(prognosisData.RUL.values,1)
        for j = 1:size(prognosisData.RUL.values,2)
            if prognosisData.RUL.values(i,j)<0
                prognosisData.RUL.values(i,j)=0;
            end
        end
    end
    
%		.cputime = (1 x t) EOL/RUL computation times (optional)
%	alpha is the alpha value in [0 1]; it is optional and defaults to 0.1.
%	sigma is a vector [alpha beta] used for sigma point variance
%		calculation. It must be included to obtain correct variance values
%		for sigma points. For particles, the argument should be omitted.


alphaBeta(1)=0.1; %smaller the value, more stringent the requirement
alphaBeta(2)=0.5; %larger the value, more stringent the requirement

sigma=[0.5,0.5];

M = computePrognosisMetrics(prognosisData,alphaBeta,sigma);
plotAlphaLambda(prognosisData,alphaBeta(1),alphaBeta(2))
%