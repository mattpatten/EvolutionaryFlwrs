function displayRGB(colour,scale)

%This function takes an RGB input and displays the colour as a figure on screen for easy identification
%It also gives the RGB colour as a decimal (0-1) used in a lot of my code
%Inputs:
%   colour - RGB triplet e.g., [255 148 211]
%   scale  - the upper bound of the colour range (e.g., if the colours are within the range 0-1, 0-100, 0-255)
%
%Output:
%   Text on the screen displaying RGB values and a figure that shows the requested colour
%
%Created by Matt Patten
%Created on 25/6/2019


sqSize = 100; %how big the figure image should be

%create RGB matrix of specified colour
rgbval = cat(3,repmat(colour(1)/scale,sqSize,sqSize),repmat(colour(2)/scale,sqSize,sqSize),repmat(colour(3)/scale,sqSize,sqSize));

%draw colour into figure window
figure;
image(rgbval);
axis off;

%write details on screen
disp(['RGB value (0-1): ' num2str(colour/scale)]);

end