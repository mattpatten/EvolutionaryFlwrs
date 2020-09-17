function newResponse(trialNum, question, piecase, piecase_trialNum, response, trial_start, st, all_stim_properties)

% Every time the user presses a response button, store information about the 
% event (reaction time, trial number, etc) and then extract and save all of 
% the stimulus parameters for the image that they selected.
%  
% Inputs:
%    trialNum            - Which trial number is currently taking place.
%    question            - Positive integer describing whether this is the first, second or later 
%                          flower that was selected. e.g., first selected was 'prettiest', second
%                          selected was 'ugliest'.
%    piecase             - which staircase the experiment is extracting likelihood details from
%    piecase_trialNum    - The trial number specific to this staircase (and not the overall experiment).
%    response            - the button the participant has pressed to indicate their selection
%    trial_start         - the timestamp at the moment when the stimulus is displayed on screen.
%    st                  - A struct containing all of the stimulus parameters for the selected flower.
%    all_stim_properties - A cell array containing all of the stimulus parameter names (as strings).
%
% Output:
%    Writes a line to the global variable 'responseLog' storing information about the participant's
%    response and corresponding stimulus details, and increments 'responseCounter' so the next time 
%    this function is called it writes to the next line.
%
%Created by Matt Patten
%Created on 30/5/2019


global responseLog;
global responseCounter;

%save event information
responseLog{responseCounter,1} = trialNum;              %trial
responseLog{responseCounter,2} = question;              %pretty/ugly
responseLog{responseCounter,3} = piecase;               %which staircase
responseLog{responseCounter,4} = piecase_trialNum;      %trial number for this staircase
responseLog{responseCounter,5} = response;              %what the user pressed
responseLog{responseCounter,6} = GetSecs - trial_start; %reaction time

paramCount = 7; %define index column for saving 

%go through all fields of our stimulus struct and save the details
for i=1:length(all_stim_properties)
    responseLog{responseCounter, paramCount} = eval(all_stim_properties{i}); %add the value of this field to the response log
    paramCount = paramCount+1; %move to next column
end

%increase counter so next response is placed on the next line
responseCounter = responseCounter + 1; 

end