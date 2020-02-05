function [body,center] = backgroundThreshold(rgbFrame,backgroundFrame,bodyThresh,tailThresh,tailFilter)


background = rgb2gray(backgroundFrame);

grayframe = rgb2gray(rgbFrame);

%Remove Background
invFrame = 255-grayframe;
invBackground = 255 - background;
diffFrame = invFrame-invBackground;

%Identify entire mouse outline
binBody = im2bw(diffFrame, tailThresh);
body =  bwareaopen(binBody, 20, 8);
body = imfill(body,'holes')*255;

%Identify mouse core
diffFrameFilt = medfilt2(diffFrame, [tailFilter tailFilter]);%Filter out the tail
binCenter= im2bw(diffFrameFilt, bodyThresh);
center = bwareaopen(binCenter, 20, 8);
center = imfill(center,'holes')*255;