addpath('C:\tDCS_TWMD\QuaeroBox');


load('sub001_tDCS_TWMD_Stimuli.mat');

% Initiation of Stimulator
initQuaeroBox;
prepare_stimulator;

%Stimulator settings 
dt=0.5;

for i=1:4
for s = 1:4


t = download_stim2x8(tDCS_TWMD_Stimuli.stimuli{s},dt,0);
startStim;
pause(0.7);
stopStim;
pause(1);

end
end