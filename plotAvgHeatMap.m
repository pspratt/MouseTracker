function plotAvgHeatMap

files = uipickfiles('FilterSpec','*Trial.mat');

for i=1:length(files)
    trials(i) = load(files{i});
end 

[height width] = size(trials(1).heatMap);
heatMap = zeros(height,width);

for i=1:length(trials)
  heatMap =   heatMap + trials(i).heatMap;
end

heatMap = heatMap./length(trials);

fig = figure();
image(heatMap);
ylabel('Seconds');
c = colorbar('westoutside');

[path currentDir] = fileparts(pwd);
title([currentDir ' Heat Map'])
axis image;
set(gca,'xtick',[])
set(gca,'ytick',[])



fileName = [currentDir ' Heat Map.jpg'];
saveas(fig,fileName);
crop([pwd '/' fileName]);

figure;
HeatMap(heatMap);