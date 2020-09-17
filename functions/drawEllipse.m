function drawEllipse(s, ellipseNum)

% This uses openGL to draw an ellipse based on a series of coordinates / vertex locations.
% The ellipse is going to the right with its left 'vertex' at the origin.
% 
% ====================
%       Inputs
% ====================
%
% This function requires the following fields under the struct 's':
% 
%  Outline:
%    draw_outline      - boolean, if an outline for the object should be drawn
%    outline_layer     - depth position of outline 
%    outline_increment - if the outline should be smaller/larger than the fill
%    line_width        - width of outline
%
%  Fill colour: 
%    colour            - RGBA quadruplet (if not using texture).
%    fractal_type      - 0 for no fractal, positive integer [1-2] if we are filling ellipse 
%                        with a fractal textural image.
%    texSize           - The length, in pixels, of the textural image.
%
%  Other:
%    layer             - depth position of the ellipse.
%    nsteps            - number of vertices to use to draw the polygon.
%
%
% In addition, the following fields are arrays, containing multiple values which are unique for 
% each ellipse and have undergone some degree of randomization (e.g., hole size; texture position):
%
%    sizeX             - radius of ellipse along horizontal axis (technically not a radius)
%    sizeY             - radius of ellipse along vertical axis (technically not a radius)
%    jitter_x/y        - The initial position of the texture inside the mask. i.e., should it always 
%                        start in the top left corner of the image or choose a random location?
%
%
% ellipseNum - the increment of which ellipse is being drawn.
%
% ====================
%       Outputs
% ====================
% No variable output - an ellipse with specified properties is drawn using openGL commands to the 
% backbuffer of the screen.
%
% Created by Matt Patten
% Created in April 2019


global GL; 

%set default value (since not used for disk florets)
if ~isfield(s,'outline_increment'), s.outline_increment = 0; end  

%get vector positions to draw ellipse
[x,y,xtex,ytex] = get_coordinates(s, ellipseNum, 0);

%% Draw outline
if s.draw_outline %if we've selected to draw an outline

    if s.layer > s.outline_layer %if drawing holes where interior is in front of outline
        %add increment to outline so it is not drawn over by the fill
        [out_x, out_y] = get_coordinates(s, ellipseNum, s.outline_increment); 
    else 
        %otherwise, keep them the same
        out_x = x;
        out_y = y;
    end
    
    glColor3dv([0 0 0]);       %set colour
    glLineWidth(s.line_width); %set line width
    glBegin(GL.LINE_LOOP);     %draw a single line that connects first and last listed points
    for i=1:length(out_x)      %use our coordinates to draw line
        glVertex3d(out_x(i), out_y(i), s.outline_layer);
    end
    glEnd();                   %finish openGL drawing using co-ordinates
end

%set colour if uniform, or set as white for texture (otherwise image is blended (badly) with background colour)
if s.fractal_type
    glColor3dv([1 1 1]);
else
    glColor3dv(s.colour);
end

%draw polygon from the following texture and vertex coordinates
glBegin(GL.POLYGON);
for i=1:length(x)
    if s.fractal_type
        glTexCoord3f(ytex(i), xtex(i), s.layer); %just goes the other way. Dunno?
    end
    glVertex3d(x(i), y(i), s.layer);
end
glEnd();

end


function [x,y,xtex,ytex] = get_coordinates(s, ellipseNum, outline_increment)

% These calculations need to be done twice: once for the outline and once for the ellipse itself.
% The reason for this is due to the increment of the outline - it has to be slightly larger than
% the interior as it's at a different depth layer to the fill. This stops them overlapping into
% each other (think Olympic Rings).


%specify dimensions for this specific ellipse
rad_length = s.sizeX(ellipseNum) + outline_increment;
rad_height = s.sizeY(ellipseNum) + outline_increment;

%cartesian equation of the positive half of an ellipse with y as subject and one vertex at origin [centre (0,rad_length)]
x = linspace(0, 2*rad_length, s.nsteps); 
y = sqrt((rad_height.^2) * (1 - ((x - rad_length).^2)/(rad_length.^2))); 

%shift so centre is at origin
x = x - rad_length;

%duplicate for lower half
x = [x  fliplr(x(1:(end-1)))];
y = [y -fliplr(y(1:(end-1)))];

%normalize for texture and convert to pixels (stops distortion and stretching of image)
xtex = s.jitter_x(ellipseNum) + ((x-min(x))./range(x) * deg2pix(rad_length*2) / s.texSize);
ytex = s.jitter_y(ellipseNum) + ((y-min(y))./range(y) * deg2pix(rad_height*2) / s.texSize);

end