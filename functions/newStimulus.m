function newStimulus(trialNum, piecase, piecase_trialNum, flowerNum, st, all_stim_properties)

% Every time the user presses a response button, store information about the 
% event (reaction time, trial number, etc) and then extract and save all of 
% the stimulus parameters for the image that they selected.
%  
% Inputs:
%    trialNum            - Which trial number is currently taking place.
%    piecase             - which staircase the experiment is extracting likelihood details from
%    piecase_trialNum    - The trial number specific to this staircase (and not the overall experiment).
%    flowerNum           - Which of the 6 flowers are being stored.
%    st                  - A struct containing all of the stimulus parameters for the selected flower.
%    all_stim_properties - A cell array containing all of the stimulus parameter names (as strings).
%
% Output:
%    Writes a line to the global variable 'stimLog' storing information about all current
%    stimuli details, and increments 'stimCounter' so the next time 
%    this function is called it writes to the next line.
%
%Created by Matt Patten
%Created on 30/5/2019


global stimLog;
global stimCounter;

disp(['stimCounter: ' num2str(stimCounter) '  trialNum: ' num2str(trialNum)]); 
if and(flowerNum==1, ceil((stimCounter-2)/6)==trialNum)
    stimCounter = stimCounter - 6;
end

%save event information
stimLog{stimCounter,1} = trialNum;              %trial
stimLog{stimCounter,2} = piecase;               %which staircase
stimLog{stimCounter,3} = piecase_trialNum;      %trial number for this staircase
stimLog{stimCounter,4} = flowerNum;             %flower 

paramCount = 5; %define index column for saving 

%go through all fields of our stimulus struct and save the details
for i=1:length(all_stim_properties)
    stimLog{stimCounter, paramCount} = eval(all_stim_properties{i}); %add the value of this field to the response log
    paramCount = paramCount+1; %move to next column
end

%increase counter so next response is placed on the next line
stimCounter = stimCounter + 1; 

end