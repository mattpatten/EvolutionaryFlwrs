function results2excel_ind(userID, subjID, acq)

% Analyse the results file to extract display likelihoods at each time point throughout the experiment,
% and then exported into a Matlab worksheet.
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
%     An excel spreadsheet with:
%           * Trials going down the page.
%           * Headings for each parameter setting at the top of the page, followed by a gap. 
%           * Different value going across the page, grouped into staircases (i.e., staircase 1 on the left,
%             staircase 2 on the right).
%           * Each sheet contains a different parameter, labeled as such.
%
% Created by Matt Patten
% Created in August, 2019.


%get results directory (for loading) and figure directory (for saving)
[resultsDir, figuresDir] = get_dir('results','figures');
if ~exist(figuresDir,'dir'), mkdir(figuresDir); end %if save directory doesn't exist, create it

%define save name
saveName_excel = [figuresDir 'Piecases_' userID '_' subjID '_' num2str(acq) '.xlsx'];

%load results file
load([resultsDir 'GenFlwr_results_' userID '_' subjID '_' num2str(acq) '.mat']);

%annonymous function to convert number to equivalent letter of the alphabet (i.e., 13-->'m')
%this is in order to write the range location in excel. e.g., A5:D9
number2letter = upper(@(n) upper(char(n-1+'a')));

for pp = 1:e.numPiecases %for each piecase

    for i=1:length(roulette_str) %for each parameter
        
        %extract meaningful data from the results (pieLog)
        piecaseNum = cell2mat(pieLog(:,2)); %turn the piecase number run on each trial into a vector for easy logical testing
        paramIdx   = find(and(strcmpi(pieLog(:,4),roulette_str{i}),... %get row indices relating to this specific parameter
                          or(piecaseNum==0,piecaseNum==pp)));          %but only for this specific piecase (as well as for 0 i.e., pre-trial)

        paramVals  = roulette_vals{i};             %get values of this parameter
        trials     = cell2mat(pieLog(paramIdx,3)); %get trial numbers to use along x-axis
        pieVals    = cell2mat(pieLog(paramIdx,6)); %get pie values to use as y-values

        numTrials = max(trials); 
        finalPieVals{pp,i} = pieVals(numTrials+1,:);

        %collate data that is going to be displayed
        all_trials = [paramVals'; NaN(1,length(paramVals)); pieVals];

        %find range to put data
        if pp==1
            col=1;
        elseif pp==2
            col=length(paramVals)+2;
        end
        
        %write to excel
        warning off; %turn off warning about creating new excel sheet for each paramter
        xlswrite(saveName_excel, all_trials, roulette_str{i}, strcat(number2letter(col), '1'));
        warning on;
    end
end

end