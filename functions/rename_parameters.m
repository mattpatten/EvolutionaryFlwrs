function [paramOut, valuesOut, text_angle] = rename_parameters(expID, paramIn, valuesIn)

% Gets the parameter names used in the experiment and converts them into something more readable for graphical output
%
% Helper function created by Matt Patten in Feb 2020.

%pre-allocate with existing variables
paramOut = paramIn;
valuesOut = valuesIn;
text_angle = zeros(length(paramIn),1); %set all parameters to be displayed as straight unless otherwise specified

for i=1:length(paramIn)

    %Josh parameters
    if strcmpi(expID,'JB') || strcmpi(expID,'JB2')
        switch (strip(paramIn{i}))
            case 'st.r.avgPetals',              paramOut{i} = 'Number of ray florets';
            case 'st.t.avgPetals',              paramOut{i} = 'Number of trans florets';
            case 'st.h.avgHoles',               paramOut{i} = 'Number of holes';
            case 'st.h.fractal_exponent',       paramOut{i} = 'Hole fractal exponent';
            case 'st.d.fractal_exponent',       paramOut{i} = 'Disk fractal exponent';
            case 'st.t.fractal_exponent',       paramOut{i} = 'Trans floret fractal exponent';
            case 'st.r.fractal_exponent',       paramOut{i} = 'Ray floret fractal exponent';
            case 'st.r.varX',                   paramOut{i} = 'Ray floret length variance';
            case 'st.t.varX',                   paramOut{i} = 'Trans floret length variance';
            case 'st.r.varY',                   paramOut{i} = 'Ray floret width variance';
            case 'st.t.varY',                   paramOut{i} = 'Trans floret width variance';
            case 'st.r.tips_likelihood_change', paramOut{i} = 'Freq of tip change in ray florets';
            case 'st.t.tips_likelihood_change', paramOut{i} = 'Freq of tip change in trans florets';
            case 'st.d.size',                   paramOut{i} = 'Disk size';
            case 'st.h.fractal_type'
                paramOut{i} = 'Presence of hole fractal';
                valuesOut{i} = {'Off','On'};
            case 'st.d.fractal_type'
                paramOut{i} = 'Presence of disk fractal';
                valuesOut{i} = {'Off','On'};
            case 'st.t.fractal_type'
                paramOut{i} = 'Presence of trans floret fractal';
                valuesOut{i} = {'Off','On'};
            case 'st.r.fractal_type'
                paramOut{i} = 'Presence of ray floret fractal';
                valuesOut{i} = {'Off','On'};
            case 'st.r.orientation_shift_var'
                paramOut{i} = 'Ray florets symmetry';
                valuesOut{i} = {'Symmetrical','Misaligned','Random'};
                text_angle(i) = 30;
            case 'st.t.orientation_shift_var'
                paramOut{i} = 'Trans florets symmetry';
                valuesOut{i} = {'Symmetrical','Misaligned','Random'};
                text_angle(i) = 30;
            otherwise
                error([paramOut{i} ' not identified in rename_parameters file.']);
        end
        
    %Raghba parameters
    elseif strcmpi(expID,'threat') || strcmpi(expID,'disgust')
        switch (strip(paramIn{i}))
        case 'st.r.sizeX',                  paramOut{i} = 'Ray floret length';
        case 'st.r.sizeY',                  paramOut{i} = 'Ray floret width';
        case 'st.t.sizeX',                  paramOut{i} = 'Trans floret length';
        case 'st.t.sizeY',                  paramOut{i} = 'Trans floret width';
        case 'st.r.avgPetals',              paramOut{i} = 'Number of ray florets';
        case 'st.t.avgPetals',              paramOut{i} = 'Number of trans florets';
        case 'st.d.size',                   paramOut{i} = 'Disk size';
        case 'st.h.avgHoles'
            paramOut{i} = 'Number of holes';
            valuesOut{i} = {'None','10','20'};
        case 'st.r.fractal_type'
            paramOut{i} = 'Binarized fractal on ray florets';
            valuesOut{i} = {'Off','On'};
        case 'st.r.tips_sharpness'
            paramOut{i} = 'Tip sharpness of ray florets';
            valuesOut{i} = {'Sharp','Steep curve','Curve'};
            text_angle(i) = 40;
        case 'st.t.tips_sharpness'
            paramOut{i} = 'Tip sharpness of trans florets';
            valuesOut{i} = {'Sharp','Steep curve','Curve'};
            text_angle(i) = 40;
        case 'st.r.colour'
            paramOut{i} = 'Colour of ray florets';
            valuesOut{i} = {'Red','Pink','Green','Yellow-green','Yellow','Brown'};
            text_angle(i) = 45;
        case 'st.t.colour'
            paramOut{i} = 'Colour of trans florets';
            valuesOut{i} = {'Red','Pink','Green','Yellow-green','Yellow','Brown'};
            text_angle(i) = 45;
        case 'st.r.orientation_shift_var'
            paramOut{i} = 'Ray florets symmetry';
            valuesOut{i} = {'Symmetrical','Misaligned','Random'};
            text_angle(i) = 30;
        case 'st.t.orientation_shift_var'
            paramOut{i} = 'Trans florets symmetry';
            valuesOut{i} = {'Symmetrical','Misaligned','Random'};
            text_angle(i) = 30;
            otherwise
                error([paramOut{i} ' not identified in rename_parameters file.']);
        end
        
    %'Long' experiment parameters
    elseif strcmpi(expID,'long')
        switch (strip(paramIn{i}))
            case 'st.r.avgPetals',              paramOut{i} = 'Number of ray florets';
            case 'st.t.avgPetals',              paramOut{i} = 'Number of trans florets';
            case 'st.r.fractal_exponent',       paramOut{i} = 'Ray floret fractal exponent';                
            case 'st.t.fractal_exponent',       paramOut{i} = 'Trans floret fractal exponent';
            case 'st.d.fractal_exponent',       paramOut{i} = 'Disk fractal exponent';
            case 'st.d.size',                   paramOut{i} = 'Disk size';
            case 'st.r.tips_likelihood_change'
                paramOut{i} = 'Freq of tip change in ray florets';
                valuesOut{i} = valuesIn{i}*100; %converts from decimal to percentage
            case 'st.r.sizeY'
                paramOut{i} = 'Ray floret width';
                valuesOut{i} = valuesIn{i}*2; %converts radius to axis length
            case 'st.t.sizeY'
                paramOut{i} = 'Trans floret width';
                valuesOut{i} = valuesIn{i}*2; %converts radius to axis length
            case 'st.r.varX'
                paramOut{i} = 'Ray floret length variance';
                valuesOut{i} = valuesIn{i}*100; %converts from decimal to percentage
            case 'st.t.varX'
                paramOut{i} = 'Trans floret length variance';
                valuesOut{i} = valuesIn{i}*100;
            case 'st.r.tips_sharpness'
                paramOut{i} = 'Tip sharpness of ray florets';
                valuesOut{i} = {'Sharp','Steep curve','Curve'};
                text_angle(i) = 40;
            case 'st.t.tips_sharpness'
                paramOut{i} = 'Tip sharpness of trans florets';
                valuesOut{i} = {'Sharp','Steep curve','Curve'};
                text_angle(i) = 40;
            case 'st.r.colour'
                paramOut{i} = 'Colour of ray florets';
                valuesOut{i} = {'Red','Pink','Green','Yellow'};
                text_angle(i) = 45;
            case 'st.t.colour'
                paramOut{i} = 'Colour of trans florets';
                valuesOut{i} = {'Red','Pink','Green','Yellow'};
                text_angle(i) = 45;
            case 'st.r.orientation_shift_var'
                paramOut{i} = 'Ray florets symmetry';
                valuesOut{i} = {'Symmetrical','Misaligned','Random'};
                text_angle(i) = 30;
            case 'st.t.orientation_shift_var'
                paramOut{i} = 'Trans florets symmetry';
                valuesOut{i} = {'Symmetrical','Misaligned','Random'};
                text_angle(i) = 30;
            case 'st.r.fractal_type'
                paramOut{i} = 'Ray floret fractal';
                valuesOut{i} = {'Off','Regular','Binarized'};
            case 'st.t.fractal_type'
                paramOut{i} = 'Trans floret fractal';
                valuesOut{i} = {'Off','Regular','Binarized'};
            case 'st.d.fractal_type'
                paramOut{i} = 'Disk fractal';
                valuesOut{i} = {'Off','Regular','Binarized'};
            otherwise
                error([paramOut{i} ' not identified in rename_parameters file.']);
        end
    end
end

end