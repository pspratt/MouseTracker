function trial = mouseTracker(trial,bodyThresh,tailThresh,tailFilter)

%Set Basic Variables
sampleRate = trial.sampleRate;

if nargin ~= 4
    bodyThresh = 0.3;
    tailThresh = 0.3;
    tailFilter = 9;
end

%Start Video Reader
videoReader = VideoReader(trial.videoPath);

%Pull basic vieo information
name = trial.name;
numFrames = videoReader.NumberOfFrames;
readerFrameRate = videoReader.FrameRate;
height = videoReader.Height;
width = videoReader.Width;


%Caculate frame information
startFrame = trial.startframe;
stopFrame = trial.startframe+(trial.recordTime*readerFrameRate);
stepSize = round(readerFrameRate/sampleRate);
writerFrameRate = readerFrameRate/stepSize;
trial.sampleRate = writerFrameRate;

%Start Video Writer
videoWriter = VideoWriter(['Tracked ' name],'Motion JPEG AVI');
videoWriter.FrameRate = writerFrameRate;

%Initialize Variables
if isempty(trial.exclusionMask)
background = rgb2gray(read(videoReader,trial.background));
else
background = rgb2gray(read(videoReader,trial.background)).*uint8(trial.exclusionMask);
end

trial.time = zeros(ceil(numFrames/stepSize),1);
trial.position.center = zeros(ceil(numFrames/stepSize),2);
% trial.position.tail = zeros(ceil(numFrames/stepSize),2);
% trial.position.head = zeros(ceil(numFrames/stepSize),2);
trial.heatMap = zeros(height,width);

nFrames = 1;

open(videoWriter);

% tailflip = 0;

h = waitbar(0,['Tracking ' name]);
for i=startFrame:stepSize:stopFrame
    try
        %Get Current Frame
        rgbframe = read(videoReader,i);
        if isempty(trial.exclusionMask)
            grayframe = rgb2gray(rgbframe);
        else
            grayframe = rgb2gray(rgbframe).*uint8(trial.exclusionMask);
        end
        
        %Remove Background
        invFrame = 255-grayframe;
        invBackground = 255 - background;
        diffFrame = invFrame-invBackground;
        
        %Identify entire mouse outline
        binBody = im2bw(diffFrame, tailThresh);
        body =  bwareaopen(binBody, 20, 8);
        body = imfill(body,'holes');
        
        %Identify mouse core
        diffFrameFilt = medfilt2(diffFrame, [tailFilter tailFilter]);%Filter out the tail
        binCenter= im2bw(diffFrameFilt, bodyThresh);
        center = bwareaopen(binCenter, 20, 8);
        center = imfill(center,'holes');
        
        %Save core heatMap
        trial.heatMap = trial.heatMap + (binCenter/sampleRate);
        
        %Record Time
        trial.time(nFrames,1) = i/videoReader.FrameRate - startFrame/videoReader.FrameRate;
        
        %Identify center location
        s = regionprops(bwlabel(center),diffFrame, 'weightedCentroid');
        c = [s.WeightedCentroid];
        xc = round(s(1).WeightedCentroid(1));
        yc = round(s(1).WeightedCentroid(2));
        
        %Record center location
        trial.position.center(nFrames,1) = xc;
        trial.position.center(nFrames,2) =  yc;
        
        %Show center location in red
        rgbframe(yc-5:yc+5,xc-5:xc+5,1) = 255;
        rgbframe(yc-5:yc+5,xc-5:xc+5,2) = 0;
        rgbframe(yc-5:yc+5,xc-5:xc+5,3) = 0;
        
        
        
    catch %if mouseTracker fails to find position, use last known position
        disp(['COULD NOT IDENTIFY BODY IN FRAME ' num2str(i-startFrame) ' OF ' name]);
        
        if nFrames > 1
            %Use position from last frame
            trial.position.center(nFrames,1) = trial.position.center(nFrames-1,1);
            trial.position.center(nFrames,2) =  trial.position.center(nFrames-1,2);

            %Show center location in red
            rgbframe(trial.position.center(nFrames-1,2)-5:trial.position.center(nFrames-1,2)+5,trial.position.center(nFrames-1,1)-5:trial.position.center(nFrames-1,1)+5,1) = 255;
            rgbframe(trial.position.center(nFrames-1,2)-5:trial.position.center(nFrames-1,2)+5,trial.position.center(nFrames-1,1)-5:trial.position.center(nFrames-1,1)+5,2) = 0;
            rgbframe(trial.position.center(nFrames-1,2)-5:trial.position.center(nFrames-1,2)+5,trial.position.center(nFrames-1,1)-5:trial.position.center(nFrames-1,1)+5,3) = 0;            
        end
    end
    
    %Add zones    
        for j=1:length(trial.zones)
            
            zone = trial.zones(j).pos';
            
            if trial.zones(j).mask(trial.position.center(nFrames,2),trial.position.center(nFrames,1)) ~= 0
                rgbframe = insertShape(rgbframe, 'polygon', zone(:)','color', trial.zones(j).color);
            else
                rgbframe = insertShape(rgbframe, 'filledpolygon', zone(:)','color', trial.zones(j).color,'opacity',.5);
            end          
        end   
           
        %Output Video
        frameSize = size(rgbframe);
        if frameSize(1) == height && frameSize(2) == width
            writeVideo(videoWriter,rgbframe); %Original frame
        end
        
        nFrames = nFrames + 1;
    
    
    
    
    waitbar((i-startFrame)./(stopFrame-startFrame));
end

close(videoWriter);
close(h);

nFrames = nFrames - 1;
trial.time = trial.time(1:nFrames,:);
trial.position.center = trial.position.center(1:nFrames,:); %get ride of the extra zeros
% trial.position.tail = trial.position.tail(1:nFrames,:);
% trial.position.head = trial.position.head(1:nFrames,:);

trial = inZoneAnalysis(trial);

save([trial.name ' ' trial.mazeType ' Trial.mat'], '-struct', 'trial');

end




%% Code for future use

%Identify tail and nose location WARNING ? Does NOT WORK 100%
%         try            
%             %Identify Tail
%             t = bwdistgeodesic(body,xc,yc,'chessboard');
%             [maxt,indt] = max(t(:));
%             [yt xt] = ind2sub(size(t),indt);
%             
%             %Identify head
%             n = bwdistgeodesic(body,xt,yt,'chessboard');
%             [maxn,indn] = max(n(:));
%             [yh xh] = ind2sub(size(n),indn);
%             
%             % check if the head and tail switched locations
%             
%             trial.position.tail(nFrames,1) = xt;
%             trial.position.tail(nFrames,2) = yt;
%             trial.position.head(nFrames,1) = xh;
%             trial.position.head(nFrames,2) = yh;
%             
%             if nFrames > 1
%                 %compare if the distance from the head is less than the
%                 %distance from the tail and vice versa
%                 
%                 if (pdist2([yh xh],[trial.position.head(nFrames-1,2)  trial.position.head(nFrames-1,1)])...
%                         > pdist2([yt xt],[trial.position.head(nFrames-1,2)  trial.position.head(nFrames-1,1)])...
%                         || pdist2([yt xt],[trial.position.tail(nFrames-1,2)  trial.position.tail(nFrames-1,1)])...
%                          >pdist2([yh xh],[trial.position.tail(nFrames-1,2)  trial.position.tail(nFrames-1,1)])) ... if either the head or tail flip
%                         && pdist2([yh xh],[trial.position.tail(nFrames-1,2)  trial.position.tail(nFrames-1,1)]) < 50 ...
%                         && tailflip < sampleRate;
% %                         
%                         tailflip = tailflip + 1;
%                     
%                     trial.position.tail(nFrames,1) = xh;
%                     trial.position.tail(nFrames,2) = yh;
%                     trial.position.head(nFrames,1) = xt;
%                     trial.position.head(nFrames,2) = yt;
%                     
%                 else
%                     
%                     tailflip = 0;
%                     
%                 end
%                 
%             end
            
            %Show tail location in green
%             rgbframe(trial.position.tail(nFrames,2)-5:trial.position.tail(nFrames,2)+5,trial.position.tail(nFrames,1)-5:trial.position.tail(nFrames,1)+5,1) = 0;
%             rgbframe(trial.position.tail(nFrames,2)-5:trial.position.tail(nFrames,2)+5,trial.position.tail(nFrames,1)-5:trial.position.tail(nFrames,1)+5,2) = 255;
%             rgbframe(trial.position.tail(nFrames,2)-5:trial.position.tail(nFrames,2)+5,trial.position.tail(nFrames,1)-5:trial.position.tail(nFrames,1)+5,3) = 0;
            
            %Show nose location in blue
%             rgbframe(trial.position.head(nFrames,2)-5:trial.position.head(nFrames,2)+5,trial.position.head(nFrames,1)-5:trial.position.head(nFrames,1)+5,1) = 0;
%             rgbframe(trial.position.head(nFrames,2)-5:trial.position.head(nFrames,2)+5,trial.position.head(nFrames,1)-5:trial.position.head(nFrames,1)+5,2) = 0;
% %             rgbframe(trial.position.head(nFrames,2)-5:trial.position.head(nFrames,2)+5,trial.position.head(nFrames,1)-5:trial.position.head(nFrames,1)+5,3) = 255;
%         catch
%             disp(['COULD NOT IDENTIFY HEAD OR TAIL IN FRAME ' num2str(i-startFrame) ' OF ' name]);
%         end
%         


