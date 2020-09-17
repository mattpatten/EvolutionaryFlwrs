function [kc] = SetupKeyCodes_PC 

% This defines KeyCodes (see 'help KbCheck') based on the values on a 
% PC keyboard. Stores values under the struct 'kc' for quick reference later.
%
% Created by Matt Patten
% Created on April 2019.


% define Quit
kc.quit  = 81; %q
kc.esc   = 27; %escape
kc.space = 32; %space bar
kc.save  = 83; %s

% define responses
kc.one   = 97;  %1end
kc.two   = 98;  %2down
kc.three = 99;  %3PgDn
kc.four  = 100; %4left
kc.five  = 101; %5
kc.six   = 102; %6right 

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