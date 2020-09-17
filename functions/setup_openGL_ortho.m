function setup_openGL_ortho(numLayers)

% Sets up an orthographic projection in OpenGL for 2-D lighting: colours are consistent without shadows 
% or a light source. Depth is generated here using layers, i.e., larger numbers are closer depths and 
% occlude depths at lower values, but otherwise all objects maintain the same size, regardless of depth 
% value. Alpha blending (for object transparency and mixing of colours at different layers) is also 
% turned on here, if required.
% 
% Created by Matt Patten
% Created in April 2019


global GL;
global scr;

%% Orthographic Screen Settings
glViewport(0, 0, scr.res_x, scr.res_y); %determines the portion of the window used for OpenGL drawing
glMatrixMode(GL.PROJECTION);            %tells OpenGL to use next commands to set the projection matrix.
glLoadIdentity;                         %loads identity matrix (i.e., initialize variable)
%normalization of coordinates. NB: reversing height order starts (0,0) at top-left corner. Also, z-plane is negative/opposite so depth layers 1-10 need [-10 -1]
glOrtho(-scr.xsize_deg/2, scr.xsize_deg/2, scr.ysize_deg/2, -scr.ysize_deg/2, -numLayers-1, 1); 
glEnable(GL.DEPTH_TEST);                %enable proper occlusion handling / layers via depth tests

%% Enable alpha blending (i.e., smooth transitions of objects and colours; transparency)
glEnable(GL.BLEND); 
glBlendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
