function [st] = get_trial_parameters(userID, paramStr, pie)

% Load up all stimulus parameters for this flower.
%
% This first loads the standard parameters specified by the user, then identifies
% which of these parameters we are going to have to spin the roulette for, and 
% uses the pie (weights) to determine the likelihood of each parameter setting 
% being chosen.
% So we spin the roulette wheel, select the parameter and set it for this flower, 
% and send it back to the main function to be drawn.
%
% Inputs:
%     userID   - The initials of the user running the experiment, used to load 
%                the right experiment files.
%     paramStr - A cell array containing the names of the parameters that we 
%                will spin the roulette wheel for.
%     pie      - A cell array containing the proportion of likelihood (or  
%                weights) that each of these variables will be displayed. 
%                e.g., {[0.1, 0.15, 0.25, 0.5],...}.
% 
% Outputs:
%     st       - A struct containing all non-variant stimulus properties for 
%                this flower to be drawn.
%
% Created by Matt Patten
% Created in May 2019

seg = {'h','d','t','r'};

%load all stimulus parameters as standard for this flower
st = eval(['load_parameters_stim_' userID]); 

%spin roulette and decide values for this stimulus
for p=1:length(paramStr)

    %spin roulette to choose value
    chosen_value = spin_roulette(eval(paramStr{p}), pie{p});

    %save stimulus value parameters with roulette-spun value
    eval(sprintf(['%s=[' repmat('%d ',1,length(chosen_value)) '];'], paramStr{p}, chosen_value)); 

end

%if fractals aren't being generated, set exponent to NaN (as there isn't one for this image)
for s=1:length(seg)
    if eval(['st.' seg{s} '.fractal_type==0']) %if fractal type is zero
        eval(['st.' seg{s} '.fractal_exponent = NaN;']); %set exponent to NaN
    end
end

end