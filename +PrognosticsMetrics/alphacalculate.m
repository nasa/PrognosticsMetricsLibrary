function yesno=alphacalculate(meanprediction,truth,alpha)
% Calculates whether the mean-prediction is within alpha-bounds of truth
% yesno is a binary variable - 1 if the mean-prediction is within the bounds

if meanprediction > truth*(1-alpha) || meanprediction < truth*(1+alpha)
   yesno=1;
else
    yesno=0;
end

