    function [pie] = update_pie(resp_params, roulette_vals, pie, prop)

% Takes the parameters of the flowers that the participant selected from the current trial 
% and updates the 'pie' based on what they liked and what they didn't and the proportion of the pie to change
%
% Inputs:
%     resp_params   - A cell array (one cell per question asked), with each containing the values selected by 
%                     the participant for the key parameters being manipulated.
%     roulette_vals - A cell array containing parameter settings/variables that are chosen on each trial. 
%                     e.g., {[5; 10; 25; 45],...}
%     pie           - A cell array containing the proportion of likelihood (or weights) that each of 
%                     these variables will be displayed. e.g., {[0.1, 0.15, 0.25, 0.5],...}
%     prop          - The size of the pie that is being re-distributed on each trial.
%
% Output:
%     pie           - An updated cell array containing the new proportions of likelihood (or weights) based on
%                     the participants responses on this trial.
% 
%Created by Matt Patten
%Created in June 2019


%for each of the parameters being manipulated in the experiment
for p=1:length(pie)

    %compute how much of the pie should be changed
    pieChange = prop * 1 / length(roulette_vals{p});
    
    %%%%%%%%%%%%%%%%%%
    %% Get indexes of winner/loser, and note if either are NaN's (i.e., the parameter wasn't shown)
    %%%%%%%%%%%%%%%%%%
    
    %find winning parameter setting (the first selected on each trial)
    [val_win,idx_win] = min(sum(abs(bsxfun(@minus, resp_params{1}{p}, roulette_vals{p})),2)); %have to subtract differences due to rounding error

    %correct index if parameter is NaN
    if isnan(val_win) 
        param_shown_on_winner = 0; 
    else
        param_shown_on_winner = 1; %defaults    
    end 
        
    %find losing parameter setting (the first selected on each trial)
    [val_lose,idx_lose] = min(sum(abs(bsxfun(@minus, resp_params{2}{p}, roulette_vals{p})),2)); %have to subtract differences due to rounding error

    %correct index if parameter is NaN
    if isnan(val_lose) 
        param_shown_on_loser = 0; 
    else
        param_shown_on_loser  = 1;    
    end 

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Present on both responses  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if and(param_shown_on_winner,param_shown_on_loser) %normal occurrence 

        %choose normal shift, or smaller shift if it straddles one of the boundary edges (losing parameter close to 0 or winning parameter close to 1)
        pieChange = min([pieChange        ...   %normal change
                         pie{p}(idx_lose) ...   %if normal change would drop below lower border
                         1 - pie{p}(idx_win)]); %if normal change would exceed upper border

        %update pie proportions
        pie{p}(idx_win)  = pie{p}(idx_win)  + pieChange;
        pie{p}(idx_lose) = pie{p}(idx_lose) - pieChange;

        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Present on neither response  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    elseif and(~param_shown_on_winner,~param_shown_on_loser) %if parameter not shown on either winner or loser
        %do nothing - parameter wasn't present in either image.

        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Present on winner only  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    elseif ~param_shown_on_loser %winner gets all, loser divided across all other entries
        
        %choose normal shift, or smaller shift if it straddles the upper boundary edge (winning parameter close to 1)
        pieChangeUp = min([pieChange ...          %normal change
                           1 - pie{p}(idx_win)]); %if normal change would exceed upper border

        %remove winner from index of parameters
        allparam = 1:length(roulette_vals{p});
        nonwinners = allparam(allparam~=idx_win);
        
        %divide up amount to be shifted across remaining parameters
        pieChangeDown(nonwinners) = pieChangeUp / (length(nonwinners));
        
        for vv=nonwinners %for all parameters that weren't the winner

            if pie{p}(vv) < pieChangeDown(vv) %if taking normal amount would make it below zero
                pieChangeUp = pieChangeUp - (pieChangeDown(vv) - pie{p}(vv)); %remove extent lower than zero from winner
                pieChangeDown(vv) = pie{p}(vv); %only take away what it actually has
            end

            %update pie proportions, treating everyone except the winner as losers
            pie{p}(vv) = pie{p}(vv) - pieChangeDown(vv);

        end

        %update pie proportions for the winner
        pie{p}(idx_win)  = pie{p}(idx_win) + pieChangeUp;

        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Present on loser only  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    elseif ~param_shown_on_winner %loser loses all, all other values gain a little

        %choose normal shift, or smaller shift if it straddles the lower boundary edge (losing parameter close to 0)
        pieChangeDown = min([pieChange ...       %normal change
                             pie{p}(idx_lose)]); %if normal change would drop below lower border

                         
        %remove winner from index of parameters
        allparam = 1:length(roulette_vals{p});
        nonlosers = allparam(allparam~=idx_lose);

        %divide up amount to be shifted across remaining parameters
        pieChangeUp(nonlosers) = pieChangeDown / (length(nonlosers));
        
        for vv=nonlosers %for all parameters that aren't the loser

            if (pie{p}(vv) + pieChangeUp(vv)) > 1 %if taking normal amount would make it above one
                pieChangeDown = pieChangeDown - (pie{p}(vv) + pieChangeUp(vv) - 1); %remove extent that would have been greater than one
                pieChangeUp(vv) = 1 - pie{p}(vv); %only add amount that will allow it to reach border
            end

            %update pie proportions, treating everyone except the loser as slight winners
            pie{p}(vv) = pie{p}(vv) + pieChangeUp(vv);

        end

        %update pie proportions for the loser
        pie{p}(idx_lose)  = pie{p}(idx_lose) - pieChangeDown;
        
    end
end

end