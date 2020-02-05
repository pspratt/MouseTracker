function epmTrial2csv

% Output an csv file with the following fields

files = uipickfiles('FilterSpec','*EPM Trial.mat');

for i=1:length(files)
    trials(i) = load(files{i});
end

for i=1:length(trials)
    header{1,1} = 'date';
    csvOutput{i,1} = 'No Entry';
    
    header{1,2} = 'group';
    csvOutput{i,2} = 'No Entry';  
    
    header{1,3} = 'name';
    csvOutput{i,3} = trials(i).name;
    
    header{1,4} = 'Time';
    csvOutput{i,4} = trials(i).time(end);
    
    header{1,5} = 'Distance';
    csvOutput{i,5} = trials(i).distance.total;
    
    header{1,6} = 'timeOpen';
    csvOutput{i,6} = trials(i).zones(1).timeCenterInZone+trials(i).zones(2).timeCenterInZone;
    
    header{1,7} = 'timeClosed';
    csvOutput{i,7} = trials(i).zones(3).timeCenterInZone+trials(i).zones(4).timeCenterInZone;
    
    header{1,8} = 'timeCenter';
    csvOutput{i,8} = trials(i).zones(5).timeCenterInZone;
    
    header{1,9} = 'entriesOpen';
    csvOutput{i,9} = trials(i).zones(1).centerEntries+trials(i).zones(2).centerEntries;
    
    header{1,10} = 'entriesClosed';
    csvOutput{i,10} = trials(i).zones(3).centerEntries+trials(i).zones(4).centerEntries;
    
    header{1,11} = 'entriesCenter';
    csvOutput{i,11} = trials(i).zones(5).centerEntries;
    
    header{1,12} = 'entriesHeadOpen';
    csvOutput{i,12} = trials(i).zones(1).headEntries+trials(i).zones(2).headEntries;
    
    header{1,13} = 'entriesHeadClosed';
    csvOutput{i,13} = trials(i).zones(3).headEntries+trials(i).zones(4).headEntries;
    
    header{1,14} = 'entriesHeadCenter';
    csvOutput{i,14} = trials(i).zones(5).headEntries;
    
end
    
[temp name] = fileparts(pwd);

[fileName,PathName,FilterIndex] = uiputfile('*.csv','Save output csv File',name);


fid = fopen(fileName,'wt');

for i=1:length(header(:,1))
    for j=1:length(header(i,1:end-1))
        fprintf(fid, '%s,', num2str(header{i,j}));
    end
        fprintf(fid, '%s\n', num2str(header{i,end})) ; 
end
       
for i=1:length(csvOutput(:,1))
    for j=1:length(csvOutput(i,1:end-1))
        fprintf(fid, '%s,', num2str(csvOutput{i,j}));
    end
        fprintf(fid, '%s\n', num2str(csvOutput{i,end})) ; 
end
fclose(fid) ;
