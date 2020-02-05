function trial = inZoneAnalysis(trial)

%Frames in zone
for i=1:length(trial.zones)

    for j=1:length(trial.position.center)
        if trial.zones(i).mask(trial.position.center(j,2),trial.position.center(j,1)) ~= 0
            trial.zones(i).centerInZone(j) = 1;
        else
            trial.zones(i).centerInZone(j) = 0;
        end
        
    end
    
%     for j=1:length(trial.position.head)
%         if trial.zones(i).mask(trial.position.head(j,2),trial.position.head(j,1)) ~= 0
%             trial.zones(i).headInZone(j) = 1;
%         else
%             trial.zones(i).headInZone(j) = 0;
%         end
%     end    
        
end

%time in zone
for i=1:length(trial.zones)
    trial.zones(i).timeCenterInZone = sum(trial.zones(i).centerInZone)./trial.sampleRate;
%     trial.zones(i).timeHeadInZone = sum(trial.zones(i).headInZone)./trial.sampleRate;
end

%entries to zone
for i=1:length(trial.zones)
    
    trial.zones(i).centerEntries = 0;
    for j=2:length(trial.zones(i).centerInZone)
        if trial.zones(i).centerInZone(j-1) == 0 && trial.zones(i).centerInZone(j) == 1
           trial.zones(i).centerEntries = trial.zones(i).centerEntries + 1;
        end
    end
    
%     trial.zones(i).headEntries = 0;
%     for j=2:length(trial.zones(i).headInZone)
%         if trial.zones(i).headInZone(j-1) == 0 && trial.zones(i).headInZone(j) == 1
%            trial.zones(i).headEntries = trial.zones(i).headEntries + 1;
%         end
%     end
    
end

%distance
trial.distance = [];
for i=2:length(trial.position.center)  
    trial.distance.raw(i) = (pdist2(trial.position.center(i-1,:),trial.position.center(i,:)))*trial.ruler.lengthPerPixel; 
    trial.distance.speed(i) = abs(trial.distance.raw(i) - trial.distance.raw(i-1))*trial.sampleRate;
    trial.distance.cumulative(i) = sum(trial.distance.raw);
end

trial.distance.total = sum(trial.distance.raw);













        
        