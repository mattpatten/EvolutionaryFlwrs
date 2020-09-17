function [response] = handleKeyPress(stimVisible)

% This checks if any buttons on the keyboard are being pressed. If the ESC/q keys have been 
% pressed, it will exit the script. It also checks for and returns any response keys that
% have been pressed (1-6 on the keypad only).
%
% Inputs:
%   stimVisible - The flower numbers of those still present on the screen, and therefore the
%                 only buttons pressed that we accept responses for.
%
% Output:
%   response    - An integer corresponding to any response button press that has taken place.
%
% Created by Matt Patten
% Created in April, 2019.


global kc;

%check which buttons on the keyboard are being pressed
[~, ~, keyCode] = KbCheck(-1); 

%check keyboard for any quit response keys
if keyCode(kc.quit)==1 || keyCode(kc.esc)==1 % quit events - Q key or ESC
    exitGracefully('User has aborted script with keyboard press'); %exit programme
end


%identify the 'keycode' number of key that was pressed
buttonDown = find(keyCode,1); %keycode is a logical array - find its index to identify which one it is
if isempty(buttonDown), buttonDown=0; end %if doesn't find anything, mark as no response

%if a response button was pressed and the stimulus is present: record response
if     buttonDown==kc.one   && ismember(1,stimVisible)
    response = 1;
elseif buttonDown==kc.two   && ismember(2,stimVisible)
    response = 2;
elseif buttonDown==kc.three && ismember(3,stimVisible)
    response = 3;
elseif buttonDown==kc.four  && ismember(4,stimVisible)
    response = 4;
elseif buttonDown==kc.five  && ismember(5,stimVisible)
    response = 5;
elseif buttonDown==kc.six   && ismember(6,stimVisible)
    response = 6;
elseif buttonDown==kc.save  %if instructed to save and exit - assign special value
    response = 99;
else
    %otherwise set as no response
    response = 0;
end

end