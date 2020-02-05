function cumulativeDistance

files = uipickfiles('FilterSpec','*Trial.mat');

for i=1:length(files)
    trials(i) = load(files{i});
end 

for i=1:length(trials)
    for j=trials(i).sampleRate:trials(i).sampleRate:length(trials(i).distance.cumulative)
        distance(i,j./trials(i).sampleRate) = trials(i).distance.cumulative(j);
    end
    
end

figure;
plot(mean(distance))



[temp name] = fileparts(pwd);

fid = fopen([name ' cumulative distance.csv'],'wt');
       
for i=1:length(distance(:,1))
    for j=1:length(distance(i,1:end-1))
        fprintf(fid, '%s,', num2str(distance(i,j)));
    end
        fprintf(fid, '%s\n', num2str(distance(i,end))) ; 
end
fclose(fid) ; 