function behaviorTrial2csv(trials)

if nargin < 1
    trialFiles = uipickfiles('FilterSpec','* Trial.mat');
    for i=1:length(trialFiles)
        trials(i) = load(trialFiles{i});
    end 
end 

for i=1:length(trials)   
    
    
    header{1,1} = 'name';
    csvOutput{i,1} = trials(i).name;
    
    header{1,2} = 'Time (s)';
    csvOutput{i,2} = trials(i).time(end);
    
    header{1,3} = 'Distance (cm)';
    csvOutput{i,3} = trials(i).distance.total;
    
    for j=1:length(trials(i).zones)
        header{1,2*j+2} = ['Time in ' trials(i).zones(j).name ' (s)'];
        csvOutput{i,2*j+2} = trials(i).zones(j).timeCenterInZone;

        header{1,2*j+3} = ['Entries to ' trials(i).zones(j).name];
        csvOutput{i,2*j+3} = trials(i).zones(j).centerEntries;
    end    
end
    
fileName = [trials(i).mazeType ' tracking data.csv'];


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