function analysePie(userID, subjID, acq)

% Analyse experiment results, generating plots of the likelihood distributions (pies) and their 
% change over the course of the experiment for each of the manipulated parameters.
%
% Inputs:
%     userID - A string of the experimenter's initials (used in the results filename).
%     subjID - A string descriptor (participant initials or unique number/identifier) to describe the 
%              participant whose data was collected (used in the results filename).
%     acq    - Acquisition number, to describe the session number of this participant being collected.
%              i.e., if you ran the same subject 3 times, the userID and subjID is the same but the 
%              acq number is incremented each time (used in the results filename).
%
% Output:
%     A figure is displayed on screen for each of the piecases that was run during the experiment,
%     showing the change in the pie for each manipulated parameter over the course of the experiment.
%     The figure is saved as a .png file under /../results/figures/ using the same filename format 
%     as the results file.
%
% Created by Matt Patten
% Created in June, 2019.


%get results directory (for loading) and figure directory (for saving)
[resultsDir, figuresDir] = get_dir('results','figures');
if ~exist(figuresDir,'dir'), mkdir(figuresDir); end %if save directory doesn't exist, create it

%define save names
saveName_bar  = [figuresDir 'Piecases_' userID '_' subjID '_' num2str(acq) '_bargraph'];
saveName_allpies = [figuresDir 'Piecases_' userID '_' subjID '_' num2str(acq) '_allpies'];

%load results file
load([resultsDir 'GenFlwr_results_' userID '_' subjID '_' num2str(acq) '.mat']);

%update titles to something more readable
[param_str, vals_str, text_angle] = rename_parameters(userID, roulette_str, roulette_vals); 

%decide figure layout
numCols = 4;
numRows = ceil(length(roulette_str)/numCols);


for pp = 1:e.numPiecases %for each piecase

    %open graph and give it a unique filename
    f = figure;
    saveName = [figuresDir 'Piecases_' userID '_' subjID '_' num2str(acq) '_pie' num2str(pp)];

    for i=1:length(roulette_str) %for each parameter
        
        %reset legend string
        leg = strings; 
        
        %extract meaningful data from the results (pieLog)
        piecaseNum = cell2mat(pieLog(:,2)); %turn the piecase number run on each trial into a vector for easy logical testing
        paramIdx   = find(and(strcmpi(pieLog(:,4),roulette_str{i}),... %get row indices relating to this specific parameter
                          or(piecaseNum==0,piecaseNum==pp)));          %but only for this specific piecase (as well as for 0 i.e., pre-trial)

        paramVals  = roulette_vals{i};             %get values of this parameter
        trials     = cell2mat(pieLog(paramIdx,3)); %get trial numbers to use along x-axis
        pieVals    = cell2mat(pieLog(paramIdx,6)); %get pie values to use as y-values

        numTrials = max(trials); 
        finalPieVals{pp,i} = pieVals(numTrials+1,:);
        
        %get string values for legend
        %{
        legstr = string(roulette_vals{i});
        for ss=1:size(legstr,1)
            leg(ss) = strjoin(legstr(ss,:));
        end
        all_legs{i} = leg;
        %}
        
        %Legend
        if isa(vals_str{i},'double')
            legend_text{i} = num2str(vals_str{i});
        else
            legend_text{i} = vals_str{i};
        end

        
        %draw graph
        subplot(numRows,numCols,i);
        plot(trials,pieVals,'LineWidth',1);
        xlabel('Trials');
        ylabel('Display likelihood (prop)');
        xlim([trials(1) trials(end)]);
        ylim([0 1]);
        yticks(0:0.2:1);
        title(sprintf('Pie #%i: %s',pp,param_str{i}),'Interpreter','None');
        legend(legend_text{i},'Location','NorthWest');
        box off;
        %axis square;
    end
    
    set(gcf, 'Position', [1, 41, 1920, 963]); %set size on screen
    saveas(f,[saveName '.png']); %save as png file in figure directory
    %close(f);
end

%get mean and sd across pies
for i=1:length(roulette_str) %for each parameter
    meanFinalVals{i} = mean(cell2mat(finalPieVals(:,i)),1);
    stderrFinalVals{i}  = std(cell2mat(finalPieVals(:,i)),[],1)./sqrt(e.numPiecases);
end


%% Bar graph %%
%open graph and give it a unique filename
f = figure;

for i=1:length(roulette_str)
    
    %draw graph
    subplot(numRows,numCols,i);
    hold all;
    bar(1:length(meanFinalVals{i}),meanFinalVals{i});
    errorbar(1:length(meanFinalVals{i}),meanFinalVals{i},stderrFinalVals{i},'LineStyle','None','CapSize',0);
    if i > (length(roulette_str) - numCols)
        xlabel('Values'); %only on the bottom row
    end
    if mod(i,numCols)==1
        ylabel('Display likelihood (prop)'); %only display for first column
    end
    ylim([0 1]);
    yticks(0:0.5:1);
    xlim([0.5 0.5+length(meanFinalVals{i})]);
    xticks(1:length(meanFinalVals{i}));
    xticklabels(legend_text{i});
    xtickangle(text_angle(i));
    title(sprintf('%s',param_str{i}),'Interpreter','None');
    box off;

end

set(gcf, 'Position', [1, 1, 270*numCols, 400*numRows]); %set size on screen
saveas(f,[saveName_bar '.png']); %save as png file in figure directory
%close(f);


%% Pie graphs %%
%open graph and give it a unique filename
f = figure;

for i=1:length(roulette_str)

    %change any zeros to eps to make positive (required to be given a piece of the pie)
    meanFinalVals{i}(meanFinalVals{i}==0)=eps; 

    %draw graph
    subplot(numRows,numCols,i);
    pie3(meanFinalVals{i},string(legend_text{i}));
    title(sprintf('%s',param_str{i}),'Interpreter','None');
end

set(gcf, 'Position', [1, 41, 1920, 963]); %set size on screen
saveas(f,[saveName_allpies '.png']); %save as png file in figure directory
%close(f);

end