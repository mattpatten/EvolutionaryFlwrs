function results2mat_all(expID)

% Analyse experiment results, generating plots of the likelihood distributions (pies) and their 
% change over the course of the experiment for each of the manipulated parameters.
%
% Inputs:
%     expID - A string of the experimenter's initials (used in the results filename).
%
% Output:
%     A figure is displayed on screen for each of the piecases that was run during the experiment,
%     showing the change in the pie for each manipulated parameter over the course of the experiment.
%     The figure is saved as a .png file under /../results/figures/ using the same filename format 
%     as the results file.
%
% Created by Matt Patten
% Created in June, 2019.


[resultsDir, collatedDir] = get_dir('results','collated'); %get results directory (for loading) and figure directory (for saving)
if ~exist(collatedDir,'dir'), mkdir(collatedDir); end %if save directory doesn't exist, create it
saveName_mat = [collatedDir 'GenFlwr_results_' expID '_all.mat']; %define save name


%get filenames of all results files
a = dir(resultsDir);
for param=1:length(a)
    filenames{param} = a(param).name;
end

%find indexes for all results files for this experiment
match_locations = regexp(filenames,['GenFlwr_results_' expID '_\w{1,3}_\d{1,2}.mat']);
idxs = ~cellfun(@isempty, match_locations);
filenames = filenames(idxs);

%setup of annonymous function to convert number to equivalent letter of the alphabet (i.e., 13-->'m')
%this is in order to write the range location in excel. e.g., A5:D9
%number2letter = upper(@(n) upper(char(n-1+'a')));

for ss=1:length(filenames) %for each result

    %load results file
    load([resultsDir filenames{ss}]);
    
    for param=1:length(roulette_str) %for each parameter
    
        for pp = 1:e.numPiecases %for each piecase

            %extract meaningful data from the results (pieLog)
            piecaseNum = cell2mat(pieLog(:,2)); %turn the piecase number run on each trial into a vector for easy logical testing
            paramIdx   = find(and(strcmpi(pieLog(:,4),roulette_str{param}),... %get row indices relating to this specific parameter
                or(piecaseNum==0,piecaseNum==pp)));          %but only for this specific piecase (as well as for 0 i.e., pre-trial)
            
            paramVals = roulette_vals{param};             %get values of this parameter
            trials    = cell2mat(pieLog(paramIdx,3)); %get trial numbers to use along x-axis
            pieVals   = cell2mat(pieLog(paramIdx,6)); %get pie values to use as y-values

            if ss==1 && pp==1 %on first run of each parameter
                allParamVals{param} = paramVals; %get header
                meanPieVals{param} = pieVals;
            else
                meanPieVals{param} = cat(3,meanPieVals{param},pieVals); %concatenate it on the third dimension
            end

            allPieVals{param}(:,:,pp,ss) = pieVals; %save as new variable
        end
    end
    numTrials(ss) = max(trials);
end

%apply mean across the third dimension
meanPieVals = cellfun(@(x) mean(x,3),meanPieVals,'UniformOutput',0);

save(saveName_mat,'allPieVals','meanPieVals','numTrials','roulette_str','roulette_vals');

end