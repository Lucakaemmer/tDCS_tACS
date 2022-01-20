%% *******************************************************************
%                            Log File
%*********************************************************************

label(:,2)=comment;
for i=1:length(label)
    label(i,3)={time_start(i,1)};   %start date
    label(i,4)={time_start(i,2)};   %start time
    label(i,5)={time_end(i,1)};     %end date
    label(i,6)={time_end(i,2)};     %end time
    label(i,8)={yy(i)-xx(i)};       %duration
end

% export
fileID = fopen(['calendar_' num2str(start_date) '_' num2str(end_date)
'.dat'],'w');
formatSpec = '%s;%s;%d;%d;%d;%d;%s;%d\n';
[nrows,ncols] = size(label);
for row = 1:nrows
    fprintf(fileID,formatSpec,label{row,:});
end
fclose(fileID);

##################################################################

fileID=fopen(['xxx' num2str(aa) '.dat'],'w');
fprintf(fileID,'%s\n','los')
fclose(fileID)

##################################################################

% Alternative to writing log fiel that just writes it as one in the end
writematrix(Log_File, 'Outputs/Log_File.tsv', 'FileType', 'text', 'Delimiter', '\t')
