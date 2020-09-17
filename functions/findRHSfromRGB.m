function findRHSfromRGB(rgbval)

%rgbval = [0.78431 0.22745 0.18431];

load('C:\MyFiles\Work\WSU\Neurofloristry\Holstein\img_properties\RHS_UPOV_Lab_colours.mat'); %load official RHS (royal horticultural society) colour labels in L*a*b* colour spectrum

[~, closest] = min(vecnorm(rgb2lab(rgbval) - lab_values,2,2));

disp('The closest RHS colour is:');
disp(RHS_labels{closest});

end