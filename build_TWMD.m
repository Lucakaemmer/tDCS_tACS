function build_TWMD(sj)

% This script is made to create a event-struct that contains all relevant
% information of the event. It further saves the pinhup matrix for the
% stimulus.    
%addpath('C:\toolbox\Quaerobox\');
%addpath('C:\toolbox\Quaerobox\QuaeroSys\');
% It takes the INPUT 'sj' as row-index for the stimuli and the alternative
% stimuli in the following struct
load('Stimuli_raw.mat')

% it outputs a folder with Stimuli (translated in pinhub-matrixes)

% Specify Output directory
tgt_dir = fullfile(pwd, 'Stimuli' );
if ~exist(tgt_dir, 'dir')
    mkdir(tgt_dir)
end

%% ******************************************************
%               EVENT PROPERTIES
% *******************************************************
% LOADING OF SET
onRamp    = 100;
offRamp   = 100;
stimdur   = 700;
maskdur   = 500;
stimfreq  = 30;

% ***********************************************************
% Set Properties that are the same for all events in all stimuli
event.envelope.onRamp  = onRamp; % ramp to smoothen stimulus onset  in ms
event.envelope.offRamp = offRamp; % ramp to smoothen stimulus offset in ms
stimulus.stimdur      = stimdur;   % in Stimulus duration in ms
stimulus.stimfreq     = stimfreq;    % The carrier frequency to modulate the vibration
stimulus.tRes         = 0.5;    % The carrier frequency to modulate the vibration

name = ['TWMDsj' num2str(sj)];

% Stimuli
for n = 1:4
    event.name             = TWMDstim.stimuli.name{sj,n}; % Index of Stimulus from pool of all Stimuli
    event.shape.pinpattern = TWMDstim.stimuli.pattern{sj,n};
    stimulus.stimname      = [name '_stim' num2str(n)];

    stimulus.eventlist{1}.event        = event;
    stimulus.eventlist{1}.event.onset  = 0;
    stimulus.eventlist{1}.event.dur    = stimdur;
    % This takes time
    TWMDpinhub.stimuli{n} = stimulus_composer(stimulus,0);
    display(['Stimulus ' stimulus.stimname 'composed']);   
end

% Alternatives
for n = 1:4
    for j = 1:100
        event.name             = TWMDstim.alternatives.name{sj,n}(j); % Index of Stimulus from pool of all Stimuli
        event.shape.pinpattern = TWMDstim.alternatives.pattern{sj,n}{1,j};
        stimulus.stimname      = [name '_Astim' num2str(n) '_' num2str(j)];
        stimulus.eventlist{1}.event        = event;
        stimulus.eventlist{1}.event.onset  = 0;
        stimulus.eventlist{1}.event.dur    = stimdur;
        % This takes time
        TWMDpinhub.alternative{n,j} = stimulus_composer(stimulus,0);
        display(['Stimulus ' stimulus.stimname 'composed']);   
    end
end

% Mask
for n = 1:4
    for j = 1:100
        stimulus.stimdur                   = maskdur;
        event.name                         = 'Mask';
        event.shape.pinpattern             = ones(4,4);
        stimulus.stimname                  = 'Mask';
        stimulus.eventlist{1}.event        = event;
        stimulus.eventlist{1}.event.onset  = 0;
        stimulus.eventlist{1}.event.dur    = maskdur;
        % This takes time
        TWMDpinhub.mask = stimulus_composer(stimulus,0);
        display(['Stimulus ' stimulus.stimname 'composed']);   
    end
end


save(fullfile(tgt_dir, name),'TWMDpinhub');
clear all




tRes = 1; % Time resolution of the stimulus

if isfield(stimulus,'stimfreq') 
    stimfreq = stimulus.stimfreq;
    stimdur = stimulus.stimdur;
    if stimfreq == 0;
    else
        Carrier = zeros(1,1,nstep+1);
        Carrier(1,1,:) = [(sin( (0:((((stimdur)./1000)*stimfreq)*2*pi)./((stimdur)./tRes):((((stimdur)./1000)*stimfreq)*2*pi) )+1)./2)]; % This function makes the sin function that you can plot
        Carrier(1) = [];
        Carrier = repmat(Carrier, [ResVDis,ResVDis,1])+0.5;
        viDis = viDis.*Carrier;
    end
end

plot()




% loop über jeden Pin
clear all
pattern = [1 0.3 0.1 1;
           1 0.3 0.1 1;
           1 0.3 0.1 1;
           1 0.3 0.1 1];
stimulus = zeros(4,4,701);
for i = 1:4
    for j = 1:4
        pinhub = pattern(i,j);
        
        rampdur = 100; % ramp in ms
        modulation = [(0:pinhub/rampdur:pinhub) ones(1,499)*pinhub (pinhub:-pinhub/rampdur:0)];
        
        tRes = 1;
        stimfreq = 30;
        stimdur  = 700;
        timecourse = [(sin( (0:((((stimdur)./1000)*stimfreq)*2*pi)./((stimdur)./tRes):((((stimdur)./1000)*stimfreq)*2*pi) )+1)./2)];
        timecourse = timecourse + 0.5;
        
        stimulus(i,j,:) = modulation.*timecourse;
        
        clear pinhub;
    end
end
plot(squeeze(stimulus(1,1,:))); hold on; plot(squeeze(stimulus(2,2,:)));



