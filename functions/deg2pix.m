function [size_pix] = deg2pix(size_deg)

% Converts visual degrees input to number of pixels output. This relies on visual 
% distance information, monitor size and pixel resolution. If these are not accurate, 
% this function is useless.
%
% Inputs:
%     size_deg - positive scalar; a size in visual degrees.
%     (global) scr - a struct containing:
%           .viewingDistance - distance from the user's eyes to the screen, in metres.
%           .pixelsPerMetre  - given the physical monitor size and screen resolution, 
%                              how many pixels we would find in a metre.
%
% Output:
%     size_pix - positive scalar; the size in pixels.
% 
%Created by Matt Patten
%Created on 2nd May 2019


global scr;

%if not already generated, we can do it here - the code will work, but it's ever so 
%slightly unnecessary slower, so inform user to increase run speed.
if ~isfield(scr,'pixelsPerMetre') 
    [scr.pixelsPerMetre] = ComputePixelsPerMetre; 
    disp('Pixels per metre not defined in main function.');
end

%Converts from visual degrees to physical dimension (metres)
size_m = 2 * scr.viewingDistance * tan(deg2rad(size_deg)/2);

%Converts from physical dimensions (metres) to number of pixels, given our set up
size_pix = round(size_m * scr.pixelsPerMetre);

end