function [R] = randb(N,lower,upper)

% Generates uniformly distributed random numbers between two bounds.
%
% A very simple function that generates a set of random numbers restricted 
% to be within the set [lower, upper]. N should be a scalar or vector of
% non-negative integers describing the size of the matrix of random numbers 
% to be generated. Please note that you should define the seed via 'rng' 
% prior to calling any 'rand' or related functions.
%
% Inputs:
%   N     - The size of matrix to be randomly generated. A scalar N 
%           returns an N-by-N matrix values. A vector [M N P ...] returns 
%           an M-by-N-by-P-by-... array.
%   lower - The lower bound, or minimum value that can be generated.
%   upper - The upper bound, or maximum value that can be generated
%           (accepts all numbers > lower).
%
% Outputs:
%    R     - A size(N)-matrix of pseudorandom values where for all values: 
%            lower <= R <= upper.
%
%
% Created by Matthew L. Patten in April 2019.
% (Though admittedly using a primitive equation that everybody knows, 
% already uses and is described in the 'rand' help.)


% Input and data checking
if nargin < 3,                               error('Requires 3 input arguments: [N, lower, upper.]');         end 
if ~isrow(N),                                error('Size vector should be a row vector with real elements.'); end 
if any([~isscalar(lower) ~isscalar(upper)]), error('Lower and upper bounds should be scalars.');              end
if upper<lower,                              error('Upper bound must be equal or larger than lower bound.');  end


% Change random number interval to be within specified bounds
R = (upper - lower) * rand(N) + lower;


end