function [flwr] = get_fractal_textures(flwr)
    
% Generate a fractal for each of the different flower segments (if required).
% Not only does this create the fractal mathematically, it then applies a colour 
% shading, and reshapes it into the correct format for openGL, adding it to the 
% same struct that was input.
%
% Input: 
%    flwr - A struct containing the stimulus parameters of the flower to be drawn.
%
% Output: 
%    flwr - The same struct with one additional field per segment - .texImgMatrix, a 
%           matrix containing the image texture of the fractal that is generated.
%
% Created by Matt Patten
% Created on 6th June 2019


%generate fractal for any of the required segments
if flwr.h.fractal_type, flwr.h = get_fractal_for_segment(flwr.h); end
if flwr.d.fractal_type, flwr.d = get_fractal_for_segment(flwr.d); end
if flwr.t.fractal_type, flwr.t = get_fractal_for_segment(flwr.t); end
if flwr.r.fractal_type, flwr.r = get_fractal_for_segment(flwr.r); end

end


function [seg] = get_fractal_for_segment(seg)

%identify whether fractal should be thesholded
thresholded = seg.fractal_type==2;

%generate fractal image matrix
fractal = make_fractal(seg.fractal_exponent, seg.texSize, thresholded, 0, 0, 'testMLP'); 

%add colour to fractal and put in dimensions required for openGL
if ~thresholded
    seg.texImgMatrix = apply_shading(fractal, seg.colour); %apply colour shading to fractal
else
    idx = fractal==255; %get indexes of all white values
    for cc=1:length(seg.colour) %
        seg.texImgMatrix(:,:,cc) = uint8(idx*seg.colour(cc)*255); %replace with red component
    end
end

seg.texImgMatrix = shiftdim(seg.texImgMatrix,2);

end