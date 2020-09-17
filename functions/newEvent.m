function newEvent(eventName,trialNum,param1,param2,param3)

% This adds lines or 'events' to what is essentially a time-log of 
% your experiment, keeping track of all the key events so we can 
% ensure everything is working efficiently and check timing etc.
% 
% Inputs:
%    eventName  - A string describing the event that we are recording.
%                 e.g., 'Stimulus On', 'Response'
%    [trialNum] - Which trial number is currently taking place.          (optional)
%    [param1]   - Other possible data we want to record with this event. (optional)
%    [param2]   - Other possible data we want to record with this event. (optional)
%    [param3]   - Other possible data we want to record with this event. (optional)
%
% Output:
%    Writes a line to the global variable 'eventLog' and increments 'eventCounter'
%    so the next time this function is called it writes to the next line.
%
%Created by Matt Patten
%Created on 30/5/2019


global eventCounter;
global eventLog;
global experiment_start_time;

%add details to event log
eventLog{eventCounter,1} = GetSecs - experiment_start_time; %current time
eventLog{eventCounter,2} = eventName;                       %event type
if nargin > 1, eventLog{eventCounter,3} = trialNum; end     %trial
if nargin > 2, eventLog{eventCounter,4} = param1;   end     %optional parameter - response key, type, etc.
if nargin > 3, eventLog{eventCounter,5} = param2;   end     %optional parameter - response key, type, etc.
if nargin > 4, eventLog{eventCounter,6} = param3;   end     %optional parameter - response key, type, etc.

%increase counter so next event is placed on the next line
eventCounter = eventCounter + 1; 

end