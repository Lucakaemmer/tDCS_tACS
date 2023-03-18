%---------------
% Log File
%---------------

% Creating the log file to be filled during the experiment
fileID = fopen(['Outputs/Log_File.tsv'],'w');       %creates the empty logfile in the directory you specify 
formatSpec = '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n';        %specifies the format of each variable that you put into the logfile
labels = ["Trial Onset" "Trial Duration" "Trial Type" "Sample 1" "Sample 2" "Memory Cue" "Remembered Sample" "WM Delay" "Presented Stimulus 1" "Presented Stimulus 2" "Correct Stimulus" "ITI" "Timing" "Keypress" "Response" "Too late" "RT"];         %Specifies labels for each column that I want in the logfile.
fprintf(fileID, formatSpec, labels);        %This actially prints the line labels line that I specified into the first row of my log file.


%%% Writing log file in .tsv format
log = [Design(i,1:2) "trial type" Design(i,3:11) timing keypress response too_late RT];     %Here I define the second row of the log file. This is done after the end of each trial to save the actial values. I also save parts of my design matrix here, but I will adjust that later so that I only save the variables that I use in the experiment. 
fprintf(fileID, formatSpec, log);       %Here I save the previously defined row in the log file.


% Closing the log file
fclose(fileID);     % This closes the log file at the end of your experiment.
