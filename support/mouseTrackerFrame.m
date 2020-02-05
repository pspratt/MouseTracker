function trackedFrame = mouseTrackerFrame(rgbFrame, backgroundFrame,bodyThresh,tailThresh,tailFilter)


%Set Basic Variables
% bodyThresh = 0.3;
% tailThresh = 0.3;
% tailFilter = 9;

%Initialize Variables
background = rgb2gray(backgroundFrame);

try
    %Get Current Frame
    grayframe = rgb2gray(rgbFrame);
    
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
    
    %Identify center location
    s = regionprops(bwlabel(center),diffFrame, 'weightedCentroid');
    c = [s.WeightedCentroid];
    xc = round(s(1).WeightedCentroid(1));
    yc = round(s(1).WeightedCentroid(2));
    
    %Record center location
    position.center(1) = xc;
    position.center(2) = size(grayframe(:,1),1) - yc;
    
    %Show center location in red
    trackedFrame = rgbFrame;
    
    trackedFrame(yc-5:yc+5,xc-5:xc+5,1) = 255;
    trackedFrame(yc-5:yc+5,xc-5:xc+5,2) = 0;
    trackedFrame(yc-5:yc+5,xc-5:xc+5,3) = 0;
    
%     %Identify tail and nose location
%     try
%         %Identify tail
%         t = bwdistgeodesic(body,xc,yc,'chessboard');
%         [maxt,indt] = max(t(:));
%         [yt xt] = ind2sub(size(t),indt);
%         
%         %Identify head
%         n = bwdistgeodesic(body,xt,yt,'chessboard');
%         [maxn,indn] = max(n(:));
%         [yh xh] = ind2sub(size(n),indn);
%         
%         %Record tail and head location
%         position.tail(1) = xt;
%         position.tail(2) = size(grayframe(:,1),1) - yt;
%         position.head(1) = xh;
%         position.head(2) = size(grayframe(:,1),1) - yh;
%         
%         %Show tail location in green
%         trackedFrame(yt-5:yt+5,xt-5:xt+5,1) = 0;
%         trackedFrame(yt-5:yt+5,xt-5:xt+5,2) = 255;
%         trackedFrame(yt-5:yt+5,xt-5:xt+5,3) = 0;
%         
%         %Show nose location in blue
%         trackedFrame(yh-5:yh+5,xh-5:xh+5,1) = 0;
%         trackedFrame(yh-5:yh+5,xh-5:xh+5,2) = 0;
%         trackedFrame(yh-5:yh+5,xh-5:xh+5,3) = 255;
%     catch
%         position.tail(1) = NaN;
%         position.tail(2) = NaN;
%         position.head(1) = NaN;
%         position.head(2) = NaN;
%         
%     end
    
    trackedFrame = im2uint8(trackedFrame);
catch 
    position.center(1) = NaN;
    position.center(2) = NaN;
    position.tail(1) = NaN;
    position.tail(2) = NaN;
    position.head(1) = NaN;
    position.head(2) = NaN;
    trackedFrame = rgbFrame;
end










