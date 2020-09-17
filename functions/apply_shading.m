function [shaded_img] = apply_shading(img, colour)

% This function takes a grayscale image and applies a colour shading to it. This will 
% take a grayscale image (white to black) and return a shaded version (colour to black)
% of the same size. 
% 
% Inputs:
%    img      - A 2D image matrix (MxNx1) in the set of [0,255].
%    colour   - An RGB triplet that you want to shade on the image.
%
% Output:
%    shaded_img - the image matrix with colour fused onto it.
%
% e.g., 
%   coins = rgb2gray(imread('coins.jpg'));
%   red_coins = applyShading(coins,[1 0 0]);
%   image(red_coins);
%
%
% Created by Matthew L. Patten.
% Created on 24/5/2019
 

%% Input and data checking
if nargin < 2,                           error('Requires a minimum of 2 input arguments: img and colour');     end %input checking
if size(img,3)~=1,                       error('Image matrix should be 2-D (grayscale)');                      end %size checking
if ~any([isequal(size(colour),[1 3]) isequal(size(colour),[1 4])]), error('Colour should be RGB(A) triplet.'); end %size checking
if any(any(img<0)) || any(any(img>255)), error('RGB values for image matrix should be between 0 and 255.');    end %range checking
if any(colour<0)   || any(colour>255),   error('RGB values for shading colour should be between 0 and 255.');  end %range checking


%convert to HSV
hsv_img    = rgb2hsv(repmat(img,1,1,3)); %rgb2hsv: image transforms use [0,255]
hsv_colour = rgb2hsv(colour/255);        %rgb2hsv: colormaps use [0,1]


%grayscale image contains only 'values' in HSV colourspace (i.e., no hue or saturation): extract these
values = hsv_img(:,:,3); 


%concatenate value with hue and saturation, convert it back to RGB and to an 8-bit integer
shaded_img = uint8(255 .* hsv2rgb(cat(3,repmat(hsv_colour(1),size(img,1),size(img,2)), ...
                                        repmat(hsv_colour(2),size(img,1),size(img,2)), ...
                                        values)));

end