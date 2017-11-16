function mouseTrackerDemo(trial)

% structure from mouseTrackerGUI
% handles.trial(i).name = files(i).name;
%     handles.trial(i).date = [];
%     handles.trial(i).time = [];
%     handles.trial(i).testType = [];
%     handles.trial(i).videoPath = fullfile(pwd,files(i).name);
%     handles.trial(i).sampleRate = 10;
%     handles.trial(i).background = 1;
%     handles.trial(i).recordTime = 600;
%     handles.trial(i).startframe = 1;
%     handles.trial(i).zonesEPM = defaultEMPzones;
%     handles.trial(i).zonesOF = [];
%     handles.trial(i).exclusionMask = [];




%Set Basic Variables
sampleRate = 30;
bodyThresh = 0.3;
tailThresh = 0.3;
tailFilter = 9;

%Start Video Reader
videoReader = VideoReader(trial.videoPath);

%Pull basic vieo information
name = videoReader.Name;
numFrames = videoReader.NumberOfFrames;
readerFrameRate = videoReader.FrameRate;
height = videoReader.Height;
width = videoReader.Width;


%Caculate frame information
startFrame = round(trial.startframe*readerFrameRate);
stopFrame = round((trial.startframe+60)*readerFrameRate);
stepSize = round(readerFrameRate/sampleRate);
writerFrameRate = readerFrameRate/stepSize;

%Start Video Writer
videoWriter = VideoWriter(['Demo ' name],'Motion JPEG AVI');
videoWriter.FrameRate = writerFrameRate;

%Initialize Variables
if isempty(trial.exclusionMask)
background = rgb2gray(read(videoReader,trial.background));
else
background = rgb2gray(read(videoReader,trial.background)).*uint8(trial.exclusionMask);
end



trial.time = zeros(ceil(numFrames/stepSize),1);
trial.position.center = zeros(ceil(numFrames/stepSize),2);
trial.position.tail = zeros(ceil(numFrames/stepSize),2);
trial.position.head = zeros(ceil(numFrames/stepSize),2);
trial.heatMap = zeros(height,width);

nFrames = 1;

open(videoWriter);

tailflip = 0;

disp(['Beginning tracking of ' name]); 
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
        
        trackedrgbframe = rgbframe;
        %Show center location in red
        trackedrgbframe(yc-5:yc+5,xc-5:xc+5,1) = 255;
        trackedrgbframe(yc-5:yc+5,xc-5:xc+5,2) = 0;
        trackedrgbframe(yc-5:yc+5,xc-5:xc+5,3) = 0;
        
        %Identify tail and nose location
        try
            
            %Identify Tail
            t = bwdistgeodesic(body,xc,yc,'chessboard');
            [maxt,indt] = max(t(:));
            [yt xt] = ind2sub(size(t),indt);
            
            %Identify head
            h = bwdistgeodesic(body,xt,yt,'chessboard');
            [maxn,indn] = max(h(:));
            [yh xh] = ind2sub(size(h),indn);
            
            % check if the head and tail switched locations
            
            trial.position.tail(nFrames,1) = xt;
            trial.position.tail(nFrames,2) = yt;
            trial.position.head(nFrames,1) = xh;
            trial.position.head(nFrames,2) = yh;
            
            if nFrames > 1
                %compare if the distance from the head is less than the
                %distance from the tail and vice versa
                
                if (pdist2([yh xh],[trial.position.head(nFrames-1,2)  trial.position.head(nFrames-1,1)])...
                        > pdist2([yt xt],[trial.position.head(nFrames-1,2)  trial.position.head(nFrames-1,1)])...
                        || pdist2([yt xt],[trial.position.tail(nFrames-1,2)  trial.position.tail(nFrames-1,1)])...
                         >pdist2([yh xh],[trial.position.tail(nFrames-1,2)  trial.position.tail(nFrames-1,1)])) ... if either the head or tail flip
                        && pdist2([yh xh],[trial.position.tail(nFrames-1,2)  trial.position.tail(nFrames-1,1)]) < 50 ... if the head and tail move by more than 50px
                        && tailflip < sampleRate;...the tail isn't flipped continuously for 1 second 
%                         
                        tailflip = tailflip + 1;
                    
                    trial.position.tail(nFrames,1) = xh;
                    trial.position.tail(nFrames,2) = yh;
                    trial.position.head(nFrames,1) = xt;
                    trial.position.head(nFrames,2) = yt;
                    
                else
                    
                    tailflip = 0;
                    
                end
                
            end
            
            %Show tail location in green
            trackedrgbframe(trial.position.tail(nFrames,2)-5:trial.position.tail(nFrames,2)+5,trial.position.tail(nFrames,1)-5:trial.position.tail(nFrames,1)+5,1) = 0;
            trackedrgbframe(trial.position.tail(nFrames,2)-5:trial.position.tail(nFrames,2)+5,trial.position.tail(nFrames,1)-5:trial.position.tail(nFrames,1)+5,2) = 255;
            trackedrgbframe(trial.position.tail(nFrames,2)-5:trial.position.tail(nFrames,2)+5,trial.position.tail(nFrames,1)-5:trial.position.tail(nFrames,1)+5,3) = 0;
            
            %Show nose location in blue
            trackedrgbframe(trial.position.head(nFrames,2)-5:trial.position.head(nFrames,2)+5,trial.position.head(nFrames,1)-5:trial.position.head(nFrames,1)+5,1) = 0;
            trackedrgbframe(trial.position.head(nFrames,2)-5:trial.position.head(nFrames,2)+5,trial.position.head(nFrames,1)-5:trial.position.head(nFrames,1)+5,2) = 0;
            trackedrgbframe(trial.position.head(nFrames,2)-5:trial.position.head(nFrames,2)+5,trial.position.head(nFrames,1)-5:trial.position.head(nFrames,1)+5,3) = 255;
        catch
            disp(['COULD NOT IDENTIFY HEAD OR TAIL IN FRAME ' num2str(i-startFrame) ' OF ' name]);
        end
        
        trackedzonedrgbframe = trackedrgbframe;
        %Add zones    
        for j=1:length(trial.zones)
            
            test = trial.zones(j).pos';
            
            if trial.zones(j).mask(trial.position.center(nFrames,2),trial.position.center(nFrames,1)) ~= 0
                trackedzonedrgbframe = insertShape(trackedzonedrgbframe, 'polygon', test(:)','color', trial.zones(j).color);
            else
                trackedzonedrgbframe = insertShape(trackedzonedrgbframe, 'filledpolygon', test(:)','color', trial.zones(j).color,'opacity',.5);
            end
            
            
            
        end
        
        
               
        %Output Video
        frameSize = size(rgbframe);
        if frameSize(1) == height && frameSize(2) == width
            
            if nFrames/sampleRate < 5
                %RGB
                writeVideo(videoWriter,rgbframe);
                
            elseif nFrames/sampleRate < 10
                %grey
                writeVideo(videoWriter,invFrame);
            elseif nFrames/sampleRate < 15
                %background subtraction
                writeVideo(videoWriter,diffFrame);
                
            elseif nFrames/sampleRate < 20
                %thresholded
                writeVideo(videoWriter,uint8(body*255));
                
            elseif nFrames/sampleRate < 25
                %Find tail
                writeVideo(videoWriter,uint8(t/max(t(:))*255));
            elseif nFrames/sampleRate < 30
                %find head
                writeVideo(videoWriter,uint8(h/max(h(:))*255));
            elseif nFrames/sampleRate < 35
                %tracked rgb
                writeVideo(videoWriter,trackedrgbframe);
                
            else
                %zones
                writeVideo(videoWriter,trackedzonedrgbframe); %Original frame
            end
            
        end
        
        %Display Stage of Processing
        if mod(nFrames,100) == 0
            disp([name ' Frame ' num2str(nFrames) ' of ' num2str((stopFrame-startFrame)/stepSize)]);
        end
        
        nFrames = nFrames + 1;
    catch
            disp(['COULD NOT IDENTIFY BODY IN FRAME ' num2str(i-startFrame) ' OF ' name]);
    end
end

close(videoWriter);

end





