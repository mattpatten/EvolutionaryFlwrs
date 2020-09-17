function drawFlower(flwr)

% The main brunt of the openGL code, where the flower stimulus is drawn to the 
% screen's backbuffer: circle by circle, petal by petal, using the parameters 
% specified by 'flwr' until it is drawn entirely and ready to be displayed.
% 
% Inputs:
%    flwr - A struct containing all stimulus parameters to be drawn.
% 
% Outputs:
%    No specific output - the flower is drawn off-screen to the monitor's backbuffer, 
%    waiting for the "Screen('Flip')" command in order to be displayed and physically 
%    visible.
%
% Created by Matt Patten
% Created in May 2019


global GL;

%% Draw central disk
if flwr.d.fractal_type, texID = prepareGLtexture(flwr.d.texImgMatrix); end
drawEllipse(flwr.d, 1);
if flwr.d.fractal_type, glBindTexture(GL.TEXTURE_2D, 0); glDeleteTextures(1, texID); end %unbind ('release') texture from future commands and delete stored texture


%% Draw holes
for hh=1:flwr.h.nHoles
    
    %prep
    glPushMatrix; % # saves model view matrix (i.e., the camera position) in its current state
    if flwr.h.fractal_type, texID = prepareGLtexture(flwr.h.texImgMatrix); end %prep texture
    
    %shift into position
    [shift_x, shift_y] = pol2cart(flwr.h.orientpos(hh), flwr.h.dpos(hh)); %convert to polar coordinates
    glTranslated(shift_x, shift_y, 0); % Translate our position from current 'pointer'.
    
    %draw
    drawEllipse(flwr.h, hh);
    
    %clean up
    if flwr.h.fractal_type, glBindTexture(GL.TEXTURE_2D, 0); glDeleteTextures(1, texID); end %unbind ('release') texture from future commands and delete stored texture
    glPopMatrix; % # reset transformations/rotations to last time push matrix was called
end


%% Draw trans florets
for ptl=1:flwr.t.nPetals
    
    %prep
    glPushMatrix; % # saves model view matrix (i.e., the camera position) in its current state
    if flwr.t.fractal_type, texID = prepareGLtexture(flwr.t.texImgMatrix); end
    
    %shift into position
    glRotated(flwr.t.pos(ptl), 0, 0, 1); %rotate our frame of reference
    
    %draw
    drawEllipse_w_tips(flwr.t, ptl);
    
    %clean up
    if flwr.t.fractal_type, glBindTexture(GL.TEXTURE_2D, 0); glDeleteTextures(1, texID); end %unbind ('release') texture from future commands and delete stored texture
    glPopMatrix; % # reset transformations/rotations to last time push matrix was called
end


%% Draw ray florets
for ptl=1:flwr.r.nPetals
    
    %prep
    if flwr.r.fractal_type, texID = prepareGLtexture(flwr.r.texImgMatrix); end
    glPushMatrix; % # saves model view matrix (i.e., the camera position) in its current state
    
    %shift into position
    [shift_x,shift_y] = pol2cart(deg2rad(flwr.r.pos(ptl)), flwr.r.init_displacement); %compute cartesian coordinates for initial displacement shift
    glTranslated(shift_x, shift_y, 0); % Translate our position from current 'pointer'.
    glRotated(flwr.r.pos(ptl), 0, 0, 1); %rotate our frame of reference
    
    %draw
    drawEllipse_w_tips(flwr.r, ptl);
    
    %clean up
    if flwr.r.fractal_type, glBindTexture(GL.TEXTURE_2D, 0); glDeleteTextures(1, texID); end %unbind ('release') texture from future commands and delete stored texture
    glPopMatrix; % # reset transformations/rotations to last time push matrix was called
end

end