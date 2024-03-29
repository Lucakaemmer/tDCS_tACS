%% *******************************************************************
%                       PREPARE WORKSPACE
%*********************************************************************
clear, clc
rand('state',sum(100*clock));

% Name of the participant
part = ('felix_test_tDCS');

Tstart = clock;
timestamp = [num2str(Tstart(4)) 'h' num2str(Tstart(5)) 'm'];



%% *******************************************************************
%                       DESIGN MATRIX
%*********************************************************************

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

%%% Putting together the Design Matrix
Design = [Timing', Duration', Trials]; 
           
%%% Design Matrix
% 1: Trial_onset time
% 2: Trial Duration
% 3: Vibration sample 1
% 4: Vibration sample 2
% 5: Memory cue to sample 1 or 2
% 6: Sample that has to be remembered 
% 7: WM delay
% 8: First stimulus presented after delay (target or foil)
% 9: Second stimulus presented after delay (target or foil)
% 10: Correct test stimulus
% 11: Inter-Trial-Interval

clear Timing initial_pause Duration Trial_type ITIs Trials i anfangspause Trials_catch_noWM stim_name wmdelay ;

%---------------
% Log File
%---------------

% Creating the log file to be filled during the experiment
fileID = fopen(['C:/tDCS_TWMD/Outputs/' part '_' timestamp '_Log_File.tsv'],'w'); %opens a file for each participant. Also includes time.
formatSpec = '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n';
labels = {'Trial Onset' 'Trial Duration' 'Trial Type' 'Sample 1' 'Sample 2' 'Memory Cue' 'Remembered Sample' 'WM Delay' 'Presented Stimulus 1' 'Presented Stimulus 2' 'Correct Stimulus' 'ITI' 'Timing' 'Keypress' 'Response' 'Too late' 'RT'};
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
addpath('C:\tDCS_TWMD\QuaeroBox');
cd ('C:\tDCS_TWMD')
load('sub001_tDCS_TWMD_Stimuli.mat');

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
%i = 1 %for debugging
    
    % Downloading stimulus 1
    t = download_stim2x8_TWMD(tDCS_TWMD_Stimuli.stimuli{Design(i,3)}(:,:,(1:2:end)),dt,0);

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
    
    
    % Downloading stimulus 2
    t = download_stim2x8_TWMD(tDCS_TWMD_Stimuli.stimuli{Design(i,4)}(:,:,(1:2:end)),dt,0);
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
    t = download_stim2x8_TWMD(tDCS_TWMD_Stimuli.mask(:,:,(1:2:end)),dt,0);
    while toc < 2.0 - load_stim_dur_mask
    end
        
    % Presentation of memory cue and mask
    startStim;     
    trial_timing(i,5) = toc; % keeping track of the timing within the trial
    Screen('Textstyle', window, 0);
    if Design(i,5) == 1 
        DrawFormattedText(window, '1', 'center', 'center', white);
        Screen('Flip', window);
    elseif Design(i,5) == 2
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
    if Design(i,8) < 100
        t = download_stim2x8_TWMD(tDCS_TWMD_Stimuli.stimuli{Design(i,8)}(:,:,(1:2:1400)),dt,0);
    else
        t = download_stim2x8_TWMD(tDCS_TWMD_Stimuli.alternative{fix(Design(i,8)/100),mod(Design(i,8),100)}(:,:,(1:2:1400)),dt,0);
    end
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
    if Design(i,9) < 100
        t = download_stim2x8_TWMD(tDCS_TWMD_Stimuli.stimuli{Design(i,9)}(:,:,(1:2:1400)),dt,0);
    else
        t = download_stim2x8_TWMD(tDCS_TWMD_Stimuli.alternative{fix(Design(i,9)/100),mod(Design(i,9),100)}(:,:,(1:2:1400)),dt,0);
    end
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
    if keypress == Design(i,10)  %correct
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
    formatSpec = '%d\t%d\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n';
    log = {Design(i,1) Design(i,2) 'trial type' Design(i,3) Design(i,4) Design(i,5) Design(i,6) Design(i,7) Design(i,8) Design(i,9) Design(i,10) string(Design(i,11)) timing keypress response too_late RT};
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

% Ending the experiment
ShowCursor;
sca;
return


          











