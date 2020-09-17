function addToPieLog(trial, pieNum, pie_trialNum, name, vals, pie)

% This saves the pie data (likelihood of showing particular settings of each parameter)
% at the end of each trial to a variable used as a log so that we can see the shift in 
% the distribution of preferred parameter settings over the course of the experiment.
% 
% Inputs:
%    trial        - Positive integer indicating which trial was just completed. (or '0' for 
%                   initial values)
%    pieNum       - Which staircase was run on this trial.
%    pie_trialNum - The numbered trial of this specific staircase that was run for this trial.
%    name         - A cell array containing the parameter names to be saved as identifiers. 
%                   e.g., {'st.r.avgPetals',...}
%    vals         - A cell array containing parameter settings/variables that are chosen on each 
%                   trial. e.g., {[5; 10; 25; 45],...}
%    pie          - A cell array containing the proportion of likelihood (or weights) that each of 
%                   these variables will be displayed. e.g., {[0.1, 0.15, 0.25, 0.5],...}
%
% Output:
%    Updates the global pieLog and pieCounter variables with information from this trial.
%
% Created by Matt Patten
% Created on 4/6/2019


global pieLog;
global pieCounter;


for pp=1:length(pie) %for each parameter that is being varied

    %save trial, parameter details and their likelihoods/weights
    pieLog{pieCounter,1} = trial;
    pieLog{pieCounter,2} = pieNum;
    pieLog{pieCounter,3} = pie_trialNum;
    pieLog{pieCounter,4} = name{pp};
    pieLog{pieCounter,5} = vals{pp};
    pieLog{pieCounter,6} = pie{pp};

    %increment counter to write on next row for next trial
    pieCounter = pieCounter + 1;
end

end