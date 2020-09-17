function load_screen_properties

% Defines all parameters for the screen properties of the current setup.
% This includes screen resolution, monitor size, operating system, and which screen to use.
% 
% No inputs.
% 
% Output:
%   scr - A struct containing parameters relating to the computer, monitor and room setup.
%
% Created by Matt Patten
% Created on 14/5/2019


global scr;

% Input details of the set up
scr.viewingDistance = 0.75; %0.57; %in metres

% Input details of the display monitor
scr.monitorSize_x = 0.533; %in metres
scr.monitorSize_y = 0.300; %in metres

% Define current screen to be used [0 - all, 1 - main, 2 - secondary]
scr.screenNum = max(Screen('Screens')); %sets as likely most convenient option

%Sets up the correct keycodes for appropriate o/s
scr.operatingSystem = 'PC'; %'PC' or 'Mac' (case insensitive)

end