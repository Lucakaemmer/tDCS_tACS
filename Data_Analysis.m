%% Import .tsv log file 
cd ('C:\Users\lucak\Documents\GitHub\tDCS_tACS\Outputs')
log = tdfread('Log_File_example.tsv','\t');

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

% Returns proportion of corrent responses
performance = sum(log.Response==1) / length(log.Response);

% Returns proportion of missed trials
misses = sum(log.Too_late==1) / length(log.Too_late);

% Returns average RT
RT = sum(log.RT) / length(log.RT); 



