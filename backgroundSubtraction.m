function diffFrame = backgroundSubtraction(rgbFrame, backgroundFrame)

background = rgb2gray(backgroundFrame);

grayframe = rgb2gray(rgbFrame);
    
%Remove Background
invFrame = 255-grayframe;
invBackground = 255 - background;
diffFrame = invFrame-invBackground;
