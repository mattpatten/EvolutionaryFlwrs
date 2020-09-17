function [st] = load_parameters_stim_RL

% This is the file to edit in order to decide all stimulus parameters along with the ones that will be manipulated 
% in the experiment.
%
% Everything takes a single value (except for colour, which is in RGB triplets and tips_other_sharpnesses, which 
% can handle multiple options). If you want a specific parameter to vary in the experiment, you can enter it as 
% an array where each row is a single parameter setting:
%    e.g.1, st.t.sizeX  = [0.5; 0.7; 1; 1.3];      ---> 4 possible trans floret sizes 
%    e.g.2, st.r.colour = [1 0 0; 0 1 0; 0 0 0.5]; ---> red as option 1, green as option 2, dark blue as option 3
%        NB: That semi-colon after each entry is critical!!!
%
% ***Extra important note*** For manipulated parameters, you must also write the specific parameter in the 
% "load_parameters_roulette" file so we know it needs to be varied in the experiment.
%
% No inputs.
%
% Outputs:
%    st - A struct containing all stimulus properties, broken into 4 sub-structs (h,d,t,r for holes, disk, trans
%         and ray florets). e.g., st.d.sizeX is the size along the x axis for the disk florets.
%
%    
% Sizes are measured in visual degrees.
% h - holes , d - disk, t - trans, r - ray
%
% Created by Matt Patten
% Created in May, 2019


%% Depth and layers (best to leave this as is)
st.h.layer                  = 5;          %holes (on top of disk florets + outline)
st.d.layer                  = 3;          %disk florets
st.t.layer                  = 2;          %trans florets
st.r.layer                  = 1;          %ray florets (NB: larger is closer to the observer)

st.h.outline_layer          = 4;          %below holes so overlapping holes don't have boundary through them (imagine the inside of the Olympic rings)
st.d.outline_layer          = 3;          %black outline of disk florets
st.t.outline_layer          = 2;          %black outline of trans florets
st.r.outline_layer          = 1;          %black outline of ray florets


%% Region sizes
st.h.size                   = 0.07;                 %[0-Inf) radius of each hole
st.h.var                    = 0.30;                 %[0-Inf) random variance (%) added in hole size

st.h.size_x_offset          = 0;                    %(-Inf to Inf) the change in the radius along the x-axis, if we want the disk to be non-circular (can use both -/+)
st.h.var_x_offset           = 0;                    %[0-Inf) random variance (%) added in elliptical shape of holes relative to offset already included

st.d.size                   = [0.65; 0.65];           %radius of central disk
st.d.size_x_offset          = [0];             %(-Inf to Inf) the change in the radius along the x-axis, if we want the disk to be non-circular (can use both -/+)
                                                    %NB: My code isn't perfect: holes within the elliptical shape are restricted to be within the smallest radius and not extend all the way out to the larger radius. 
                                                    %(You can see this deficiency by making this parameter really large and adding lots of holes.)

st.t.sizeX                  = [0.40; 0.4; 0.4];      %[0-Inf) the length (radius) of the ellipse for trans florets
st.t.sizeY                  = [0.35; 0.35];     %[0-Inf) the height (radius) of the ellipse for trans florets
st.t.varX                   = [0.05];               %[0-Inf) random variance (%) added in individual trans lengths
st.t.varY                   = [0.05];               %[0-Inf) random variance (%) added in individual trans widths


st.r.sizeX                  = [0.97; 0.97; 0.97];        %[0-Inf) the length (radius) of the ellipse for ray florets
st.r.sizeY                  = [0.35; 0.35];      %[0-Inf) the height (radius) of the ellipse for ray florets
st.r.varX                   = [0.05];                 %[0-Inf) random variance (%) added in individual petal lengths
st.r.varY                   = [0.05];                 %[0-Inf) random variance (%) added in individual trans widths
st.r.init_displacement      = st.d.size-0.3;        %[0-Inf) how far away from the centre the ellipse starts

%% Shape - elliptical skew
st.t.skew                   = 1;          %[0,2) where <1 left skew (towards centre), 1 is no skew, >1 right skew (towards outside edge).
st.r.skew                   = 1;


%% Angular tips
st.t.tip_length             = 0.30;        %(0-Inf) the length (in visual degrees) of the tip, extending out radially. This is measured from the connection point outwards (not the end of the ellipse)
st.t.tips_sharpness         = [2.5; 2.5; 2.5]; %(0-Inf) the sharpness of the tips/edges of the ray florets, of the order x.^n (i.e., 1 is linear/45 deg point, 2 is parabolic, 100 is absolutely flat)
st.t.tips_likelihood_change = 0;          %[0-1] the likelihood that each petal's tip will change from the original setting.
st.t.tips_other_sharpnesses = [0]; %(0-Inf) if the sharpness changes for a petal, the other sharpnesses it may be instead
                            
st.r.tip_length             = 0.5;        %(0-Inf) the length (in visual degrees) of the tip, extending out radially. This is measured from the connection point outwards (not the end of the ellipse)
st.r.tips_sharpness         = [3; 3; 3.0];  %(0-Inf) the sharpness of the tips/edges of the ray florets, of the order x.^n (i.e., 1 is linear/45 deg point, 2 is parabolic, 100 is absolutely flat)
st.r.tips_likelihood_change = 0;          %[0-1] the likelihood that each petal's tip will change from the original setting.
st.r.tips_other_sharpnesses = [0]; %(0-Inf) if the sharpness changes for a petal, the other sharpnesses it may be instead

st.t.connect_point          = 0.8;        %[0-1] the height of a normalized ellipse where the change occurs (1 is the tallest part, 0 is at the end),
st.r.connect_point          = 0.8;        %from where the ellipse stops and the angular edge/tip starts. 


%% Position / Quantity
st.t.orientation_shift      = 137.5;      %[0-360) the change in orientation with the generation of every new trans floret
st.t.orientation_shift_var  = [180; 180; 180];          %[0-180] the amount of variance (in degrees, ori_shift ± var) in placing the position/orientation of the next trans floret
st.r.orientation_shift      = 137.5;      %[0-360) the change in orientation with the generation of every new ray floret
st.r.orientation_shift_var  = [180; 180; 180]; %[0-180] the amount of variance (in degrees, ori_shift ± var) in placing the position/orientation of the next ray floret
                                          %check for repeats using: sort(mod(cumsum(repmat(st.r.orientation_shift,1,st.r.nPetals)),360))
                                          %check spread using: diff(sort(mod(cumsum(repmat(st.r.orientation_shift,1,st.r.nPetals)),360)))

st.t.avgPetals              = [5; 5; 5];         %[1-inf) number of trans florets to generate
st.t.avgPetals_var          = 3;          %[0-inf) the amount of variance (nPetals ± var) in the number of trans florets that might be displayed.
st.r.avgPetals              = [35; 35; 35]; %[1-inf) number of ray florets to generate 
st.r.avgPetals_var          = 3;          %[0-inf) the amount of variance (nPetals ± var) in the number of ray florets that might be displayed.


%% Holes - Unique Properties
st.h.nRows                  = 3;          %[1-inf)  how many rows of holes (distances from the centre) we want in the disk florets
st.h.avgHoles               = [20; 20; 20];   %[1-inf)  number of holes to put inside disk florets, distributed proportionally across the rows (closer to the centre has less compared to close to the outside)
st.h.avgHoles_var           = 2;          %[0-inf)  the amount of variance (nHoles ± var) in the number of holes that might be displayed.
st.h.row_jitter             = 1;          %[0,1]    whether all rows are spread out from the same initial orientation (0), or each row is given a unique initial orientation (1). All orientations are still spread evenly here - just the starting position changes.
st.h.row_std                = 0.50;        %[0-1]    variation in the distance from the centre within each row; normal curve peaking at each row distance.   0=all the same distance; 1=varies between rows on either side of it
st.h.ori_std                = 0.50;        %[0-1]    variation in the orientation of each hole within each row; normal curve peaking at its intended spread. 0=all equally apart around the circle for this row; 1=varies between neighbouring spots on same row
st.h.outline_increment      = 0.02;       %[0-0.05] because of the layering, increase the size of the outline of the holes so the fill colour doesn't draw over them. This only does anything if h.outline_layer < h.layer.


%% Shape outlines (black)
st.h.draw_outline           = 0;          %[0,1] draw black outline around edge of shape (1) or not (0)
st.d.draw_outline           = 1; 
st.t.draw_outline           = 1; 
st.r.draw_outline           = 1; 

st.h.line_width             = 1.5;        %(0-inf) thickness of the line surrounding the shape
st.d.line_width             = 2.5; 
st.t.line_width             = 2.5;
st.r.line_width             = 2.5;


%% Textures

st.h.fractal_type           = [0]; 
st.d.fractal_type           = [0];
st.t.fractal_type           = [0];
st.r.fractal_type           = [2; 2];     %(where X is flower region 'h','d','t',or'r')fractal_type summarises the top two variables. 0 means no fractal is shown, 1 means the regular fractal is displayed, and 2 means the thresholded/binary/ugly fractal is presented. It only takes 3 values. 
 
st.h.texture_jitter         = 1;          %[0,1] randomization of position of the texture (1) or standard position in every object (0)
st.d.texture_jitter         = 1;          %highly recommended to leave this as 1
st.t.texture_jitter         = 1;
st.r.texture_jitter         = 1;

st.h.fractal_exponent       = 0;          %[0-2, but also up to ~5], exponent / slope value of fractals.
st.d.fractal_exponent       = 0;
st.t.fractal_exponent       = 0;
st.r.fractal_exponent       = [1.5];

st.h.texSize                = 32;         %[2^n for n=1,2,3...] The size (in pixels) of fractal textures to be generated. Due to openGL requirements, textures must be an exponent 
st.d.texSize                = 128;        %of 2 (2^n = 2,4,8,16,....), where the larger the size the more variation the texture will have - but the larger the matrix / variable 
st.t.texSize                = 128;        %size will be. So I recommend leaving these as they are - if you find too much repetition in the fractal, increase n by 1 (e.g., 128 --> 256)
st.r.texSize                = 128;


%% Segment shade/colour
st.h.colour                 = [0.17647     0.18431     0.18824]; %RGB triplets [0-1]. e.g., [0 1 1] (Red, green, blue)
st.d.colour                 = [0.47059     0.70196     0.31765]; %Some predefined RGB triplets can be seen by typing "rgb chart" and used via rgb('name')
st.t.colour                 = [0.78431 0.22745 0.18431; 0.78431 0.22745 0.18431; 0.78431 0.22745 0.18431; 0.78431 0.22745 0.18431; 0.78431 0.22745 0.18431; 0.78431 0.22745 0.18431];
st.r.colour                 = [0.37647 0.27843 0.21176; 0.37647 0.27843 0.21176; 0.37647 0.27843 0.21176; 0.37647 0.27843 0.21176; 0.37647 0.27843 0.21176; 0.37647 0.27843 0.21176]; 

%red                        [0.78431 0.22745 0.18431]
%pink                       [0.8902 0.54902 0.63922]
%green                      [0.35686 0.69412 0.39216]
%yellow-green               [0.6902 0.64314 0.14118]
%yellow                     [0.97255 0.83137 0.24314]
%brown                      [0.37647 0.27843 0.21176]

%disk
%green                      [0.47059     0.70196     0.31765] 

%hole 
%grey/black                 [0.17647     0.18431     0.18824]

%% Shape quality
st.h.nsteps                 = 30;         %[5-inf) the number of vertex points used to generate each polygon/shape. Higher numbers will look better (to a point, after which 
st.d.nsteps                 = 100;        %it's a waste of resources), but take considerably longer to generate. 100-200 is reasonable.
st.t.nsteps                 = 100;
st.r.nsteps                 = 200;

end