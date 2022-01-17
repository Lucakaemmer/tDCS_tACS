%% *******************************************************************
%                       DESIGN MATRIX
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

Trial_type = repmat('trial_type', length(Duration), 1); 

%%% Putting together the Design Matrix
Design = [Timing', Duration', Trials]; %Why does Trial_type turn whole design matrix into type str?
           
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


%---------------
% Log File
%---------------

Trial_type = repmat('trial_type', length(Duration), 1);

%%% Writing Design Matrix in .tsv file
writematrix(Design, 'Outputs/Design_Matrix.tsv', 'FileType', 'text', 'Delimiter', '\t')


clear Timing initial_pause Duration Trial_type ITIs Trials i anfangspause Trials_catch_noWM stim_name wmdelay ;


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
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
 
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
%                        Experimental Loop
%*********************************************************************

% Starting the global clock of the experiment
start_run = GetSecs;

for i=1:length(Design)
%i = 1 %for debugging

    % Exact starttime of each trial. Includes 8s waiting period before first trials and ITI after each trial
    while GetSecs < start_run + (Design(i,1)/1000)
            Screen('Textstyle', window, 0)
            DrawFormattedText(window, '+', 'center', 'center', white)
            Screen('Flip', window)
    end
    
    % Starting the internal clock that times each trial
    tic; 
    
    % Presentation of sample 1
    while toc < 0.7 
        Screen('Textstyle', window, 1)
        DrawFormattedText(window, '+', 'center', 'center', white)
        Screen('Flip', window)
    end
    
    % Pause 
    while toc < 1
        Screen('Textstyle', window, 0)
        DrawFormattedText(window, '+', 'center', 'center', white)
        Screen('Flip', window)
    end
    
    % Presentation of sample 2
    while toc < 1.7
        Screen('Textstyle', window, 1)
        DrawFormattedText(window, '+', 'center', 'center', white)
        Screen('Flip', window)
    end

    % Pause
    while toc < 2
        Screen('Textstyle', window, 0)
        DrawFormattedText(window, '+', 'center', 'center', white)
        Screen('Flip', window)
    end
    
    % Presentation of memory cue
    while toc < 2.5
        Screen('Textstyle', window, 0)
        if Design(i,5) == 1 
            DrawFormattedText(window, '1', 'center', 'center', white)
            Screen('Flip', window)
        elseif Design(i,5) == 2
            DrawFormattedText(window, '2', 'center', 'center', white)
            Screen('Flip', window)
        end        
    end

    % Waiting period
    while toc < 10
        Screen('Textstyle', window, 0)
        DrawFormattedText(window, '+', 'center', 'center', white)
        Screen('Flip', window)
    end

    % Presentation of foil/target stimulus
    while toc < 10.7 
        Screen('Textstyle', window, 1)
        DrawFormattedText(window, '+', 'center', 'center', white)
        Screen('Flip', window)
    end
    
    % Pause
    while toc < 11
        Screen('Textstyle', window, 0)
        DrawFormattedText(window, '+', 'center', 'center', white)
        Screen('Flip', window)
    end
    
    % Presentation of target/foil stimulus
    while toc < 11.7 
        Screen('Textstyle', window, 1)
        DrawFormattedText(window, '+', 'center', 'center', white)
        Screen('Flip', window)
    end
    
    % Response
    while toc < 13.2 
        Screen('Textstyle', window, 0)
        DrawFormattedText(window, '?', 'center', 'center', white)
        Screen('Flip', window)
    end
end


          











