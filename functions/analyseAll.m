function analyseAll(expID, disp_fig)

% Once mat results files have been created (see results2mat_all.m), this performs all the analyses and output for the experiment
%
% Inputs:
%    expID    - Name of the experiment found on the results file used for file loading (and subsequent naming of outputs)
%    disp_fig - A logical 3 x 1 array (e.g., [1 1 0]) for quick ability to display particular figures, in the order of:
%               [bootstrapped correlations, endpoint analysis, mean timelines].
%               Defaults to show all figures.
% 
% Created by Matt Patten
% Created in Feb 2020
%
% allPieVals{param}(trials, param values, piecases per subject, subjects)

%parameters
numBootstraps = 1000;
cols = 5;
epsilon = 0.01; %how close to the boundary it needs to be in order to be considered converged

[figuresDir, collatedDir] = get_dir('figures','collated'); %get collated results directory (for loading) and figure directory (for saving)
if ~exist(figuresDir,'dir'), mkdir(figuresDir); end %if save directory doesn't exist, create it
filename = [collatedDir 'GenFlwr_results_' expID '_all.mat']; %define data filename

load(filename,'allPieVals','meanPieVals','numTrials','roulette_str','roulette_vals');

%default parameter for 
if nargin<2
    disp_fig = [1 1 1];
end

%update titles to something more readable
[roulette_str, roulette_vals, text_angle] = rename_parameters(expID, roulette_str, roulette_vals); 

%General calculations
numParams = length(roulette_str);
[numTrials, ~, numEvolutions, numSubjects] = size(allPieVals{1});
numTrials = numTrials - 1; %array also includes zero value
for p=1:numParams 
    %this is the only one that changes between parameters as numTrials, numSubjects, 
    %and numPiecases should all be the same across a single experiment.
    numParamValues(p) = size(allPieVals{p},2);
    if numParamValues(p)<=2
        barWidth(p) = 0.55;
        extraspace(p) = 0.65;
    else
        barWidth(p) = 0.8;
        extraspace(p) = 1;
    end
end

rows = ceil(numParams/cols);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    Correlation and bootstrapping    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get correlation coefficients for each participant & parameter, comparing all trials across their two staircases 
for p=1:numParams
    for subj=1:numSubjects
        for val=1:numParamValues(p)
            tmp = corr(squeeze(allPieVals{p}(:,val,:,subj)));
            staircase_corrs{p}(subj,val) = tmp(1,2);
        end
    end
end

%Bootstrap the values for these participants, and get the revelant percentiles on either end
for p=1:numParams
    for val=1:numParamValues(p)
        for b=1:numBootstraps
            bootstrapped_corrs{p}(b,val) = mean(randsample(staircase_corrs{p}(:,val),numSubjects,true));
        end
        percentile_lower{p} = prctile(bootstrapped_corrs{p}, 2.5);
        percentile_upper{p} = prctile(bootstrapped_corrs{p},97.5);
    end
    mean_corrs{p} = mean(staircase_corrs{p});
end

%Plot figure
f = figure;
for p=1:numParams

    subplot(rows,cols,p);
    hold on;
    
    %Add bar
    bar(1:numParamValues(p),mean_corrs{p},'BarWidth',barWidth(p),'EdgeColor','None','FaceColor',[0.7 0.7 0.7]);
    
    %Add errors on bar
    errorbar(1:numParamValues(p), mean_corrs{p}, ... %X,Y
             mean_corrs{p} - percentile_lower{p}, percentile_upper{p} - mean_corrs{p}, ... %error lower/upper
             'LineStyle','None','LineWidth',1,'Color','k','MarkerFaceColor','None','MarkerEdgeColor','None','CapSize',0); %parameters
    
    %Add asterisks if CI is above zero
    for i=1:numParamValues(p)
        if percentile_lower{p}(i)>0
            asterisk_height = min([percentile_upper{p}(i)+0.1,0.9]);
            text(i,asterisk_height,'*','FontSize',14,'FontWeight','Bold','FontName','Arial','HorizontalAlignment','center'); 
            %text(i,0.88,'*','FontSize',14,'FontWeight','Bold','FontName','Arial','HorizontalAlignment','center'); %at specific vertical position
        end
    end

    %set up figure letter
    text(0.07,1-0.88,char(p + 64),'Units','normalized','FontSize',14,'FontWeight','Bold','FontName','Arial','HorizontalAlignment','center','VerticalAlignment','middle');
    
    %Make it look nice
    title(roulette_str{p},'Interpreter','None');
    set(gca,'XLim',[1-extraspace(p) numParamValues(p)+extraspace(p)],'XTick',1:numParamValues(p),'XTickLabels',roulette_vals{p});
    set(gca,'YLim',[-0.5 1]);
    set(gca,'TickLength',[0.03 0.025],'LineWidth',1);
    xtickangle(text_angle(p));
    if mod(p,cols)==1 %if first column
        ylabel('Correlation');    
    else
        set(gca,'YLabel',[],'YTickLabels',[]);
    end
    %xline(max(xlim),'LineWidth',1);
    %yline(max(ylim),'LineWidth',1);
    box off; %axis square;

end
set(gcf, 'Position', [1, 41, 1920, 963]); %set size on screen
saveas(f,[figuresDir expID '_correlations.png']);
saveas(f,[figuresDir expID '_correlations.eps']);
saveas(f,[figuresDir expID '_correlations.fig']);
if ~disp_fig(1), close; end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         End point analysis         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numTTests = sum(cellfun(@(x) sum(x>0), percentile_lower));
FER = 0.025 / numTTests;

for p=1:numParams

    meanEndPoints{p}       = mean(mean(allPieVals{p}(end,:,:,:),3),4);
    stdErrEndPoints{p}     = std(squeeze(mean(allPieVals{p}(end,:,:,:),3)),[],2)' / sqrt(numSubjects); 

    individualEndPoints    = squeeze(mean(allPieVals{p}(end,:,:,:),3))';
    chance_level           = 1./numParamValues(p);
    
    [~, p_values{p}, ~, ttest_stats] = ttest(individualEndPoints, chance_level, 'Tail','both');
    t_score{p} = ttest_stats.tstat;

    %Same as Matlab, but done manually.
    %t_score{p}  = (meanEndPoints{p} - 1./numParamValues(p))./(std(individualEndPoints)./sqrt(numSubjects));
    %p_values{p} = 2*(1-tcdf(abs(t_score{p}),numSubjects-1));
end

%Plot figure
f = figure;

for p=1:numParams

    subplot(rows,cols,p);
    hold on;

    %Draw chance line
    line([0 numParamValues(p)+extraspace(p)],repmat(1/numParamValues(p),1,2),'LineWidth',1,'LineStyle','--','Color','k')
    
    %Add bar
    bar(1:numParamValues(p),meanEndPoints{p},'BarWidth',barWidth(p),'EdgeColor','None','FaceColor',[0.7 0.7 0.7]);
    
    %Add errors on bar
    errorbar(1:numParamValues(p), meanEndPoints{p}, stdErrEndPoints{p}, ... %X,Y,E
             'LineStyle','None','LineWidth',1,'Color','k','MarkerFaceColor','None','MarkerEdgeColor','None','CapSize',0); %parameters

	%Add asterisks/pluses
    for i=1:numParamValues(p)

        %Add pluses for values with CI bootstrapping above zero (from previous section)
        if percentile_lower{p}(i)>0
            text(i,0.05,'+','FontSize',14,'FontName','Arial','HorizontalAlignment','center'); 
            
            %Add asterisks for values significantly different from chance using one sample t-test (with mean being chance level)
            %Only for those that are considered valid via our bootstrapping
            if p_values{p}(i) < FER %0.025 (i.e., two-tailed) but corrected for family-wise error rate
                asterisk_height = min([meanEndPoints{p}(i)+stdErrEndPoints{p}(i)+0.1, 0.95]); %set maximum height
                text(i,asterisk_height,'*','FontSize',14,'FontWeight','Bold','FontName','Arial','HorizontalAlignment','center');
            end
        end
    end
             
    %set up figure letter
    text(0.08,0.89,char(p + 64),'Units','normalized','FontSize',14,'FontWeight','Bold','FontName','Arial','HorizontalAlignment','center','VerticalAlignment','middle');
    
    %Make it look nice
    title(roulette_str{p},'Interpreter','None');
    set(gca,'XLim',[1-extraspace(p) numParamValues(p)+extraspace(p)],'XTick',1:numParamValues(p),'XTickLabels',roulette_vals{p});
    set(gca,'YLim',[0 1]);
    set(gca,'TickLength',[0.03 0.025],'LineWidth',1);
    h=gca; h.XAxis.TickLength = [0 0];
    %set(gca,'Layer','Top');
    xtickangle(text_angle(p));
    if mod(p,cols)==1 %if first column
        ylabel(['Display likelihood' newline]);
    else
        set(gca,'YLabel',[],'YTickLabels',[]);
    end
    %xline(max(xlim),'LineWidth',1);
    %yline(max(ylim),'LineWidth',1);
    box off; %axis square;

end
set(gcf, 'Position', [1, 41, 1920, 963]); %set size on screen
saveas(f,[figuresDir expID '_endpoints.png']);
saveas(f,[figuresDir expID '_endpoints.eps']);
saveas(f,[figuresDir expID '_endpoints.fig']);
if ~disp_fig(2), close; end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         Mean timeline plots         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for p=1:numParams
    meanTimelines{p} = mean(mean(allPieVals{p},3),4);
end

%Plot figure
f = figure;

for p=1:numParams

    subplot(rows,cols,p);
    hold on;

    %Draw chance line
    %line([0 numTrials],repmat(1/numParamValues(p),1,2),'LineWidth',1,'LineStyle','--','Color','k','HandleVisibility','off')

    %Draw "upper convergence" line
    line([0 numTrials],repmat(2*1/numParamValues(p),1,2),'LineWidth',1,'LineStyle','--','Color','k','HandleVisibility','off')
    
    %Plot
    for i=1:numParamValues(p)
        if percentile_lower{p}(i)>0 %basically, asterisks for the plot - change non-significant lines to dotted
            plot(0:numTrials,meanTimelines{p}(:,i),'LineWidth',1.5,'LineStyle','-');
        else
            plot(0:numTrials,meanTimelines{p}(:,i),'LineWidth',1.5,'LineStyle',':');
        end
    end
    
    %Legend
    if isa(roulette_vals{p},'double')
        legend_text = num2str(roulette_vals{p});
    else
        legend_text = roulette_vals{p};
    end
    legend(legend_text,'Location','NorthWest'); %,'AutoUpdate','off');
    %legend boxoff; 
    
    %set up figure letter
    text(0.085,0.1,char(p + 64),'Units','normalized','FontSize',14,'FontWeight','Bold','FontName','Arial','HorizontalAlignment','center','VerticalAlignment','middle');
    
    %Make it look nice
    title(roulette_str{p},'Interpreter','None');
    set(gca,'XLim',[0 numTrials],'XTick',0:(numTrials/4):numTrials);
    set(gca,'YLim',[0 1]);
    set(gca,'TickLength',[0.03 0.025],'LineWidth',1);
    if mod(p,cols)==1 %if first column
        ylabel(['Display likelihood' newline]);
    else
        set(gca,'YLabel',[],'YTickLabels',[]);
    end
    if p > (numParams-cols) %if bottom row
        xlabel([newline 'Trial number']);
    else
        xlabel('');
    end
    %xline(max(xlim),'LineWidth',1,'HandleVisibility','off');
    %yline(max(ylim),'LineWidth',1,'HandleVisibility','off');
    box off; %axis square;

end
set(gcf, 'Position', [1, 41, 1920, 963]); %set size on screen
saveas(f,[figuresDir expID '_mean_timelines.png']);
saveas(f,[figuresDir expID '_mean_timelines.eps']);
saveas(f,[figuresDir expID '_mean_timelines.fig']);
if ~disp_fig(3), close; end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       Find time to convergence       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pieChange = prop * 1 / length(roulette_vals{p}); %how much pie is changed on each trial

%pre-allocate
mean_conv_lower = NaN(numParams,max(numParamValues)); 
mean_conv_upper = NaN(numParams,max(numParamValues));

for p=1:numParams
    all_conv_lower{p} = ones(numSubjects,numParamValues(p))*(numTrials+1); %pre-allocate assuming non-convergence (set all values as one more than the max number of trials)
    all_conv_upper{p} = ones(numSubjects,numParamValues(p))*(numTrials+1); %pre-allocate assuming non-convergence (set all values as one more than the max number of trials)

    num_conv_lower{p} = zeros(numSubjects,numParamValues(p));
    num_conv_upper{p} = zeros(numSubjects,numParamValues(p));
    
    for subj=1:numSubjects
        for val=1:numParamValues(p)
            conv = [];
            %find any indexes where convergence takes place for this parameter value in this subject
            %[r, c] = find(or(squeeze(allPieVals{p}(:,val,:,subj))<0.01, squeeze(allPieVals{p}(:,val,:,subj))>.99)); %allows for a little rounding error
            [r, c] = find(squeeze(allPieVals{p}(:,val,:,subj))<(0+epsilon)); %allows for a little rounding error
            unique_c = unique(c); %identify if it occurs for neither, one or both (ignoring duplicates)
            if ~isempty(unique_c) %if it has occurred
                for strcs=1:length(unique_c) %for each staircase where it occurred
                    conv(strcs) = r(find(unique_c(strcs)==c,1,'first')) - 1; %find trial where it has converged (-1 because index includes 'zero' trial at start)
                end
                all_conv_lower{p}(subj,val) = nanmean(conv); %average between staircases if converged on multiple staircases
                num_conv_lower{p}(subj,val) = length(unique_c);
            end
            
            %Repeat for values of upper convergence
            conv = [];
            %[r, c] = find(squeeze(allPieVals{p}(:,val,:,subj))>(1-epsilon)); %allows for a little rounding error
            [r, c] = find(squeeze(allPieVals{p}(:,val,:,subj))>(2*1/numParamValues(p)-epsilon)); %twice initial chance value
            
            unique_c = unique(c); %identify if it occurs for neither, one or both (ignoring duplicates)
            if ~isempty(unique_c) %if it has occurred
                for strcs=1:length(unique_c) %for each staircase where it occurred
                    conv(strcs) = r(find(unique_c(strcs)==c,1,'first')) - 1; %find trial where it has converged (-1 because index includes 'zero' trial at start)
                end
                all_conv_upper{p}(subj,val) = nanmean(conv); %average between staircases if converged on multiple staircases
                num_conv_upper{p}(subj,val) = length(unique_c);
            end
        end
    end
    
    %average across subjects
    mean_conv_lower(p,1:numParamValues(p)) = mean(all_conv_lower{p}); 
    mean_conv_upper(p,1:numParamValues(p)) = mean(all_conv_upper{p}); 

    %standard deviation - each parameter value is averaged between evolutions in first case, then st dev is taken across subjects only - best for repeated measures mixed design
    stderr_conv_lower(p,1:numParamValues(p)) = std(all_conv_lower{p}) ./ sqrt(numSubjects);
    stderr_conv_upper(p,1:numParamValues(p)) = std(all_conv_upper{p}) ./ sqrt(numSubjects); 
    
    %count for how many subjects the staircase has converged before the experiment end
    numSubj_conv_lower{p} = sum(all_conv_lower{p}<(numTrials+1-epsilon));
    numSubj_conv_upper{p} = sum(all_conv_upper{p}<(numTrials+1-epsilon));
    
    %percent of evolutions converged
    percent_conv_lower{p} = sum(num_conv_lower{p}) ./ (numSubjects*numEvolutions) * 100;
    percent_conv_upper{p} = sum(num_conv_upper{p}) ./ (numSubjects*numEvolutions) * 100;
    
end

excel_upper = display_rank(mean_conv_upper, stderr_conv_upper, percentile_lower, percent_conv_upper, numTrials, numSubjects, epsilon, roulette_vals, roulette_str, 'upper');
excel_lower = display_rank(mean_conv_lower, stderr_conv_lower, percentile_lower, percent_conv_lower, numTrials, numSubjects, epsilon, roulette_vals, roulette_str, 'lower');

excel = [excel_upper; {' ',' ',' ',' ',' ',' '}; excel_lower];

%Matlab only overwrites cells, not files - so if file is shorter than before, old data remains.
%It sucks, so my practise is to delete any current files and create new file which isn't ideal but at least ensures accurate data.
saveFilename = [figuresDir expID '_time_to_convergence.xlsx'];
if exist(saveFilename,'file')
    delete(saveFilename);
end
xlswrite(saveFilename, excel);

end


function [excel] = display_rank(mean_conv, sderr_conv, percentile_lower, percent_conv, numTrials, numSubjects, epsilon, roulette_vals, roulette_str, analysis_type)

fprintf('\nRanking of %s convergence: ', analysis_type); %give list a heading

sorted_conv = unique(sort(reshape(mean_conv,[numel(mean_conv) 1]))); %sort from min to max in order of convergence
sorted_conv = sorted_conv(~isnan(sorted_conv)); %remove NaN's for parameters that don't exist (e.g., one parameter has 6 values but the rest have 3, leaving lots of nans on the table)
sorted_conv = sorted_conv(sorted_conv<(numTrials+1-epsilon)); %remove any that never converged from the list

%display rank order of time to convergence
rank = 1;
%excel = {'Rank','Parameter','Value','Time to convergence',['Number of subjects converged (out of ' num2str(numSubjects) ')']};
excel = {'Rank','Parameter','Value','Mean TtC','Std Err','% conv'};
for i=1:length(sorted_conv)

    vals_fitting_criteria = 0;
    [pp, vv] = find(mean_conv==sorted_conv(i)); %find indexes of this time to convergence
    
    for idx=1:length(pp) %if multiple parameters have this specific time to convergence (e.g., if a parameter has only two values - the time to convergence will be identical, or if the value hasn't converged for anybody)
        param = pp(idx);
        val = vv(idx);
        if percentile_lower{param}(val)>0 %if asterisked/significant bootstrapping
            if isa(roulette_vals{param}(val),'double') %convert any numbered labels to strings
                display_text = num2str(roulette_vals{param}(val));
            else
                display_text = roulette_vals{param}{val};
            end    
            %fprintf('\n%2d: %-35s - %-10s\t(%05.3f)\t[%2d/%2d ppts]',rank,roulette_str{param},display_text,sorted_conv(i),num_conv{param}(val),numSubjects); %display rank on screen
            %excel = [excel; {rank,roulette_str{param},display_text,sorted_conv(i),num_conv{param}(val)}];
            fprintf('\n%2d: %-35s - %-10s\t(%05.3f)\t<%04.2f>\t[%.2f%%]',rank,roulette_str{param},display_text,sorted_conv(i),sderr_conv(param,val),percent_conv{param}(val)); %display rank on screen
            excel = [excel; {rank,roulette_str{param},display_text,sorted_conv(i),sderr_conv(param,val),percent_conv{param}(val)}];
            vals_fitting_criteria = vals_fitting_criteria + 1;
        end
    end
    rank = rank + vals_fitting_criteria; %increase rank number of entries were displayed
end
fprintf('\n');

end