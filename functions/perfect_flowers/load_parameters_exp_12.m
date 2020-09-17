function [e] = load_parameters_exp_long

% Load all parameters related to the procedure / running of the experiment.
% 
% No inputs.
% 
% Output:
%    e - A struct containing all necessary experiment/procedure-based parameters.
%
% Created by Matt Patten
% Created in June 2019


%% trial procedure
%[1-6] how many times do we ask for an answer from the participant before moving on to the next trial (1st Q - prettiest, 2nd Q - ugliest)
e.numQs = 2; 
%how many rounds of stimuli to generate for each piecase before the experiment ends
e.numTrialsPerPiecase = 120; 
%the number of interleaved piecases (i.e., the number of experiments running simultaneously)
e.numPiecases = 3;
% Note: Total trials are these two parameters multiplied together --> numTrialsPerPiecase * numPiecases 

%% the algorithm
%[0-1] the percentage of the pie that changes ownership on each trial. e.g., 0.1 = 10% of the original pie space will be shifted. 
%If there are 4 parameter valsues (25% to each parameter), 0.1 would shift 2.5% of the pie on each trial.
e.propPieChange = 0.10; 

%% instructions
e.displayText = 1; %[0,1] Whether you want to display text to the participant on each trial
e.questionText = {'Select most appealing','Select least appealing'}; %[string] the question that you want the participant to respond to, written in the top left corner of the screen.

%% screen layout
e.numStimuli        = 6; %number of images to present per display
e.numDisplayRows    = 2; %number of images in each row
e.numDisplayCols    = 3; %number of images in each column

%[RGB] The colour of the background across all trials
e.backgroundColour = [0.5 0.5 0.5]; %0x3=black, 0.5x3=grey, 1x3=white

%% debugging / other
%[0,1] view additional input onscreen during the experiment regarding user responses and pie/roulette proportions after each trial
e.debuggingMode = 0; 

%[0,1] turn on to ensure timing of monitor refreshes is accurate. Should usually be off (0) but isn't critical for the static image in our experiment.
e.skipSyncTests = 1;

%[0,1] Whether we should save a copy of the screenshot for future reference: only recommended when generating images for presentations/reports.
e.saveScreenshot = 1; 

%the number of different depth levels to draw to - use the maximum number listed in the layers of the stimulus file (ideally - just leave as is)
e.numLayers = 6; 

end