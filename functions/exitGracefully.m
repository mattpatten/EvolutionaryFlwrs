function exitGracefully(errMsg)

% This function is a quick wrapper to close down all essential experiment/display functions easily when
% trying to exit out of the programme pre-emptively. It shows the cursor, closes any open windows, removes
% all stored variables and displays a defined error message (so you can be sure exactly why/where the 
% program ended).
%
% Inputs:
%    errMsg - A string that can be used to explain the place and reason why the programme was terminated.
%
% Created by Matt Patten
% Created in April, 2019.


Screen('CloseAll');       %close open psychtoolbox textures
ShowCursor;               %present the mouse pointer again
ListenChar(0);            %return listening in the command window
clearvars -except errMsg; %clears almost all variables from the workspace
error(errMsg);            %exit program displaying an error message

end