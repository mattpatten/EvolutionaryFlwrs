function takeScreenshot(w, picRect)

% If you pass in the psychtoolbox window pointer (w) and the screen coordinates (picRect)
% that you want to take a screenshot of, in the order [Top Left Bottom Right], this will
% save that picture as an image under the folder '/screenshots' from the base experiment 
% directory as a .jpg, and given a unique filename (using a timestamp).
% 
% Created by Matt Patten
% Created on 9th May, 2019.


%define save directory and ensure it exists
[screenshotDir] = get_dir('screenshot');
if ~exist(screenshotDir), mkdir(screenshotDir); end %if the directory doesn't exist, create it

%take screenshot
screenshotMatrix = Screen('GetImage', w, picRect);

%save screenshot
imwrite(screenshotMatrix, [screenshotDir 'screenshot_' datestr(now,'yyyymmdd_HHMMSS') '.tiff'])
imwrite(screenshotMatrix, [screenshotDir 'screenshot_' datestr(now,'yyyymmdd_HHMMSS') '.png'])
%imwrite(screenshotMatrix, [screenshotDir 'screenshot_' datestr(now,'yyyymmdd_HHMMSS') '.jpg'])

%exit programme, if this is all that we wanted to do.
%exitGracefully('Screenshot taken.');

end
