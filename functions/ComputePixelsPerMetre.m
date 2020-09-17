function [pixelsPerMetre] = ComputePixelsPerMetre

% This finds the coefficient 'pixelsPerMetre' to shift between pixels and physical dimensions (metres).
% It is entirely dependent on the resolution as well as an accurate measure of the size of your screen.
%
% e.g., monitor size: 0.5184m x 0.324m (wide x tall), resolution: 1920 x 1200 (wide x tall)
% metres per pixel (wide) = 0.5184 / 1920 = 0.00027
% metres per pixel (tall) = 0.324 / 1200  = 0.00027
%
% Once you have this number, you can easily convert a number of pixels into a physical length or vice versa (using the inverse)
%
% Inputs: 
%    global variables 'scr.res_x/y' (positive integers) and 'scr.monitorSize_x/y' (positive scalars).
% 
% Output:
%    pixelsPerMetre - The coefficient for converting pixels to metres and/or back again.
%
% Created by Matt Patten 
% Created on 13/7/2017 
% Created iniitally for Kiley Seymour's Ojbect Transparency project


global scr;

hor_coeff = scr.res_x / scr.monitorSize_x; %calculate pixels per metre for horizontal readings
vert_coeff = scr.res_y / scr.monitorSize_y; %calculate pixels per metre for vertical readings

%since you set a resolution (e.g. 1920 x 1200) and the screen is a set size, it should be very similar for both horizontal and vertical measurements
%if it's significantly off between the two, you've probably done a bad measurement for one of these
if (abs(hor_coeff - vert_coeff) > 20)
    error('Readings differ greater than 15 pixels p/m for horizontal and vertical dimensions. Please consider re-measuring your display screen.');
end

pixelsPerMetre = mean([hor_coeff vert_coeff]); %finds average of horizontal and vertical calculations as reasonable estimate
    
end