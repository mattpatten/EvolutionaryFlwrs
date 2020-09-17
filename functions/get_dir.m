function [varargout] = get_dir(varargin)

% This function is a way to put the entire directory structure in one file, such that directories need not be 
% mentioned in code anywhere else. It takes a variable number of inputs and outputs (both separated by commas) 
% so you specify whichever directories you want, and its corresponding output variable name.
%
% Inputs:
%    <varargin>  - A string, or set of strings containing any directories you want to retrieve.
%                  Strings should be the text preceding 'Dir' in variable names below.
%                  Currently: 'root', 'results', 'texture', 'screenshot','figures'
%
% Outputs:
%    <varargout> - The variable names of any directories you are retrieving.
%
% e.g.1,
%   my_directory = get_dir('root'); %returns the root directory as my_directory
%
% e.g.2, 
%   [imgDir, maskDir] = get_dir('img','mask'); %retrieves both image and mask directories 
%
% Created by Matt Patten in Nov, 2018


%define folders
rootDir       = [fileparts(mfilename('fullpath')) filesep '..' filesep];    %base directory for experiment
textureDir    = [rootDir 'textures'       filesep];                         %directory where different sets of stimulus images are stored
screenshotDir = [rootDir 'screenshots'    filesep];                         %directory to save screenshots
progressDir   = [rootDir 'progress_files' filesep];                         %directory where results are saved
resultsDir    = [rootDir 'results'        filesep];                         %directory where results are saved
figuresDir    = [rootDir 'results'        filesep 'figures' filesep];       %directory to save figures of the results
collatedDir   = [rootDir 'results'        filesep 'collated' filesep];      %directory to save collated data, combining across a single experiment

%return the directory/directories that were asked for inputs should be strings, with whatever is before Dir in the above 
%variable names (e.g., 'stim' for stimDir)
for i=1:nargin
    varargout{i} = eval([varargin{i} 'Dir']);
end

end