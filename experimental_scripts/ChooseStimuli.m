clear all;
clc;

%% Loading and preparing the Data
% Load Stimuli and their correlation matrix
load('C:\Users\lucak\Documents\GitHub\tDCS_tACS\Pattern.mat')
load('C:\Users\lucak\Documents\GitHub\tDCS_tACS\CorMat.mat')

% Reshaping "Pattern" to a vector containing all patterns
Pattern_Vector = reshape(Pattern,[],1);


%% Choosing the 2 target stimuli with certain correlation

% Finds index of entries in CorMat that are within a certain correlation range
[stim2, stim1] = find(abs(CorMat)<0.05);

% Delete double entries in the chosen patterns so that we have each pattern only once 
repeats = diff(stim2) == 0; 
stim1(repeats) = [];
stim2(repeats) = [];

repeats = diff(stim1) == 0; 
stim1(repeats) = [];
stim2(repeats) = [];


%% Chooseing the alternative stimuli with certain correlation to stim1

% search for stimuli that have a specific correlation with stim1
% maybe select all possible stimuli within range and then chose random one
alt = [];
for i = stim1'
    x = find(CorMat(i,:)>0.6 & CorMat(i,:)<0.7,1);
    if isempty(x) == 1
        alt = [alt, 0];
    else
        alt = [alt, x];
    end
end

% delete patterns from all stimulus vectors where stim1 that didn't have a fitting alternative stimulus within the set correlation
del = alt == 0; 
alt(del) = [];
stim1(del) = [];
stim2(del) = [];


%% Finishing up

% Extract 200 sets of patterns with stimulus 1, stimulus 2, and alternative stimulus
for i = 1:200    
    stimuli(i,1) = Pattern_Vector(stim1(i));
    stimuli(i,2) = Pattern_Vector(stim2(i));
    stimuli(i,3) = Pattern_Vector(alt(i));
end


% Sanity Check: Checking if the correlations of the stimuli that were extracted are correct
t = 6;
corr_stim = corrcoef(stimuli{t,1}, stimuli{t,2});
corr_alt = corrcoef(stimuli{t,1}, stimuli{t,3});

% Saving the created stimuli for use in the experiment
save Stimuli_raw.mat stimuli

clear del; clear i; clear repeats; clear x; clear t;






