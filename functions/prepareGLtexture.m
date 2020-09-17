function [texID] = prepareGLtexture(imgMatrix)

% This prepares a texture for drawing by binding it to the pointer, populating the pixels and giving it appropriate parameters.
%
% Input:
%    imgMatrix - 3 x Y x X matrix (i.e., an RGB image transformed by shiftdim(img,2)) )
%
% Output:
%    texID - A handle/ID given to the texture.
%
% Created by Matt Patten
% Created on 2nd May 2019


global GL; 

glEnable(GL.TEXTURE_2D);  %enable 2d texture mapping
texID = glGenTextures(1); %generate one texture
glBindTexture(GL.TEXTURE_2D,texID); %identify texture that we want to apply the following processes/code to

%populate pixel information and texture parameters
glTexImage2D(GL.TEXTURE_2D, 0, GL.RGB, size(imgMatrix,2), size(imgMatrix,3), 0, GL.RGB, GL.UNSIGNED_BYTE, imgMatrix); %size 3 x 256 x 256  range: 0-255

%filtering for off-sizes. See: https://open.gl/textures for some explanation on different settings
glGenerateMipmap(GL.TEXTURE_2D); %improves performance for filter below. Must be done after call to glTexImage2D
glTexParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR_MIPMAP_NEAREST); %use 'linear' sum of nearby elements for texture filter after finding the 'nearest' sized minimap
glTexParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);                %use weighted 'linear' sum of nearby elements when image has to be magnified
glTexParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S,     GL.MIRRORED_REPEAT);       %how the textured image responds outside the range [0,1]. See: https://open.gl/textures for explanation
glTexParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T,     GL.MIRRORED_REPEAT);       %same thing, but for t-dimension.

end