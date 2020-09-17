function results2excel_mean(expID)

% Analyse experiment results, generating plots of the likelihood distributions (pies) and their 
% change over the course of the experiment for each of the manipulated parameters.
%
% Inputs:
%     expID - A string of the experimenter's initials (used in the results filename).
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


[resultsDir, figuresDir] = get_dir('results','figures'); %get results directory (for loading) and figure directory (for saving)
if ~exist(figuresDir,'dir'), mkdir(figuresDir); end %if save directory doesn't exist, create it
saveName_excel = [figuresDir 'GenFlwr_results_' expID '_mean.xlsx']; %define save name


%get filenames of all results files
a = dir(resultsDir);
for param=1:length(a)
    filenames{param} = a(param).name;
end

%find indexes for all results files for this experiment
match_locations = regexp(filenames,['GenFlwr_results_' expID '_\d{1,3}_\d{1,2}.mat']);
idxs = ~cellfun(@isempty, match_locations);
filenames = filenames(idxs);

%setup of annonymous function to convert number to equivalent letter of the alphabet (i.e., 13-->'m')
%this is in order to write the range location in excel. e.g., A5:D9
%number2letter = upper(@(n) upper(char(n-1+'a')));

for rr=1:length(filenames) %for each result

    %load results file
    load([resultsDir filenames{rr}]);
    
    for param=1:length(roulette_str) %for each parameter
    
        for pp = 1:e.numPiecases %for each piecase

            %extract meaningful data from the results (pieLog)
            piecaseNum = cell2mat(pieLog(:,2)); %turn the piecase number run on each trial into a vector for easy logical testing
            paramIdx   = find(and(strcmpi(pieLog(:,4),roulette_str{param}),... %get row indices relating to this specific parameter
                or(piecaseNum==0,piecaseNum==pp)));          %but only for this specific piecase (as well as for 0 i.e., pre-trial)
            
            paramVals = roulette_vals{param};             %get values of this parameter
            trials    = cell2mat(pieLog(paramIdx,3)); %get trial numbers to use along x-axis
            pieVals   = cell2mat(pieLog(paramIdx,6)); %get pie values to use as y-values
            
            if rr==1 && pp==1 %on first run of each parameter
                allParamVals{param} = paramVals; %get header 
                allPieVals{param} = pieVals; %save as new variable 
            else %otherwise
                allPieVals{param} = cat(3,allPieVals{param},pieVals); %concatenate it on the third dimension
            end
        end
    end
    numTrials(rr) = max(trials);
end

%apply mean across the third dimension
meanPieVals = cellfun(@(x) mean(x,3),allPieVals,'UniformOutput',0);

% Write to excel
for param=1:length(roulette_str) %for each parameter
    
    %collate data that is going to be displayed
    output = [allParamVals{param}'; NaN(1,length(allParamVals{param})); meanPieVals{param}];
    
    %write to excel
    warning off; %turn off warning about creating new excel sheet for each paramter
    xlswrite(saveName_excel, output, roulette_str{param});
    warning on;
end

end