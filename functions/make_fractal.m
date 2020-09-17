function [imgMatrix] = make_fractal(expo, imsize, thresholdedImgFlag, dispImg, saveImg, filename)

% Generates fractal textures with a given exponent of the amplitude spectrum & RMS contrast
%
% CC - 9.2.02
%
% CC - 15.4.02 commented 04.06.07
%
% CC - modified from make_fractal 14.03.13 to give arbitrary RMS contrast
%
% LV - 15.05.13 modified to provide threshold image (at mean) of every image produced
%   edge variants of threshold images included (canny)
%   mountain variants included
%
% MLP - 10/5/2019 - Adjusted inputs and file structure for genetic algorithm flower experiment
%
% Inputs:
%     expo               - [0-2, but also up to ~5], exponent / slope value of fractals.
%     imsize             - length in pixels of the side of the image
%     thresholdedImgFlag - boolean [0,1], whether we want original fractal (0) or the threholded/binarized b&w version (1)
%     dispImg            - boolean [0,1], whether to display output in a figure window.
%     saveImg            - boolean [0,1], whether to save a png of the image.
%     filename           - string containing desired filename for output
%
% Output:
%     imgMatrix          - Fractal or thresholded fractal image matrix.
%


contrast = 0.3; % contrast is RMS contrast and it can't go higer than this; otherwise there are blackened out pixels in the image;

xsize = imsize;
ysize = imsize;

% get save dir
textureDir = get_dir('texture');
if ~exist(textureDir), mkdir(textureDir); end %if the directory doesn't exist, create it


%a = zeros(xsize,ysize);
b = zeros(xsize,ysize);
c = zeros(xsize,ysize);
e = zeros(xsize,ysize);

a = random('Normal',0,1,xsize,ysize); % generate image of Gaussian white noise
dc = mean(mean(a)); % set the mean level to zero ...
b = fft2(a-dc);     % ... and Fourier transform to get the frequency spectrum

b = fftshift(b);    % rearrange the frequency spectrum so that zero is at the centre

x0 = (xsize+1)/2;
y0 = (ysize+1)/2;

for x = 1:xsize     % create an amplitude spectrum with the desired "fractal" drop-off with frequency
    for y = 1:ysize
        d = sqrt((x-x0)^2+(y-y0)^2);
        c(x,y) = d.^(-expo);
    end
end

b = b.*c;   % multiply the frequency spectrum of your noise by the fractal amplitude spectrum to get fractal noise

b = ifftshift(b); % rearrange the frequency spectrum so that zero is in the corner

e = ifft2(b); % inverse Fourier transform your spectrum to get a fractal noise image

% normalize image ...
f = real(e);
maxf = max(max(f));
minf = min(min(f));
ampf = max(maxf,-minf);
f = f./ampf;
ff = reshape(f,1,imsize*imsize);
f = f./std(ff); % mean is 0, std is 1

f = min(255,max(127.5.*(1 + f.*contrast),0)); % clip to 0-255 with chosen contrast

g = uint8(f); % convert to unsigned 8-bit integer and write as bitmap ...


if thresholdedImgFlag %if interested in the thresholded image

    % check the actual rms contrast of the 8-bit image ...
    ff = reshape(double(g),1,imsize*imsize);
    %delivered_contrast = std(ff)/mean(ff);
    %disp(['Delivered Contrast: ' delivered_contrast]);
    
    %% produce threshold image of fractal
    %thres_mean = mean(double(g(:)))/max(double(g(:))) %find the mean luminance
    thres_mean = .5; %threshold at 127.5
    thres_g = uint8(imbinarize(g,thres_mean))*255;
    if dispImg, figure; imshow(thres_g); end
    if saveImg, imwrite(thres_g, [textureDir filename '_thres_' num2str(expo) '.png'], 'png'); end
    
    imgMatrix = thres_g; %return final image matrix

else %if interested in the original fractal
    
    if dispImg, figure; imshow(g); end %display image in figure window
    if saveImg, imwrite(g, [textureDir filename '_' num2str(expo) '.png'], 'png'); end %save image to file
    imgMatrix = g; %return final image matrix
end

end