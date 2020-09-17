This project displays several flower-like images on the screen using Psychtoolbox/OpenGL, to be run in
Matlab. The participant is required to press 1-6 on the keypad (depending on their preference) to move 
onto the next question/trial. The properties of the flowers are updated based on the participant's response 
(what they select first becomes more likely, what they select second becomes less likely) and over the 
course of the experiment should narrow down on the features that they prefer. At the end of the experiment, 
the script saves a results file containing several logs that accurately describe the events of the 
experiment.

The main function is runFlowersExp.m which will generate stimuli and run the experiment.

All settings and parameters are located in the following files and will have to be adjusted to suit,  
where XX is the userID, the experimenter's initials or even the experiment name:
   * load_parameters_stim_XX.m     - Loads all properties related to drawing of the stimuli, including
                                     those with multiple parameter settings used as the independent 
                                      variables in the experiment.
   * load_parameters_exp_XX.m      - Loads all properties relating to the experiment procedure and 
                                     running of the experiment.
   * load_parameters_roulette_XX.m - Loads the variable names that will be used as independent 
                                     variables and manipulated over the course of the experiment.
   * load_screen_properties.m      - Loads all parameters relating to the screen properties of the 


A results file is created under ./results/ with an event log (recording key events and their
timing over the experiment), response log (details of the stimulus selected when the participant
makes a button press) and pieLog (details of the likelihood of each parameter setting being 
presented on the next trial), among other key variables (e.g., screen details).

Analysis is performed for individual participants using AnalysePie.m
Analysis for group results must be first collated using results2mat_all.m and then can be run 
using AnalyseAll.m

Created by Matt Patten
Created in May, 2019.