function [chosen_val] = spin_roulette(param_vals, pie)

% Perform parameter selection based on a selection of likelihoods.
% 
% In layman's terms, spin a roulette wheel where it could land on one of several possible parameter
% settings, with the possibility of it landing on each parameter related to the size of the piece 
% of pie (or proportion of the wheel) that parameter is given.
%
% Inputs:
%     param_vals - A parameter with multiple settings to choose from / that make up the roulette wheel. This
%                  should be a column vector or matrix where each row makes up a single parameter setting.
%     pie        - The amount of space dedicated to each of the parameter settings. This should be a row or 
%                  column vector.
%
% Output:
%     chosen_val - The parameter that is randomly chosen given the options and roulette distribution.
%
% Created by Matt Patten
% Created in June 2019


%check input
if isscalar(param_vals), error('Parameter has only a single value and is not being varied.'); end
if abs(sum(pie) - 1) > 0.01, error('Pie doesnt sum to 1'); end

%generate an index from the possible parameters given the proportion of it being in different parts of the pie
idx = datasample(1:size(param_vals,1), 1, 'Weights', pie); 

%get value associated with this index
chosen_val = param_vals(idx,:);

end



