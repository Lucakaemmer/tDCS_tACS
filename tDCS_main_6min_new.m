%% *******************************************************************
%                       PREPARE WORKSPACE
%*********************************************************************
clear, clc
rand('state',sum(100*clock));

% Name of the participant
part = ('SUB07_tDCS_TWMD_sess02_run00_stim');
Tstart = clock;
timestamp = [num2str(Tstart(4)) 'h' num2str(Tstart(5)) 'm'];


%% *******************************************************************
%                       DESIGN MATRIX
%*********************************************************************

%%% General Settings
initial_pause = 8000;   % in ms
wmdelay      = 6500;  % in ms
ITIs        = [2000 4000];   


% Randomly choosing a stimulus set that is presented in each trial
stim_set = randperm(200)'; 
stim_set = stim_set(1:24);

% Randomly chooseing which stimulus is presented first in each trial (same as memory cue)
presented_first = [(2*ones(1,12)),(ones(1,12))]';
presented_first = presented_first(randperm(length(presented_first)));

% Assigning which stimulus is presented second 
presented_second = ones(24,1);
for i = 1:length(presented_first)
    if presented_first(i) == 1
        presented_second(i) = 2;
    end
end

% Randomly chooseing which stimulus is presented third (target or foil)
presented_third = [(3*ones(1,12)),(ones(1,12))]';
presented_third = presented_third(randperm(length(presented_third)));

% Assigning which stimulus is presented fourth 
presented_fourth = ones(24,1);
for i = 1:length(presented_third)
    if presented_third(i) == 1
        presented_fourth(i) = 3;
    end
end

% Defining the WM delay for each trial
Delay = repmat([wmdelay],1,24)';

%Assignment of ITI
ITI = [randsample(repmat(ITIs,1,(length(stim_set)/length(ITIs))),length(stim_set))]'; % ITI assignment; 

% Assessing the onset of each trial
Timing = [initial_pause];
for i = 1:(length(stim_set)-1)
    next_onset = Timing(i) + 2500 + Delay(i) + 4000 + ITI(i); %Adding of time
    Timing(i+1) = next_onset; 
    clear next_onset;
end
Timing = Timing';

% Creating a vector with the duration of each trial
Duration = (13000*ones(1,24))';


%%% Putting it all in the design matrix
Design = [Timing, Duration, stim_set, presented_first, presented_second, presented_third, presented_fourth, Delay, ITI];

clear i Duration stim_set presented_first presented_second presented_third presented_fourth Delay ITI wmdelay ITIs initial_pause Timing

%%% Design Matrix (new)
% 1: Trial_onset time
% 2: Trial Duration
% 3: Stimulus set used in the trial
% 4: First stimulus presented (also memory cue and correct stimulus)
% 5: Second stimulus presented 
% 6: Third stimulus presented
% 7: Fourth stimulus presented
% 8: WM Delay
% 9: Inter-Trial-Interval


%%% Design Matrix (old)
% 1: Trial_onset time
% 2: Trial Duration
% 3: Vibration sample 1 ***
% 4: Vibration sample 2 ***
% 5: Memory cue to sample 1 or 2 ***
% 6: Sample that has to be remembered ***
% 7: WM delay
% 8: First stimulus presented after delay (target or foil) ***
% 9: Second stimulus presented after delay (target or foil) ***
% 10: Correct test stimulus ***
% 11: Inter-Trial-Interval

clear Timing initial_pause Duration Trial_type ITIs Trials i anfangspause Trials_catch_noWM stim_name wmdelay

%---------------
% Log File
%---------------

% Creating the log file to be filled during the experiment
fileID = fopen(['D:\Psychtoolbox\Luca\tDCS_TWMD\Outputs\' part '_' timestamp '_Log_File.tsv'],'w'); %opens a file for each participant. Also includes time.
formatSpec = '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n';
labels = {'Trial Onset' 'Trial Duration' 'Trial Type' 'Stimulus Set' 'Stimulus 1' 'Stimulus 2' 'Stimulus 3' 'Stimulus 4' 'WM delay' 'ITI' 'Timing' 'Keypress' 'Response' 'Too late' 'RT'};
fprintf(fileID, formatSpec, labels{:});

%% *******************************************************************
%                            SCREEN
%*********************************************************************

%---------------
% Screen Setup
%---------------
 
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
 
% Get the screen numbers
screens = Screen('Screens');

% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);
 
% Define black, white and grey
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;
 
% Open an on screen window and color it grey
[window, windowRect] =  Screen('OpenWindow', screenNumber, grey);
 
% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
 
% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
 
% Query the frame duration
ifi = Screen('GetFlipInterval', window);
 
% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);
 
% Set the text size
Screen('TextSize', window, 70);



%% *******************************************************************
%                            Keyboard
%*********************************************************************
KbName('UnifyKeyNames');

escapeKey = KbName('ESCAPE');
first = KbName('1!');
second = KbName('2@');



%% *******************************************************************
%                            Stimulator
%*********************************************************************
% addpath('D:\Psychtoolbox\Luca\tDCS_TWMD\Quaerobox');
cd ('D:\Psychtoolbox\Luca\tDCS_TWMD')
load('Stimuli_transformed.mat');

% Initiation of Stimulator
initQuaeroBox;
prepare_stimulator;
reset_stimulator;

%Stimulator settings 
dt=1;
load_stim_dur = 0.29;
load_stim_dur_mask = 0.23;


%% *******************************************************************
%                        Experimental Loop
%*********************************************************************

% Starting the global clock of the experiment
start_run = GetSecs;

for i=1:length(Design)
%i = 1; %for debugging
    
    % Downloading stimulus 1, indexing stimulus set and first stimulus
    t = download_stim2x8_TWMD(Stimuli_transformed.stimuli{Design(i,3),Design(i,4)},dt,0);

    % Exact starttime of each trial. Includes 8s waiting period before first trials and ITI after each trial
    Screen('Textstyle', window, 0);
    DrawFormattedText(window, '+', 'center', 'center', white);
    Screen('Flip', window);
    while GetSecs < start_run + (Design(i,1)/1000) - load_stim_dur
    end


    %% Trial
    % tracks actual starttime of each trial
    timing = GetSecs - start_run + load_stim_dur;
    
    % Presentation of stimulus 
    startStim;   
    tic; % Starting the internal clock that times each trial
    trial_timing(i,1) = toc; % keeping track of the timing within the trial by recording the time at which a new screen is presented
    Screen('Textstyle', window, 1);
    DrawFormattedText(window, '+', 'center', 'center', white);
    Screen('Flip', window);
    stopStim;     
    while toc < 0.7 
    end

    
    % Pause 
    trial_timing(i,2) = toc; % keeping track of the timing within the trial
    Screen('Textstyle', window, 0);
    DrawFormattedText(window, '+', 'center', 'center', white);
    Screen('Flip', window);
    
    
    % Downloading stimulus 2, indexing stimulus set and first stimulus   
    t = download_stim2x8_TWMD(Stimuli_transformed.stimuli{Design(i,3),Design(i,5)},dt,0);
    while toc < 1 - load_stim_dur
    end
    
    % Presentation of stimulus 2
    startStim;       
    trial_timing(i,3) = toc; % keeping track of the timing within the trial
    Screen('Textstyle', window, 1);
    DrawFormattedText(window, '+', 'center', 'center', white);
    Screen('Flip', window);
    stopStim;
    while toc < 1.7
    end


    % Pause
    trial_timing(i,4) = toc; % keeping track of the timing within the trial
    Screen('Textstyle', window, 0);
    DrawFormattedText(window, '+', 'center', 'center', white);
    Screen('Flip', window);
    
    
    % Downloading mask
    t = download_stim2x8_TWMD(Stimuli_transformed.mask,dt,0);
    while toc < 2.0 - load_stim_dur_mask
    end
        
    % Presentation of memory cue and mask
    startStim;     
    trial_timing(i,5) = toc; % keeping track of the timing within the trial
    Screen('Textstyle', window, 0);
    if Design(i,4) == 1 
        DrawFormattedText(window, '1', 'center', 'center', white);
        Screen('Flip', window);
    elseif Design(i,4) == 2
        DrawFormattedText(window, '2', 'center', 'center', white);
        Screen('Flip', window);
    end
    stopStim;
    while toc < 2.5       
    end

    
    % Waiting period
    trial_timing(i,6) = toc; % keeping track of the timing within the trial
    Screen('Textstyle', window, 0);
    DrawFormattedText(window, '+', 'center', 'center', white);
    Screen('Flip', window);
     
    
    % Downloading foil/target Stimulus                            
    t = download_stim2x8_TWMD(Stimuli_transformed.stimuli{Design(i,3),Design(i,6)},dt,0);
    while toc < 10 - load_stim_dur
    end

    % Presentation of foil/target stimulus
    startStim; 
    trial_timing(i,7) = toc; % keeping track of the timing within the trial
    Screen('Textstyle', window, 1);
    DrawFormattedText(window, '+', 'center', 'center', white);
    Screen('Flip', window);
    stopStim;
    while toc < 10.7 
    end
    
    
    % Pause 
    trial_timing(i,8) = toc; % keeping track of the timing within the trial
    Screen('Textstyle', window, 0);
    DrawFormattedText(window, '+', 'center', 'center', white);
    Screen('Flip', window);
    
    
    % Downloading target/foil stimulus
    t = download_stim2x8_TWMD(Stimuli_transformed.stimuli{Design(i,3),Design(i,7)},dt,0);
    while toc < 11 - load_stim_dur
    end

    % Presentation of target/foil stimulus
    startStim; 
    trial_timing(i,9) = toc; % keeping track of the timing within the trial11122121
    Screen('Textstyle', window, 1);
    DrawFormattedText(window, '+', 'center', 'center', white);
    Screen('Flip', window);
    stopStim;
    while toc < 11.7 
    end
    
    
    %for RT
    pres_t = GetSecs;
    
    
    %% Response
    % Presentation of response screen
    trial_timing(i,10) = toc; % keeping track of the timing within the trial
    respToBeMade = true;
    Screen('Textstyle', window, 0);
    DrawFormattedText(window, '?', 'center', 'center', white);
    Screen('Flip', window);
    while toc < 13.2  && respToBeMade == true
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
        elseif keyCode(first)
            keypress = 1;
            too_late = 0;
            respToBeMade = false;
        elseif keyCode(second)
            keypress = 2;
            too_late = 0;
            respToBeMade = false;
        else
            keypress = 99;
            too_late = 1;
        end    
    end
    
    %RT
    if too_late == 0
        RT = GetSecs - pres_t;
    elseif too_late == 1
        RT = -1;
    end

        
    %% Results and Feedback
    if keypress == 1 && Design(i,6) == 1 || keypress == 2 && Design(i,7) == 1 %correct
        response = 1;
        Screen('Textstyle', window, 0);
        DrawFormattedText(window, '+ + +', 'center', 'center', white);
        Screen('Flip', window);
        WaitSecs(1) % feedback presented for 1 second
    elseif keypress == 99 %too late
        response = 0;
        Screen('Textstyle', window, 0);
        DrawFormattedText(window, 'x + x', 'center', 'center', white);
        Screen('Flip', window);
        WaitSecs(0.2)
        DrawFormattedText(window, '+', 'center', 'center', white);
        Screen('Flip', window);
        WaitSecs(0.2)
        DrawFormattedText(window, 'x + x', 'center', 'center', white);
        Screen('Flip', window);
        WaitSecs(0.2)
        DrawFormattedText(window, '+', 'center', 'center', white);
        Screen('Flip', window);
        WaitSecs(0.2)
        DrawFormattedText(window, 'x + x', 'center', 'center', white);
        Screen('Flip', window);
        WaitSecs(0.2) % feedback presented for 1 second
    else %incorrect
        response = 0;
        Screen('Textstyle', window, 0);
        DrawFormattedText(window, '- + -', 'center', 'center', white);
        Screen('Flip', window);
        WaitSecs(1) % feedback presented for 1 second
    end
     
    %%% Writing log file in .tsv format
    formatSpec = '%d\t%d\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n';
    log = {Design(i,1) Design(i,2) 'trial type' Design(i,3) Design(i,4) Design(i,5) Design(i,6) Design(i,7) Design(i,8) Design(i,9) timing keypress response too_late RT};
    fprintf(fileID, formatSpec, log{:});
    
    trial_timing(i,11) = toc; % keeping track of the timing within the trial
    reset_stimulator;
end

close_stimulator;

% Closing the log file
fclose(fileID);

%%% Log File
% 1: Trial_onset time
% 2: Trial Duration
% 3: Trial Type
% 4: Stimulus Set used in the Trial
% 5: First Stimulus Presented (also memory cue and correct stimulus)
% 6: Second Stimulus Presented
% 7: Third Stimulus Presented 
% 8: Fourth Stimulus Presented
% 9: WM delay
% 10: Inter-Trial-Interval
% 11: Real time since the start of the experiment
% 12: Keypress
% 13: Response
% 14: Was the participant too late
% 15: Reaction Time

% Ending the experiment
ShowCursor;
sca;
return


          











