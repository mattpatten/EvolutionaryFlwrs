function [resp_params] = store_response_parameters(st, roulette_str)

% This stores the values to the key (manipulated) parameters that the participant
% has selected on this question (prettiest/ugliest), so it can be used at the end 
% of the trial to update the pie / likelihood distributions.
%
% NB: The essential part of this function is actually just to convert the struct 
% from 'flwr{n}' to 'st' to match up with the load_parameters file so when we run
% eval it extracts the correct value from the parameter name.
%
% Inputs:
%    st           - A struct containing all stimulus parameters of the flower 
%                   chosen by the participant.
%    roulette_str - A string containing the names of the parameters being 
%                   manipulated in this experiment.
%
% Outputs:
%    resp_params  - Values to the manipulated parameters selected by the 
%                   participant for this trial.
% 
% Created by Matt Patten
% Created on 6th June 2019


%save current parameters for those that are being varied
for p=1:length(roulette_str)
    resp_params{p} = eval(roulette_str{p});
end

end