% Clean Workspace
clear; clc;

%% Import .tsv log file 
cd ('C:\Users\lucak\Desktop\Uni\Berlin\Kurse\Semester 3\Internship_ReseachWorkshop\Data\SUB02')
log = tdfread('SUB02_tDCS_TWMD_sess02_run06_stim00961_14h19m_Log_File','\t');

%%% Log File
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
% 13: Real time since the start of the experiment


%% *******************************************************************
%                        Data Analysis
%*********************************************************************


%%% Descriptives

% Returns proportion of corrent responses
performance = sum(log.Response==1) / length(log.Response);

% Returns number of missed trials
misses = sum(log.Too_late==1);       % / length(log.Too_late);

% Returns average RT
RT = sum(log.RT(log.RT>=0)) / length(log.RT(log.RT>=0)); 

% Comparing mean RT of correct versus incorrect trials
RT_correct = mean(log.RT(log.Response == 1));
RT_incorrect = mean(log.RT(log.RT>=0 & log.Response == 0));

% Comparing performance of trials where first vs second stimulus had to be remembered
performance_1 = sum(log.Response==1 & log.Stimulus_1==1) / sum(log.Stimulus_1==1);
performance_2 = sum(log.Response==1 & log.Stimulus_1==2) / sum(log.Stimulus_1==2);




% Checking the correlation
% corrcoef(Stimuli_transformed.stimuli{30,1}(:,:,2),Stimuli_transformed.stimuli{30,3}(:,:,2))



