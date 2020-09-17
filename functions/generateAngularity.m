function [x,y] = generateAngularity(n, height, tip_length, nsteps)

% This generates rounded or sharp edges of a petal, based on the power (n) you give it 
% (i.e., y = x.^n). For reference, n=1 is a sharp 90 deg angle, n=2 is a parabolic function.
%
% Inputs: 
%    n          - positive scalar; power of function (x^n) in region [0,1] defining the level 
%                 of sharpness. n<1 is concave, n=1 is linear, n>2 is parabolic.
%    height     - magnitude of function along y-axis.
%    tip_length - magnitude of function along x-axis.
%    nsteps     - number of vertices to use in generating the angle.
% 
% Outputs:
%    Two vectors, together containing a series of (x,y) coordinates to define the specified angularity.
%
% Created by Matt Patten
% Created in April 2019


%if inputs not provided, use these values
if nargin<4, nsteps = 100;   end 
if nargin<3, tip_length = 1; end
if nargin<2, height = 1;     end
if nargin<1, n = 2;          end

%step size
xsteps = linspace(0, 1, nsteps);

%generate power function
y_fit = (xsteps .^ n);

%swap axes to invert/reflect to horizontal function (e.g., parabola facing to the right instead of up)
[y, x] = deal(xsteps,y_fit);

%reverse (e.g., parabola facing left instead of to the right)
x = 1 - x;

%sort array back into increasing order 
x = fliplr(x);
y = fliplr(y);

%rescale
x = x * tip_length;
y = y * height;

end