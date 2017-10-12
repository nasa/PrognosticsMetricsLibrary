function plotHandles = plotAlphaLambda(data,alpha,beta,opts)
% plotAlphaLambda(data,alpha,beta,opts)
%	Makes alpha-lambda(-beta) plot for distributions
%	data is a struct with the following form:
%		.time = (1 x t) time vector of prediction time points
%		.EOL.true = (1 x t) true EOL values at each prediction time
%		.EOL.values = (N x t) EOL prediction distributions at each
%			prediction time. It is assumed that all points of the
%			distribution are equally weighted.
%		.RUL.true = (1 x t) true RUL values
%		.RUL.values = (N x t) RUL prediction distributions at each
%			prediction time. It is assumed that all points of the
%			distribution are equally weighted.
%	alpha is the alpha value in [0 1]
%	beta is the beta value in [0 1]
%	opts is an optional argument. It is a structure with the following
%		fields (all optional):
%			boxFill = color to fill the box plots (default [.4 .5 .6])
%			coneFill = color to fill the alpha-cone (default [0.95 0.95 0.95])
%			width = width of box plots (default 1)
%			timeUnits = time units of predictions and time vector (default 's')
%			FontName = font name for all fonts in the figure (default 'Times')
%			FontSize = font size for true/false and beta values (default 10)
%			showResults = whether to print True/False and beta results on plot (default 1)
%			xR = x-offset of True/False text (default -3)
%			yR = y-offset of True/False text (default 10)
%			xB = x-offset of actual beta value text (default -3)
%			yB = y-offset of actual beta value text (default 5)
%			printSummary = whether to print summary of results (default 0)
%			textColor = color of text in plot (default [0 0 0])
%			lineColor = color of lines in plot (default [0 0 0])
%			style = plot style. 'tufte' for Tufte-style box plots
%				(default), or 'tukey' for Tukey-style box plots

import PrognosticsMetrics.*;


% set up default options
options = struct('boxFill',[.4 .5 .6],'coneFill',[.95 .95 .95],'width',1,...
	'timeUnits','s','showResults',1,'xR',-3,'yR',10,'xB',-3,'yB',5,...
	'printSummary',0,'FontName','Times','textColor',[0 0 0],'lineColor',[0 0 0],...
	'style','tufte','MarkerSize',3,'FontSize',10,'UTParams',[],'completeLegend',0,...
	'name','RUL');

if nargin>3
	options = copyStruct(options,opts);
end

hold on;

% first plot the cone (assume no prediction at time=0, so cone values there
% are EOL)
ph = patch([0 0 data.EOL.true(1)],[(1-alpha)*data.EOL.true(1) (1+alpha)*data.EOL.true(1) 0],options.coneFill,'EdgeColor',options.coneFill);%,'EdgeAlpha',0);
lh = plot([0 data.time data.EOL.true(1)],[data.EOL.true(1) data.RUL.true 0],'Color',options.lineColor,'LineStyle','--');
%plotHandles(2,1) = plot([0 data.time data.EOL.true(1)],(1+alpha)*[data.EOL.true(1) data.RUL.true 0],'LineStyle','--','Color',options.lineColor);
%plot([0 data.time data.EOL.true(1)],(1-alpha)*[data.EOL.true(1) data.RUL.true 0],'LineStyle','--','Color',options.lineColor);
%plotHandles = plotHandles([1 2]);
plotHandles = [lh; ph];

worstBeta = 1;
worstRAMean = 1;
worstRAMedian = 1;
RMAD = [];

% make the boxplot
for i=1:length(data.time)
	
	% gather some statistics
	if isempty(options.UTParams)
		pctInBounds = percentInBounds(data.RUL.values(:,i),(1-alpha)*data.RUL.true(i),(1+alpha)*data.RUL.true(i),beta);
	else
		% compute wmean and wcov, sample from distribution, and give that
		% value to percentInBounds
		Pxx = wcov(data.RUL.values(:,i),data.RUL.weights(:,i),options.UTParams(1),options.UTParams(2));
		mx = wmean(data.RUL.values(:,i),data.RUL.weights(:,i));
		skew = wskew(data.RUL.values(:,i),data.RUL.weights(:,i));
		if isnan(skew)
			% could happen if Pxx is zero
			skew = 0;
		end
		%X = mx + sqrt(Pxx)*randn(1,10000);
		%%%X = skewgen(median(data.RUL.values(:,i)),Pxx,skew,10000);
		X = skewgen(mx,Pxx,skew,10000);
		pctInBounds = percentInBounds(X,(1-alpha)*data.RUL.true(i),(1+alpha)*data.RUL.true(i));
		options.X = X;
	end
	RAMean = 1-abs(data.RUL.true(i)-mean(data.RUL.values(:,i)))/data.RUL.true(i);
	RAMedian = 1-abs(data.RUL.true(i)-median(data.RUL.values(:,i)))/data.RUL.true(i);
	
	% boxplot
	[h,loc] = plotbox(data.RUL.values(:,i),data.time(i),options.width,options.boxFill,options);
	
	if options.showResults
		% add results for this point
		th = text(loc(1)+options.xB,loc(2)+options.yB,[sprintf('%.1f',pctInBounds*100) '%']);
		set(th,'FontName',options.FontName,'Color',options.textColor,'FontSize',options.FontSize);
		if pctInBounds >= beta
			resultStr = 'True';
			resultColor = options.textColor;
		else
			resultStr = 'False';
			resultColor = [0.9 0 0];
		end
		th = text(loc(1)+options.xR,loc(2)+options.yR,resultStr,'Color',options.textColor);
		set(th,'Color',resultColor,'FontName',options.FontName,'FontSize',options.FontSize);
	end
	
	if options.printSummary
		% print info
		fprintf('Summary for time %g:\n',data.time(i));
		fprintf('\tBounds: [%g %g]\n',(1-alpha)*data.RUL.true(i),(1+alpha)*data.RUL.true(i));
		fprintf('\tFraction in bounds: %g\n',pctInBounds);
		fprintf('\tMean: %g\n',mean(data.RUL.values(:,i)));
		fprintf('\tMedian: %g\n',median(data.RUL.values(:,i)));
		fprintf('\tStandard Deviation: %g\n',std(data.RUL.values(:,i)));
		fprintf('\tMean Absolute Deviation: %g\n',mad(data.RUL.values(:,i)));
		fprintf('\tMedian Absolute Deviation: %g\n',mad(data.RUL.values(:,i),'median'));
		fprintf('\tRelative Accuracy (Mean): %g\n',RAMean);
		fprintf('\tRelative Accuracy (Median): %g\n',RAMedian);
	end
	
	% update worsts
	worstBeta = min(worstBeta,pctInBounds);
	worstRAMean = min(worstRAMean,RAMean);
	worstRAMedian = min(worstRAMedian,RAMedian);
	RMAD(end+1) = rmad(data.RUL.values(:,i),'median');
	
end

if options.printSummary
	fprintf('Overall Summary:\n');
	fprintf('\tWorst RA (Mean): %g (Pass=%g)\n',worstRAMean,1-worstRAMean<alpha);
	fprintf('\tWorst RA (Median): %g (Pass=%g)\n',worstRAMedian,1-worstRAMedian<alpha);
	fprintf('\tWorst beta: %g (Pass=%g)\n',worstBeta,worstBeta>=beta);
	fprintf('\tAverage RMAD: %g\n',mean(RMAD));
end

plotHandles = [plotHandles];%; h'];
boxHandles = h;
if options.completeLegend==0.5
	set(boxHandles(1),'Color',[1 1 1]);
	set(boxHandles(1),'MarkerSize',5);
	h = legend([plotHandles; boxHandles(1)],['$' options.name '^*$'],['$[(1-\alpha)' options.name '^*,(1+\alpha)' options.name '^*]$'],['Median $' options.name '$ Prediction']);
elseif options.completeLegend==0.75
	set(boxHandles(1),'Color',[1 1 1]);
	set(boxHandles(1),'MarkerSize',5);
	h = legend([plotHandles; boxHandles(1)],['$' options.name '^*$'],['$[(1-\alpha)' options.name '^*,(1+\alpha)' options.name '^*]$'],['Min./Median/Max. $' options.name '$ Prediction']);
elseif options.completeLegend==1
	set(boxHandles(1),'Color',[1 1 1]);
	set(boxHandles(1),'MarkerSize',5);
	h = legend([plotHandles; boxHandles'],['$' options.name '^*$'],['$[(1-\alpha)' options.name '^*,(1+\alpha)' options.name '^*]$'],['Median $' options.name '$ Prediction'],'$5$-$25\%$ and $75$-$95\%$ Ranges');
else
	h = legend(plotHandles,['$' options.name '^*$'],['$[(1-\alpha)' options.name '^*,(1+\alpha)' options.name '^*]$']);
	%,'Interquartile Range','Mean RUL','5th and 95th Percentiles');
end
plotHandles = [plotHandles; boxHandles'];
set(h,'FontName',options.FontName,'TextColor',options.textColor,'Interpreter','latex','FontSize',options.FontSize);
legend boxoff;

xlim([0 data.EOL.true(end)+options.width/2]);
xlabel(['Time (' options.timeUnits ')'],'FontName',options.FontName,'FontSize',options.FontSize);
ylabel([options.name ' (' options.timeUnits ')'],'FontName',options.FontName,'FontSize',options.FontSize);
set(gca,'FontName',options.FontName,'TickDir','out','layer','top','FontSize',options.FontSize);
title(['\alpha=' num2str(alpha) ', \beta=' num2str(beta)],'FontName',options.FontName);


function [boxhandles,upperMark] = plotbox(X,k,width,fillColor,options)

import PrognosticsMetrics.*;

if isfield(options,'X')
	Y = sort(options.X);
else
	Y = sort(X);
end

% compute quartiles
Q(1) = median(Y(Y<median(Y)));
Q(2) = median(Y);
Q(3) = median(Y(Y>median(Y)));

switch options.style
	
	case 'tukey'
		
		% make the box
		h = patch([k-width/2 k+width/2 k+width/2 k-width/2],[Q(1) Q(1) Q(3) Q(3)],fillColor);
		boxhandles = h;
		h = line([k-width/2 k+width/2],[Q(2) Q(2)]);
		set(h,'Color',options.lineColor);
		
		% mark the mean
		h = line(k,mean(Y));
		set(h,'LineStyle','.','Marker','o','Color',options.lineColor,'MarkerFaceColor',options.lineColor);
		boxhandles(end+1) = h;
		
		% plot confidence line (whiskers)
		h = line([k k],[percentile(Y,.05) percentile(Y,.95)]);
		set(h,'Color',options.lineColor);
		h = line([k k],[percentile(Y,.05) percentile(Y,.95)]);
		set(h,'LineStyle','.','Marker','+','Color',options.lineColor);
		boxhandles(end+1) = h;
		upperMark = [k percentile(Y,.95)];
		
	case 'tufte'
		
		boxhandles = [];
		
		% mark the median
		h = line(k,median(Y));
		set(h,'Marker','o','Color',options.lineColor,...
			'MarkerFaceColor',options.lineColor,'MarkerSize',options.MarkerSize);
		boxhandles(end+1) = h;
		
		% plot the quartile lines
		h = line([k k],[Q(3) percentile(Y,.95)]);
		set(h,'Color',options.lineColor,'LineWidth',1.5);
		h = line([k k],[Q(1) percentile(Y,.05)]);
		set(h,'Color',options.lineColor,'LineWidth',1.5);
		%h = line([k k],[percentile(Y,.05) percentile(Y,.95)]);
		%set(h,'LineStyle','.','Marker','+','Color',options.lineColor);
		boxhandles(end+1) = h;
		upperMark = [k percentile(Y,.95)];
		
	case 'points'
		
		boxhandles = [];
		
		% plot median, min, max
		h(1) = line(k,median(Y));
		h(2) = line(k,min(Y));
		h(3) = line(k,max(Y));
		% set style
		set(h,'Marker','o','Color',options.lineColor,...
				'MarkerFaceColor',options.lineColor,'MarkerSize',options.MarkerSize);
		upperMark = [k max(Y)];
		boxhandles = h(1);
end




