%% *******************************************************************
%                       PARADIGM SETTINGS
%*********************************************************************
clear all, clc

% There is a set of 4 Stimuli named: 1 2 3 4

%%% General Settings
initial_pause = 8000;   % in ms
wmdelay      = 6500;  % in ms
ITIs        = [2000 4000];   

%%% Specification WM trials: all 24 possible combination of Trials and Cue
Trials_wm = [1 1 1 2 2 2 3 3 3 4 4 4 1 1 1 2 2 2 3 3 3 4 4 4 ;  % Pattern_1
             2 3 4 1 3 4 1 2 4 1 2 3 2 3 4 1 3 4 1 2 4 1 2 3 ;  % Pattern_2  
             1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 ;  % Memory_Cue 
             1 1 1 2 2 2 3 3 3 4 4 4 2 3 4 1 3 4 1 2 4 1 2 3 ;  % Remembered_pattern
             repmat([wmdelay],1,24)                        ]';  % Delay             

Trials_wm1 = [Trials_wm Trials_wm(:,4) Trials_wm(:,4)*100 ones(24,1)];
          
Trials_wm1(:,7) = Trials_wm1(:,7)+randsample(1:50,24,1)';
          
Trials_wm2 = [Trials_wm Trials_wm(:,4)*100 Trials_wm(:,4) ones(24,1)*2];

Trials_wm2(:,6) = Trials_wm2(:,6)+randsample(1:50,24,1)';         

% Putting all Trials into one Matrix
Trials_all = [Trials_wm1 
              Trials_wm2];

%Assignment of ITI
Trials_all(:,9) = [randsample(repmat(ITIs,1,(length(Trials_all)/length(ITIs))),length(Trials_all))]; % ITI assignment; 

%Randomizing the order of the Trials
trial_order = randperm(length(Trials_all));
for i = 1:length(trial_order)
    Trials(i,:) = Trials_all(trial_order(i),:);
end

clear i Trials_all trial_order Trials_wm Trials_catch Trials_wm1 Trials_wm2 delay_catch;

Timing = [initial_pause];
for i = 1:(length(Trials)-1)
    next_onset = Timing(i) + 2500 + Trials(i,5) + 4000 + Trials(i,9); %Adding of time
    Timing(i+1) = next_onset; 
    clear next_onset;
end

Duration = [];
for i = 1:(length(Trials))
    next_duration = 2500 + Trials(i,5) + 4000; %Adding of time
    Duration(i) = next_duration; 
    clear next_duration;
end

Trial_type = repmat("trial_type", length(Duration), 1); 

%%% Putting together the Design Matrix
Design = [Timing', Duration', Trial_type, Trials]; %Why does Trial_type turn whole design matrix into type str?
           
clear Timing initial_pause Duration Trial_type ITIs Trials i anfangspause Trials_catch_noWM stim_name wmdelay ;


%%% Writing Design Matrix in .tsv file
writematrix(Design, "Outputs/Design_Matrix.tsv", 'FileType', 'text', 'Delimiter', '\t')


%%% Design Matrix
% 1: Trial_onset time
% 2: Trial Duration
% 3: Trial Type
% 4: Vibration sample 1
% 5: Vibration sample 2
% 6: Memory cue to sample 1 or 2
% 7: Sample that has to be remembered 
% 8: WM delay
% 9: First stimulus presented after delay (target or foil)
% 10: Second stimulus presented after delay (target or foil)
% 11: Correct test stimulus
% 12: Inter-Trial-Interval




% names = {'Trial_onset time' 'Trial Duration' 'Trial Type' 'Vibration sample 1' 'Vibration sample 2' 'Memory cue' 'Remembered sample' 'WM delay' 'First stimulus presented' 'Second stimulus presented' 'Correct test stimulus' 'Inter-Trial-Interval'};
% fid = fopen('test_file','w');
% for k=1:12
%    fprintf(fid,'%s\t%.2f\t%.2f\t%.2f\n',names{k},Design(:,k));
% end
% fclose(fid);
% 
% 
% dlmwrite



