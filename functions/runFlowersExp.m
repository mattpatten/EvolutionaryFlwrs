function runFlowersExp(userID, subjID, acq)

% This displays several flower-like images on the screen using Psychtoolbox/OpenGL. The participant is 
% required to press 1-6 on the keypad (depending on their preference) to move onto the next question/trial.
% The properties of the flowers are updated based on the participant's response (what they select first 
% becomes more likely, what they select second becomes less likely) and over the course of the experiment
% should narrow down on the features that they prefer. At the end of the experiment, the script saves a 
% results file containing several logs that accurately describe the events of the experiment.
% 
% While the function itself requres several inputs, ALL parameter settings for the experiment need to be
% defined in the following separate scripts (where XX is the userID a.k.a. the experimenter's initials):
%    * load_parameters_stim_XX.m     - Loads all properties related to drawing of the stimuli, including
%                                      those with multiple parameter settings used as the independent 
%                                      variables in the experiment.
%    * load_parameters_exp_XX.m      - Loads all properties relating to the experiment procedure and 
%                                      running of the experiment.
%    * load_parameters_roulette_XX.m - Loads the variable names that will be used as independent 
%                                      variables and manipulated over the course of the experiment.
%    * load_screen_properties.m      - Loads all parameters relating to the screen properties of the 
%                                      current setup.
%
% Inputs:
%     userID - A string of the experimenter's initials, used to load experimenter-specific parameters
%              (above) and save unique filenames.
%     subjID - A string descriptor (participant initials or unique number/identifier) to describe the 
%              participant whose data is being collected.
%     acq    - Acquisition number, to describe the session number of this participant being collected.
%              i.e., if you run the same subject 3 times, you can keep userID and subjID the same and 
%              increment the acq number each time they take part.
%
% Output:
%     A results file is created under /../results/ with an event log (recording key events and their
%     timing over the experiment), response log (details of the stimulus selected when the participant
%     makes a button press) and pieLog (details of the likelihood of each parameter setting being 
%     presented on the next trial), among other key variables (e.g., screen details).
%
% Created by Matt Patten
% Created in May, 2019.

%define global variables
global kc;
global scr;
global pieLog;
global pieCounter;
global eventLog;
global eventCounter;
global responseLog;
global responseCounter;
global stimLog;
global stimCounter;
global experiment_start_time;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    Input and data checking    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%set up defaults (if inputs aren't provided)
%if nargin < 1, userID = 'MP';   end 
%if nargin < 2, subjID = 'test'; end 
%if nargin < 3, acq = 1;         end 

%throw error if files don't exist, or acquisition is either non-positive or not an integer
if ~exist(['load_parameters_stim_'     userID '.m'],'file'), error(['File "load_parameters_stim_'     userID '.m" does not exist.']); end
if ~exist(['load_parameters_exp_'      userID '.m'],'file'), error(['File "load_parameters_exp_'      userID '.m" does not exist.']); end
if ~exist(['load_parameters_roulette_' userID '.m'],'file'), error(['File "load_parameters_roulette_' userID '.m" does not exist.']); end
if or(acq < 1, floor(acq)~=acq), error('Acquisition number must be positive integer.'); end 


%%%%%%%%%%%%%%%%%%%%
%%    File I/O    %%
%%%%%%%%%%%%%%%%%%%%

recycle('on'); %set any deleted commands to go to recycle bin and not permanent deletion
[progressDir, resultsDir] = get_dir('progress','results'); %define results path relative to current file location
if ~exist(resultsDir,'dir'), mkdir(resultsDir); end %if the directory doesn't exist, create it
if ~exist(progressDir,'dir'), mkdir(progressDir); end
resultsFile = [resultsDir filesep 'GenFlwr_results_' userID '_' subjID '_' num2str(acq) '.mat']; %define the results filename NB: for unique... datestr(now,'yyyymmdd_HHMMSS')
progressFile = [progressDir 'GenFlwr_progress_' userID '_' subjID '_' num2str(acq) '.mat'];

%if results file already exists, ask if we want to overwrite
if exist(resultsFile,'file')
    tryAgain = true; %keep looping until we give permission to continue (by pressing 'y')
    while tryAgain
        overwriteResp = input('Results already exist for this user, subject and acquisition. Continue and overwrite results? (y/n)','s'); %get user input from keyboard
        if strcmpi(overwriteResp,'y') %if they type y, then escape loop and overwrite file
            tryAgain = false; %break loop
        elseif strcmpi(overwriteResp,'n') %if they type n, then abort program
            error('Aborted by user to avoid overwriting results file');
        end
    end         
end 

%check if user wants to continue on from their previous session
continue_session = false;
if exist(progressFile,'file')
    tryAgain = true; %keep looping until we give permission to continue (by pressing 'y')
    while tryAgain
        overwriteResp = input('Progress file exists - continue from previous session? (y/n)','s'); %get user input from keyboard
        if strcmpi(overwriteResp,'y') %if they type y, then escape loop and overwrite file
            continue_session = true;
            tryAgain = false; %break loop
        elseif strcmpi(overwriteResp,'n') %if they type n, then abort program
            tryAgain = false; %break loop
        end
    end         
end 


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    Load parameters    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

if continue_session
    load(progressFile); continue_session = true;
    delete(progressFile);
else
    load_screen_properties; %load all parameters related to the screen/setup
    e = eval(['load_parameters_exp_' userID]); %load all parameters relating to the experimental procedure
    [roulette_str, roulette_vals, pies{1}] = feval(['load_parameters_roulette_' userID], userID); %load key parameters and the probability of landing on each one of them
    for i=2:e.numPiecases
        pies{i} = pies{1}; %replicate for however many pies being tested
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    Get screen details, open screen    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%should ideally never be used - but our stimulus is static and refresh timing isn't so important for us
Screen('Preference', 'SkipSyncTests', e.skipSyncTests); 

%Setup Psychtoolbox for OpenGL 3D rendering support - call before any 'Screen' functions
InitializeMatlabOpenGL(1);

%Get screen details
scr.rect  = Screen('rect',scr.screenNum); %get screen dimensions (in pixels).
scr.res_x = scr.rect(3);                  %save screen width  (in pixels)
scr.res_y = scr.rect(4);                  %save screen height (in pixels)

%Define visual degrees available on the screen
scr.xsize_deg = rad2deg(2*atan(scr.monitorSize_x / (2 * scr.viewingDistance)));
scr.ysize_deg = rad2deg(2*atan(scr.monitorSize_y / (2 * scr.viewingDistance)));

%use screen properties to determine the physical size of each pixel
scr.pixelsPerMetre = ComputePixelsPerMetre;

%Set up screen
w = Screen('OpenWindow', scr.screenNum, e.backgroundColour*255); %open psychtoolbox window for drawing
Screen('ColorRange', w, 1); %change colour range from 0-255 to 0-1

%set the window's priority to maximum to stop other processes messing with our timing
Priority(MaxPriority(w));

%retrieve monitor refresh duration (for reference only, not used)
scr.Hz = Screen('GetFlipInterval', w); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       Initialize Matlab / Psychtoolbox       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialise some variables
GetSecs; %this takes longer on first call then on subsequent calls, so call here to get it initialized here
KbCheck; %run to load into memory
HideCursor; %hides cursor during stimulus presentation
%ListenChar(2); %suppress output to command window

if ~continue_session
    tr = 1; %first trial
    randomSeed = rng('shuffle'); %set (and save) random seed so new random numbers are generated each run
    kc = eval(['SetupKeyCodes_' upper(scr.operatingSystem)]); %get keycodes (i.e., numbers corresponding to keypresses) for a PC/Mac

    pieLog          = {}; %start log with empty cell array
    eventLog        = {}; %start log with empty cell array
    responseLog     = {}; %start log with empty cell array
    stimLog         = {}; %start log with empty cell array
    pieCounter      = 1;  %start log with empty cell array
    eventCounter    = 1;  %start writing to the event log on the first line
    responseCounter = 2;  %leave a line for the header
    stimCounter     = 2;  %leave a line for the header
    white = [255 255 255];

    %save initial pie distributions before any trials begin
    addToPieLog(0, 0, 0, roulette_str, roulette_vals, pies{1});

    %find the maximum number of values for any of our parameters (for user debugging only)
    maxParams = max(cellfun('length', pies{1})); 

    %set total number of trials in the experiment
    e.numTrials = e.numTrialsPerPiecase * e.numPiecases;

    %set up piecases
    piecase = Shuffle(repmat(1:e.numPiecases,1,e.numTrialsPerPiecase));
end
    
    
%%%%%%%%%%%%%%%%%%%%%%
%%   Intro Screen   %%
%%%%%%%%%%%%%%%%%%%%%%

if continue_session, intro_text = 'continue'; 
else, intro_text = 'begin'; end
    
%draw intro text
Screen('TextSize', w, 36);
Screen('TextFont', w, 'Arial');
Screen('DrawText', w, ['Press space to ' intro_text ' experiment.'], scr.res_x*36/100, scr.res_y/2-10, white);
Screen('Flip', w); %display on screen

%endless loop until space bar is pressed
startExp = false;
while ~startExp
    [~, ~, keyCode] = KbCheck(-1); 
    if find(keyCode) == kc.space
        startExp = true;
    end
end

%set up font for remainder of experiment
Screen('TextSize',  w, 24);
Screen('TextStyle', w, 1); %bold


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           Initialize OpenGL           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Version checking
AssertOpenGL; %break if we are not running on a Psychtoolbox version that supports OpenGL
AssertGLSL;   %make sure this GPU supports shading

Screen('BeginOpenGL', w); %setup OpenGL rendering for our onscreen window via a wrapper. After this command, OpenGL commands will draw into the onscreen window.

%Set buffer defaults (for when glClear is called)
glClearColor(e.backgroundColour(1),e.backgroundColour(2),e.backgroundColour(3),1); %set default colour in buffer (and also, therefore, background colour)
glClearDepth(1); %normalized to [0 1] aka [near far] - set default value in buffer to be furthest away

%setup orthographic projection lighting, depth and alpha blending
setup_openGL_ortho(e.numLayers);


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Experiment start   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%

experiment_start_time = GetSecs; %get current time and set as experiment starting point
newEvent('Experiment Start'); %add to event log

while tr<=e.numTrials %Trial Loop
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%    Initialize variables    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %initalize / reset after every trial
    flower = cell(1,e.numStimuli);
    resp_params = cell(1,e.numQs); %reset storage of key parameter values for this trial
    piecase_trialNum = sum(piecase(tr)==piecase(1:tr)); %get trial number specific to this piecase
    
    %draw all stimuli to begin with
    stim2draw = 1:e.numStimuli; 

    %display trial number to user
    fprintf('Trial number %i (piecase %i, trial %i):\n', tr, piecase(tr), piecase_trialNum);
    
    for nn=stim2draw %for each stimulus

        %load up parameters and spin the roulettes
        flower{nn} = get_trial_parameters(userID, roulette_str, pies{piecase(tr)});

        %on the very first run, create header for the response and stim log
        if and(tr==1,nn==1) 
            allrespfields = add_response_headers(flower{nn}); 
            allstimfields = add_stimulus_headers(flower{nn}); 
        end 

        stim_params{nn} = store_response_parameters(flower{nn}, roulette_str); %save key parameters in the selected flower for this trial
        newStimulus(tr, piecase(tr), piecase_trialNum, nn, flower{nn}, allstimfields);
        
        %for variables/parameters that have randomness, add that for each individual element.
        %e.g.1 generate an array of lengths if petals are supposed to have slightly different sizes. 
        %e.g.2 generate the size of each hole if they're meant to vary in size
        %e.g.3 get a unique initial starting position inside a texture 
        flower{nn} = add_randomness_to_flowers(flower{nn});

        %generate fractal textures for each of the segments, if required
        flower{nn} = get_fractal_textures(flower{nn});
        
    end
   
    for qs=1:e.numQs %number of questions we ask the participant
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %%       Drawing       %%
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        % The OpenGL coordinate system is a right-handed system as follows:
        % Default origin is in the center of the display.
        % Positive x-Axis points horizontally to the right.
        % Positive y-Axis points vertically upwards.
        % Positive z-Axis points to the observer, perpendicular to the display
        
        %clear colour/depth buffers at the start of every frame (but not after, as will delete everything already generated)
        glClear; %Clear out the backbuffer - needs to be done every time you redraw the scene
        response = 0; %set initial value that button hasn't been pressed

        newEvent('Stim Draw',tr,qs,piecase(tr),piecase_trialNum); %add to event log
        
        for nn=stim2draw
            
            %% Move pointer to appropriate position on screen for this stimulus
            glPushMatrix; % saves model view matrix (i.e., the camera position) in its current state ---> the centre of the sreen
            colpos = mod(nn,e.numDisplayCols); %use modulus to determine column increment
            colpos(colpos==0)=e.numDisplayCols; %replace zeros with max value
            colpos = colpos * 2 - 1; %spread evenly
            
            translateDistX = (-scr.xsize_deg/2) + colpos * scr.xsize_deg / (e.numDisplayCols*2); %shift pointer to edge than add column position
            translateDistY = (-scr.ysize_deg/2) + scr.ysize_deg / (e.numDisplayRows*2) * ((e.numDisplayRows*2) - ceil(nn/e.numDisplayCols)*2 + 1); %NB: Counts from bottom of screen upwards to match numpad
            glTranslated(translateDistX, translateDistY, 0); % Translate our position from current 'pointer'.
            
            %% The real deal - drawing of all parts of the flowers to the backbuffer in openGL
            drawFlower(flower{nn});
            
            glPopMatrix; % reset transformations/rotations back to push matrix details ---> the centre of the screen
        end
        
       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%    Draw Stimuli / Get Response    %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        glFlush(); %ensures all previous commands are executed: not really needed with double buffering, but ehh...
        Screen('EndOpenGL', w); %need this command after 3D drawing is finished and before regular Screen commands are sent

        %Draw text in top left corner
        if e.displayText, Screen('DrawText', w, e.questionText{qs}, 0, 0, white); end

        KbReleaseWait(); %wait until all keyboard buttons are not being pressed before displaying stimulus        

        %record responses/events
        if qs==1, newEvent('Stim On',tr,qs);        end %add to event log
        if qs==2, newEvent('Flower Removed',tr,qs); end %add to event log
        
        %display stimuli to user
        Screen('Flip', w); %show stimulus on next vertical retrace (single refresh of the monitor)
        trial_start_time = GetSecs;
        
        %takes screenshot of image and saves in screenshot folder with the current timestamp
        if (e.saveScreenshot && qs==1), takeScreenshot(w,[0 0 scr.rect(3) scr.rect(4)]); end 
        
        %check for user response / keyboard press
        while ~response %endless loop (while waiting for keyboard quit response - q/s/esc/space)
            response = handleKeyPress(stim2draw);
            
            if response==99 %save and exit if requested by user
                if qs==1  %but only if on first part of trial
                    newEvent('Experiment saved',[],[]);
                    save(progressFile);
                    disp('Experiment progress has been saved.'); %exit programme
                    exitGracefully('User has requested to save and exit experiment.'); %exit programme
                else
                    response = 0;
                end
            end
        end
            
        %display user response 
        disp(['User pressed button ' num2str(response)]);
        
        %store response and stimulus details
        newEvent('Response', response);
        newResponse(tr, qs, piecase(tr), piecase_trialNum, response, trial_start_time, flower{response}, allrespfields);
        resp_params{qs} = store_response_parameters(flower{response}, roulette_str); %save key parameters in the selected flower for this trial
                
        %remove response from presented stimuli
        stim2draw = stim2draw(stim2draw~=response);
        
        %prepare OpenGl for drawing of next frame
        Screen('BeginOpenGL', w); 
        
    end %numQs

    
    %%%%%%%%%%%%%%%%%%%%%%%
    %%    Update pies    %%
    %%%%%%%%%%%%%%%%%%%%%%%
        
    %update proportions for pie depending on stimulus parameters
    pies{piecase(tr)} = update_pie(resp_params, roulette_vals, pies{piecase(tr)}, e.propPieChange);
    
    %generate log of pie distributions
    addToPieLog(tr, piecase(tr), piecase_trialNum, roulette_str, roulette_vals, pies{piecase(tr)});

    %display pie to user (debugging/testing purposes only)
    if e.debuggingMode
        for p=1:length(pies{piecase(tr)})
            fprintf('%.2f\t' ,pies{piecase(tr)}{p}); %display parameter values of various sizes, separated by tabs
            fprintf(repmat('\t\t',1,maxParams - length(pies{piecase(tr)}{p}))); %equalize the number of tabs across variables
            fprintf(' - %s',roulette_str{p}); %parameter string suffix-heading
            fprintf('\n'); %next line
        end
    end
    
    tr = tr+1; %update trial number
end %numTrials


%%%%%%%%%%%%%%%%%%%%%%%%
%%   End Experiment   %%
%%%%%%%%%%%%%%%%%%%%%%%%

newEvent('Experiment End'); %add to event log
Screen('EndOpenGL', w); %need this command after 3D drawing is finished and before regular Screen commands are sent
save(resultsFile,'eventLog','responseLog','stimLog','pieLog','roulette_str','roulette_vals','pies','userID','subjID','acq','randomSeed','scr','e'); %save these specific variables (and not all the openGL values)


%%%%%%%%%%%%%%%%%%%%%
%%   Exit Screen   %%
%%%%%%%%%%%%%%%%%%%%%

%draw intro text
Screen('TextSize', w, 36);
Screen('TextStyle', w, 0); %regular font
Screen('DrawText', w, 'Thank you for your time and participation.', scr.res_x*32/100, scr.res_y/2-35, white);
Screen('DrawText', w, 'Please call on the experimenter.', scr.res_x*36/100, scr.res_y/2+25, white);
Screen('Flip', w); %display on screen

%endless loop until space bar is pressed
endExp = false;
while ~endExp
    [~, ~, keyCode] = KbCheck(-1);
    if or(find(keyCode) == kc.space, find(keyCode) == kc.esc)
        endExp = true;
    end
end


%%%%%%%%%%%%%%%%%%%%
%%   Close Down   %%
%%%%%%%%%%%%%%%%%%%%

KbReleaseWait(); %wait until all keyboard buttons are not being pressed (to avoid being written into command window)
ListenChar(0); %return listening in the command window
Screen('CloseAll'); %close open psychtoolbox textures
ShowCursor; %present the mouse pointer again
analysePie(userID,subjID,acq); %display results

end