function drawEllipse_w_tips(s, ptl)

% This uses openGL to draw an ellipse based on a series of coordinates / vertex locations, with the outermost 
% edge containing a pre-specified sharpness based on the function y = x.^n. The ellipse is going to the right 
% with its left 'vertex' at the origin.
% 
% ====================
%       Inputs
% ====================
%
% This function requires the following fields under the struct 's':
%
%  Outline:
%    draw_outline       - Boolean, if an outline for the object should be drawn
%    line_width         - Width of outline line.
%
%  Fill colour: 
%    colour             - RGB triplet of ellipse colour (if not using texture).
%    fractal_type       - 0 for no fractal, positive integer [1-2] if we are filling ellipse 
%                         with a fractal textural image.
%    texSize            - The length, in pixels, of the textural image.
%
%  Tip/Angularity:
%    tip_length         - The length (in visual degrees) of the tip, extending out radially.
%    connect_point      - The normalized [0-1] location where the shape stops and the angular edge/tip starts. 
%
%  Other: 
%    layer              - Depth position of fill
%    skew               - [0,2) where <1 left skew (towards centre), 1 is no skew, >1 right skew (towards outside edge).
%    nsteps             - Number of vertices to use to draw the polygon.
%
%
% In addition, the following fields are arrays, containing multiple values which are unique for each petal and have 
% undergone some degree of randomization (e.g., length of petals; texture position)...
%
%    length             - Radius of ellipse along horizontal axis (technically not a radius)
%    height             - Radius of ellipse along vertical axis (technically not a radius)
%    jitter_x/y         - The initial position of the texture inside the mask. i.e., should it always 
%                         start in the top left corner of the image or choose a random location?
%    ind_tips_sharpness - The sharpness of the tips/edges of the ray florets, of the order x.^n (i.e., 1 is linear/45 
%                         deg point, 2 is parabolic, 100 is absolutely flat).
%
%
% ptl - A positive integer, indicating which ellipse/petal is being drawn.
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

%run equation to get coordinates of petal endpoint (i.e., whether it be sharp, round or flat)
[x_ang,y_ang] = generateAngularity(s.ind_tips_sharpness(ptl), s.height(ptl) * s.connect_point, s.tip_length, s.nsteps/2);

%cartesian equation of the positive half of an ellipse with y as subject and one vertex at origin [centre (0,s.length(ptl))]
x_ell = linspace(0, 2 * s.length(ptl), s.nsteps/2);                                 %generate x-values (basic increment)
y_ell = sqrt((s.height(ptl).^2) * (1 - ((x_ell - s.length(ptl)).^2)/(s.length(ptl).^2))); %equation for an ellipse
x_ell = x_ell .* linspace(s.skew, 1, s.nsteps/2);                                %apply skew, if desired

%find location to shift from ellipse to petal edge
tip_edge = find(and(y_ell < max(y_ang), x_ell > s.length(ptl))); %restrict to after tipping point, in second half of ellipse only
x_ell(tip_edge) = []; %remove these values
y_ell(tip_edge) = [];

%combine ellipse with angular tip
%x = [x_ell x_ell(end) + x_ang*(s.length(ptl)*2 - x_ell(end))]; %adds and resizes tip length to the area between the connection point and the original ellipse size
x = [x_ell x_ell(end) + x_ang]; %adds tip length as defined by the 'tip_length' size, irrespective of connection point or original ellipse size
y = [y_ell y_ang];

%reverse, and add lower half
x = [x x((end-1):-1:1)];
y = [y -y((end-1):-1:1)];

%normalize for texture and convert to pixels (stops distortion and stretching of image)
xnorm = s.jitter_x(ptl) + ((x-min(x))./range(x) * deg2pix(s.length(ptl)*2) / s.texSize);
ynorm = s.jitter_y(ptl) + ((y-min(y))./range(y) * deg2pix(s.height(ptl)*2) / s.texSize);

%draw black outline around shape
if s.draw_outline
    glColor3dv([0 0 0]);
    glLineWidth(s.line_width);
    glBegin(GL.LINE_LOOP);
    for i=1:length(x)
        glVertex3d(x(i),y(i),s.layer);
    end
    glEnd();
end

%set colour if uniform, or set as white for texture (otherwise image will be blended with background colour)
if s.fractal_type
    glColor3dv([1 1 1]);
else
    glColor3dv(s.colour);
end

%draw vertex and texture coordinates
glBegin(GL.POLYGON);
for i=1:length(x)
    if s.fractal_type
        glTexCoord3f(ynorm(i), xnorm(i), s.layer); %just goes the other way. Dunno?
    end
    glVertex3d(x(i),y(i),s.layer);
end
glEnd();

end