function [paramStr, paramVals, pie] = load_parameters_roulette_MP(userID)

% Here you need to define the stimulus parameters of your experiment that you 
% want to have varied across trials. It then loosely checks these inputs are 
% appropriate, and creates a pie of likelihood distributions for each setting 
% based on the number of values it can take.
%
% NB: The variables are all created in the "load_parameters" file and should have 
% one variable per row. Further instructions can be found at the top of said file.
%
% Inputs: 
%   userID    - Experimenter ID to load correct parameter file.
%
% Outputs:
%   paramStr  - A cell array containing a string of the parameter names that will be
%               manipulated.
%   paramVals - A cell array containing the parameter values for each of the parameters
%               named in paramStr.
%   pie       - Likelihood distributions for parameters based on the number of values it 
%               could have. e.g., petals that could be either a red, green or blue colour 
%               will be initiated with a pie with values [0.33 0.33 0.33].
%
%
% Created by Matt Patten
% Created on 31/5/2019


paramStr{1} = 'st.r.avgPetals'; 
paramStr{2} = 'st.t.avgPetals';
paramStr{3} = 'st.h.avgHoles';
paramStr{4} = 'st.h.fractal_type';
paramStr{5} = 'st.d.fractal_type';
paramStr{6} = 'st.t.fractal_type';
paramStr{7} = 'st.r.fractal_type';
paramStr{8} = 'st.h.fractal_exponent';
paramStr{9} = 'st.d.fractal_exponent';
paramStr{10}= 'st.t.fractal_exponent';
paramStr{11}= 'st.r.fractal_exponent';
paramStr{12}= 'st.r.varX';
paramStr{13}= 'st.t.varX';
paramStr{14}= 'st.r.varY';
paramStr{15}= 'st.t.varY';
paramStr{16}= 'st.r.orientation_shift_var';
paramStr{17}= 'st.t.orientation_shift_var';
paramStr{18}= 'st.r.tips_likelihood_change';
paramStr{19}= 'st.t.tips_likelihood_change';
paramStr{20}= 'st.d.size ';
%....

%load all stimulus parameters (to get parameter values and check inputs)
st = eval(['load_parameters_stim_' userID]); 

for i=1:length(paramStr) %for each set parameter

    %get and save values
    paramVals{i} = eval(paramStr{i});
    
    %check entries have multiple options to choose from
    if length(paramVals{i}) < 2 %if only one parameter setting (or worse - empty), can't generate roulette wheel
        error('Roulette wheels must have more than one parameter setting.');
    end
    
    %assign equal proportions to each possible alternative for the parameters
    pie{i} = repmat(1/length(eval(paramStr{i})),1,length(eval(paramStr{i})));
end

end