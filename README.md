# PrognosticsMetricsLibrary

This library provides MATLAB software that calculates prognostics metrics. The package is titled “+PrognosticsMetrics”, and a standalone MATLAB file “Tester.m” illustrates how to use the package. This tester creates dummy-output of a prognostic algorithm and explains how the software can be used to compute the performance metrics.

## Prognostics
After diagnosing the faults of a system, performing Prognostics is useful for determining the evolution of these faults. Analysis of fault development is critical when predicting the Remaining Useful Life (RUL) of a system and setting criteria for landmarks or thresholds in the future. Whether data-driven or physics-based, models are utilized as representations of a system for Prognostic algorithms to be performed.

## Prognostic Metrics
Prognostic algorithms are implemented in order to determine the Remaining Useful Life (RUL) of a system.  Prognostic Metrics are incorporated into the health management decision making process by analyzing the performance of these algorithms.  Establishing standard methods for performance assessment is essential in uniformly comparing certain aptitudes or measures across several algorithms.  Statistical evaluation methods are often advantageous when dealing with large datasets.

Some sources of error that could be associated with a system include model inaccuracy, data noise, observer faults, etc. Additional considerations when determining which Prognostic Metrics to adopt are logistics, saftey, reliability, mission criticality, and economic viability (estimating cost savings expected from prognostic algorithm deployment).

## Prognostic Framework Terminology
* PDF = Probability Density Function
* UUT = Unit Under Test
* PA = Prognostic Algorithm
* PHM = Prognostic Health Management
* RUL = Remaining Useful Life
* EoL = End of Life
* EoP = End of Prediction, time index of last prediction before EoL
* EoUP = End of Useful Predictions, time index where RUL is no longer useful to update
* HI = Health Index
* PoF = Probability of Failure
* FT = Failure Threshold, UUT is no longer usable
* RtF = Run to Failure, allow system to fail
* ROI = Return On Investment
* F = time index when fault becomes detectable
* D = time index when fault is detected
* P = time index of first prognostic prediction
* PH = Prognostic Horizon


## Inputs to the Package

The present version of metrics considers only the case when the algorithm predictions are described in terms of samples. Different predictions are available at different time instants. Let “t” denote the number of such time instants for which the algorithm’s predictions are available. At each such time instant, “N” samples of predictions (both EOL – End of Life, and RUL – Remaining Useful Life) are available. The samples also have weights associated with them; it is important to specify weights (the sum of weights should be equal to 1). If the samples are unweighted, then it is implied that the weight of each sample is 1/N.

To calculate all the possible metrics provided within this software package, a MATLAB structure “prognosisData” needs to be provided. The elements of this structure include:

1.	prognosisData.time = (1 x t) time vector of prediction time points
2.	prognosisData.EOL.true = (1 x t) true EOL values at each prediction time
3.	prognosisData.EOL.values = (N x t) EOL prediction values at each prediction time.
4.	prognosisData.EOL.weights = (N x t) EOL prediction weights at each prediction time.
5.	prognosisData.RUL.true = (1 x t) true RUL values
6.	prognosisData.RUL.values = (N x t) RUL prediction values at each prediction time.
7.	prognosisData.RUL.weights = (N x t) RUL prediction weights at each prediction time.
8.	prognosisData.cputime = (1 x t) EOL/RUL computation times (optional)


If unscented transform sampling [1] is used for prediction, then the samples have so-called sigma-points associated with them. These sigma-points need to be specified as a two-dimensional vector; note that only two sigma points are used within this MATLAB software package. For example, 
> sigma=[0.5, 0.5] 

is a valid assignment. This assignment can be ignored and omitted if unscented transform sampling is not used.

Also, the alpha and beta performance requirement levels [2] need to be defined by the user, as a two-dimensional vector. For example, 
> alphaBeta=[0.1, 0.5] 

is a valid assignment. Both the above numbers need to be between 0 and 1. The first argument is an allowed accuracy window; smaller the value, more stringent the requirement. The second argument is related to precision; larger the value, more stringent the requirement.
 
## How to load and run the package contents?

In MATLAB, a package is represented by using “+” before the name of the folder containing the package. To load the package use the command: 
> import PrognosticsMetrics.*

This package contains one simple function that calculates all the prognostics metrics. This function can be called using the code: 
> computePrognosisMetrics(prognosisData,alphaBeta,sigma)

While the first argument is the aforementioned structure, the second argument is the 2-dimensional vector containing alpha and beta requirements. These two arguments are mandatory for the function. The third optional argument contains the 2-dimensional vector of sigma-points, and needs to be provided only if unscented transform sampling is used for prediction.

## Description of Output Metrics

**Alpha-Lambda Performance** <br />
Alpha-Lambda Performance is a binary metric that outputs either 1 or 0. At a specific time index, lambda, it questions whether the prediction remains within a cone of accuracy (marked by alpha bounds) as the system approaches EoL.  If a desired condition is met, indicated by the probability mass being greater than Beta, minimal acceptable probability, at lambda time then the output is 1. Otherwise, the return is 0.

**Relative Accuracy** <br />
Relative Accuracy is the measure of error in RUL prediction relative to the actual RUL. Because it indicates how accurately the algorithm is performing at a certain time, Prognostic algorithms with larger Relative Accuracies are more desirable.

**Convergence** <br />
The Convergence Metric determines the rate at which a Metric (ex: accuracy or precision) improves over time. As more information accumulates along with the system progression, it is assumed that algorithm performance also improves.  Convergence is calculated by finding the distance between the origin and centroid of area under the curve for a metric.

Smaller the distance, faster the convergence. Faster the convergence indicates higher confidence in keeping the Prediction Horizon as large as possible.

## Alpha-Lambda Performance Plot

In addition to computing the metrics, this software package can also plot the alpha-lambda performance [2] plot, using the command
> plotAlphaLambda(prognosisData,alphaBeta(1),alphaBeta(2))

Note that there are three arguments, and all three are mandatory. The first is the input structure, the second and the third are the alpha and beta values respectively [2].


## References

1. M. Daigle, A. Saxena, and K. Goebel, “An efficient deterministic approach to model-based prediction uncertainty estimation,” in Annual Conference of the Prognosticsand Health Management Society, 2012, Minneapolis, MN, USA.
2. Saxena, A., Celaya, J., Saha, B., Saha, S., & Goebel, K. Metrics for Offline Evaluation of Prognostic Performance. International Journal of Prognostics and Health Management, Vol. 1, No. 1,  21 pages, 2010.
