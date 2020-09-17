function [flwr] = add_randomness_to_flowers(flwr)

% For variables/parameters that have some variation, generate random values for these and add to the
% original struct.
% e.g.1 generate an array of lengths if petals are supposed to have slightly different sizes.
% e.g.2 generate the size of each hole if they're meant to vary in size.
% e.g.3 get a unique initial starting position inside a texture.
%
% Input: 
%    flwr - A struct containing the stimulus parameters of the flower to be drawn.
%
% Output: 
%    flwr - The same struct with one additional fields for parameters that have some degree of randomness 
%           or variation in them. 
%
% Created by Matt Patten
% Created on 6th June 2019


%% DISK
%add randomness to disk size
flwr.d.sizeY = flwr.d.size;
flwr.d.sizeX = flwr.d.sizeY + flwr.d.size_x_offset;

%add jitter for disk textures
if flwr.d.texture_jitter
    flwr.d.jitter_x = rand(1);
    flwr.d.jitter_y = rand(1);
end

%% HOLES
%vary the number of holes for this presentation
flwr.h.nHoles = randi([flwr.h.avgHoles - flwr.h.avgHoles_var, flwr.h.avgHoles + flwr.h.avgHoles_var]);
flwr.h.nHoles(flwr.h.nHoles<0)=0; %ensure never goes below zero

%get polar coordinates for the centre of each hole position
[flwr.h.dpos, flwr.h.orientpos] = get_hole_positions(flwr.h, flwr.h.nHoles, min([flwr.d.sizeX flwr.d.sizeY]));

for hh=1:flwr.h.nHoles
    
    %add randomness to hole size
    flwr.h.sizeY(hh) = flwr.h.size * randb(1, 1 - flwr.h.var, 1 + flwr.h.var);
    flwr.h.sizeX(hh) = flwr.h.sizeY(hh) + flwr.h.size_x_offset * randb(1, 1 - flwr.h.var_x_offset, 1 + flwr.h.var_x_offset);
    
    %add jitter for hole textures
    if flwr.h.texture_jitter
        flwr.h.jitter_x(hh) = rand(1);
        flwr.h.jitter_y(hh) = rand(1);
    end
end

%% TRANS
%generate variables that are randomized for each trial relating to the trans petals (position, size, sharpness, texture jitter)
flwr.t = generate_petal_randomness(flwr.t);

%% RAY
%generate variables that are randomized for each trial relating to the ray petals (position, size, sharpness, texture jitter)
flwr.r = generate_petal_randomness(flwr.r);

end


function [seg] = generate_petal_randomness(seg)

% Generates random variables required in the trial loop for trans and ray floret segments.
% For example, the petal lengths and heights that may individually vary, or the initial
% position of the texture image. This comes up with a pre-defined position/length for each 
% of the petals and stores them to the same struct before anything is actually drawn.
%
% Input: 
%   seg - the stimulus struct containing all necessary parameters to draw this segment on 
%         an individual flower.
%
% Output: 
%   seg - the same struct with additional parameters generated that have some level of 
%          variation within the parameter when drawn multiple times on the same flower.
%
% Created by Matt Patten
% Created in June 2019


%randomize starting orientation position
starting_orientation = randb(1,0,360); 

%randomize number of petals to display
seg.nPetals = randi([seg.avgPetals - seg.avgPetals_var, seg.avgPetals + seg.avgPetals_var]); 
seg.nPetals(seg.nPetals<0)=0; %ensure never goes below zero

%for each petal
for ptl=1:seg.nPetals

    %add variance between petal orientations
    seg.pos(ptl) = starting_orientation + randb(1, seg.orientation_shift*ptl - seg.orientation_shift_var, seg.orientation_shift*ptl + seg.orientation_shift_var); 
    
    %add randomness to petal size
    seg.length(ptl) = seg.sizeX * randb(1, 1 - seg.varX, 1 + seg.varX);
    seg.height(ptl) = seg.sizeY * randb(1, 1 - seg.varY, 1 + seg.varY);
    
    %randomize angularity for petal edge
    if rand < seg.tips_likelihood_change %if random number is within the likelihood of change
        seg.ind_tips_sharpness(ptl) = seg.tips_other_sharpnesses(randi([1 length(seg.tips_other_sharpnesses)])); %randomly choose another provided sharpness
    else
        %keep it as it is
        seg.ind_tips_sharpness(ptl) = seg.tips_sharpness;
    end
    
    %add jitter if required
    if seg.texture_jitter
        seg.jitter_x(ptl) = rand(1);
        seg.jitter_y(ptl) = rand(1);
    end
end

end