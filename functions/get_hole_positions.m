function [rpos, thetapos] = get_hole_positions(h, nHoles, diskSize)

% This generates equidistant positions of the holes across the disk florets based on number of rows and total holes to display. 
% It also adds:
%  * row jitter - Like spinning a wheel of each row of holes so they don't all line up exactly in front of the other rows.
%  * ori std    - Normalized standard deviation [0 - none, 1 - max required) of the orientation position / theta value of each hole. They start 
%                 equally spread from each other and this randomizes their position using a normal distribution with mean of its original position.
%  * row std    - Normalized standard deviation [0 - none, 1 - max required) of the distance / r value of each hole - it randomizes the 
%                 row/distance/r position using a normal distribution with mean at its original row.
% 
% Inputs: 
%    The stimulus struct containing parameters for the holes. Specifically, the following parameters are essential:
%     h.size              - radius of hole.
%     h.var               - amount of variance in the size of the radius, changing overall 
%     h.size_x_offset     - difference between x and y radii for hole (i.e., converts it to ellipse - negative value 
%                           makes 'tall' ellipse, positive value makes 'fat' ellipse).
%     h.outline_increment - the difference in the radius for the outline of the hole relative to the fill.
%     h.nRows             - number of rows to separate the holes into.
%     h.row_jitter        - whether each row should start at a random orientation or whether all rows should start 
%                           at a single orientation.
%     h.row_std           - normalized s.d. of whether all holes should be placed at the same row location or be allowed
%                           to vary according to a normal distribution between the two rows surrounding it.
%     h.ori_std           - normalized s.d. of whether all holes should be distributed equally across orientation space
%                           or be allowed to vary somewhere between its neighbours orientations.
%
%     nHoles              - The number of holes to be displayed within the disk floret.
%     diskSize            - The size of the disk floret to know the space limitations of where the holes can be placed.
%
% Outputs:
%     (Polar co-ordinates)
%     rpos                - A vector containing the r (distance) value from the centre to the middle of each hole. 
%     thetapos            - A vector containing the theta (orientation) value from the centre to the middle of each hole. 
%
% Created by Matt Patten
% Created on 8th May, 2019.


%initialize
rpos = [];
thetapos = [];

%generate one new start orientation for *this stimulus*
if ~h.row_jitter, init_theta_jit = randb(1,0,360); end 

%given all of the necessary size information, set the minimum and maximum possible distances we can use
rmin = h.size * (1+h.var) + max([0 h.size_x_offset] + h.outline_increment); %minimum allowed value: size (diameter) of the largest possible hole we can generate
rmax = diskSize - rmin;                                                 %maximum allowed value: closest to the border without going over (taking into account the size of the holes)

%compute number of holes to put in each row (proportionally)
holeRowDist = linspace(0, diskSize, h.nRows+2);             %space out rows from centre to edge of disk floret (including boundaries)
holeRowDist = holeRowDist(2:(end-1));                       %remove boundary values
holesPerRow = round(holeRowDist/sum(holeRowDist) * nHoles); %proportion holes to each row (further away from centre gets more holes)

for hh=1:h.nRows %for each row of holes
    
    %% Holes: r / distance
    %mean +/- 2 x standard deviations account for 95% of the normal curve. i.e., stay within these bounds otherwise things will just stick along the edge.
    %thus this equation at its maximum is half the distance between the rows (thus the normalized std = 1 will 95% of the time vary between the neighbouring rows)
    this_rpos = repmat(holeRowDist(hh),1,holesPerRow(hh)); %set vector full of distance position (r) for this row
    this_rpos = this_rpos + h.row_std/(2*(h.nRows+1)) * randn(1,holesPerRow(hh)); %add standard deviations to distance/r
    
    %set boundary conditions
    this_rpos(this_rpos>rmax) = rmax; %set bound - restrict to inside disk florets
    this_rpos(this_rpos<-rmax) = -rmax; %set a ridiculous minimum bound to keep inside disk florets if std has been whacked way up - shouldn't otherwise be necessary
    
    %add to row positions
    rpos = [rpos this_rpos]; 
    
    
    %% Holes: Orientation
    if h.row_jitter, init_theta_jit = randb(1,0,360); end %set initial orientation for this row to distribute from 

    %spread out evenly from 0-360, add a random start position, and then ensure (via modulus) all orientations are between 0-360.
    this_theta = mod((1:holesPerRow(hh)).*360/holesPerRow(hh)+init_theta_jit,360); 
    
    if length(this_theta)>1 %how many holes are there in this row?
        %find angular distance between holes (to know how much we should vary orientation for this row)
        separation = mode(diff(this_theta))/2;
    else
        %if only one (or less) hole in this row, allow it to span the whole circle
        separation = 180;
    end
    
    %add normalized version of standard deviation to orientation - no bounds necessary
    this_theta = this_theta + h.ori_std * separation * randn(1,holesPerRow(hh)); 
    
    %add to orientation positions
    thetapos = [thetapos deg2rad(this_theta)]; 
end
end