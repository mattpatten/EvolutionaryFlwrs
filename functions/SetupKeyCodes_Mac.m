function [kc] = SetupKeyCodes_Mac

% This defines KeyCodes (see 'help KbCheck') based on the values on a 
% Mac keyboard. Stores values under the struct 'kc' for quick reference later.
%
% Created by Matt Patten
% Created on April 2019.


% define Quit
kc.quit  = 20; %q
kc.esc   = 41; %escape
kc.space = 44; %space bar
kc.save  = 22; %s

% define responses
kc.one   = 89;  %1end
kc.two   = 90;  %2down
kc.three = 91;  %3PgDn
kc.four  = 92; %4left
kc.five  = 93; %5
kc.six   = 94; %6right 

%{
% NB: You can test what key is what by running the following code
% and pressing keys randomly on the keyboard
% Hit Ctrl+C to break out of code when finished

last_key = 0;
while 1
[keyIsDown, ~, keyCode] = KbCheck(-1);
    if and(keyIsDown, last_key~=find(keyCode,1))
        disp(find(keyCode));
        last_key = find(keyCode);
    end
end
%}

end