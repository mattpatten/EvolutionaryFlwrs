function [allparams] = add_stimulus_headers(st)

% Takes the stimulus parameters struct and converts all of the variable names
% into header names for the response log. 
% 
% Input:
%    st - A struct containing all stimulus parameters.
%
% Output:
%    allparams - A 1xN cell containing strings of all the variable names used
%                in the experiment.
%
%Created by Matt Patten
%Created on 30/5/2019


global stimLog;

allparams = {}; %initialize
subFields = {'st.h','st.d','st.t','st.r'};

%Non-variable set headers
stimLog{1,1} = 'Trial Number';
stimLog{1,2} = 'Piecase';
stimLog{1,3} = 'Piecase Trial Number';
stimLog{1,4} = 'Flower Number';

count = 5; %set index counter as next integer for the start of stimulus parameters


%% Get all the generated fields from the stimulus structs and save them as strings

for s=1:length(subFields) %for each sub-field (holes, disk, trans, ray)
    
    %get names of all the fields in this struct
    params = fieldnames(eval(subFields{s})); 
    
    for p=1:length(params) %for each field
        stimLog{1,count} = [subFields{s} '.' params{p}]; %save it as a string into the header
        count = count+1; %increment to next column
    end
    
    %save all fields for the saving of response data at a later time    
    allparams = [allparams; strcat(subFields{s},'.',params)];
end

end