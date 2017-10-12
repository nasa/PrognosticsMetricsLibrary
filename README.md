# PrognosticsMetricsLibrary

This library provides MATLAB software that calculates prognostics metrics. The package is titled “+PrognosticsMetrics”, and a standalone MATLAB file “Tester.m” illustrates how to use the package. 

Inputs to the Package
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


If unscented transform sampling [Ref] is used for prediction, then the samples have so-called sigma-points associated with them. These sigma-points need to be specified as a two-dimensional vector; note that only two sigma points are used within this MATLAB software package. For example, “sigma=[0.5, 0.5]” is a valid assignment. This assignment can be ignored and omitted if unscented transform sampling is not used.

Also, the alpha and beta performance levels [Ref] need to be defined, within a two-dimensional vector. For example, “alphaBeta=[0.1, 0.5]” is a valid assignment. Both these numbers are between 0 and 1. The first argument is an allowed accuracy window; smaller the value, more stringent the requirement. The second argument is related to precision; larger the value, more stringent the requirement.
 
How to load and run the package contents?

In MATLAB, a package is represented by using “+” before the name of the folder containing the package. To load the package use the command: “import PrognosticsMetrics.*”.

This package contains one simple function that calculates all the prognostics metrics. This function can be called using the code: “computePrognosisMetrics(prognosisData,alphaBeta,sigma)”.

While the first argument is the aforementioned structure, the second argument is the 2-dimensional vector containing alpha and beta requirements. These two arguments are mandatory for the function. The third optional argument contains the 2-dimensional vector of sigma-points, and needs to be provided only if unscented transform sampling is used for prediction.
