# mouseTracker User Guide:
## Overview 
mouseTracker is a rodent tracking program that uses background subtraction to track the XY pixel coordinates of a mouse (or any moving object) over the course of a video. This is achieved by specifying a background frame, subtracting each frame by the background frame, and then identifying the center of the largest group of pixels that significantly vary from the background.

On top of this core functionality, mouseTracker allows for the setting of zones within the video and for identifying what times the animal is in the zone, total time in the zone, and number of entries to the zone. Currently only elevated plus maze, open field, and three chamber social zones are supported. Cumulative distance and speed over time are also calculated.

![GUI](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/GUI%20example.png)

### Selecting Video Files to Track
![save](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/Save%20dialog.png)
* Select Load Video Files button to launch a file picker window to select video files
*	This file picker differs from standard file pickers, but it has many features that makes it more powerful (see here for full details)
*	Navigate to the video files in the left hand pane and select videos you want to track by double clicking or by highlighting them and pressing the Add→ button
  *	This is made easier by setting the folder containing the videos as the Current Folder in matlab
*	Selected files can then be rearranged or removed from the right hand pane. 
*	Once you have chosen all the files to be tracked selecte Done
*	The first video should load in the user interface

__Supported file types:__
*	Windows 
  * .wmv – RECOMMENDED
  * .avi (varies depending on encoding used)
*	OSX
  * .mov – slow, but works
  *	.avi (varies depending on encoding used)

### Video Navigation
![save](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/Video%20Navigation.png)

Moving forward and backward in the video
*	Pressing “1 Second Forward” will move the video forward 1 second
*	Pressing “1 Second Back” will move the video back 1 second
*	Selecting the textbox beneath the video allows for specifying which second of the video you wish to view
Changing Videos
*	Pressing “next video” will load the next video file
*	Pressing “previous video” will load the previous video file
*	Selecting the textbox above the video allows for specifying which video you wish to view
*	Note that videos are listed in the order specified by the file picker 



### Specifying tracker settings 
![save](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/tracker%20settings.png)

**Viewing images used by the tracker**
*	Pressing Show Color shows the original RGB image from the video with a red square over where mouseTracker thinks the mouse is
*	Pressing Show Subtraction shows the inverted, background subtracted image (based on the specified background frame)
*	Pressing Show Threshold Shows all pixels above the tracker threshold
  *	The largest group of pixels is what mouseTracker tracks

![save](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/Raw%20video.png)

![save](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/Subtracked%20video.png)

![save](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/threshold%20video.png)

**Specifying a background frame** 
*	Pressing Set Background will set the currently visible frame as the frame used for background subtraction 
*	Alternatively, a specific specific time can be specified by editing the text box
*	The background should be identical to all of the frames to be tracked, minus the mouse
Specifying background frame
*	Pressing Set Start Frame will set the currently visible frame as the first frame for mouse tracking
*	Alternatively, a specific start time can be specified by editing the text box
Excluding regions from being tracked
*	Pressing Set Exclusion Mask allows for removing a section of the image from all frames in the video
  *	Click on the image to form a polygon around the region that you would like to cut out
  *	The mask can be saved by double clicking the center of the polygon
  *	You will then be prompted to apply this mask to only this video, all future videos, or all videos
  *	The mask can be undone by selecting “set exclusion mask” again and clicking multiple times on a single point in the image

![save](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/exclusion%20mask%20designation.png)
![save](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/exclusion%20mask%20appilcation.png) 

*	Pressing “set inclusion mask” functions similarly to “set exclusion mask”, but it has the opposite effect
  *	Only parts of the image within the polygon will be available to track.
![save](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/inclusion%20mask%20designation.png)
![save](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/inclusion%20mask%20application.png)

**Specifying Tracker Threshold**
*	Edit the text box beside Tracker Threshold to a value of between 0 and 1 such that only the outline of the mouse is visible when Show Threshold is selected
  *	This changes the threshold for identifying which pixels have changed significantly
Specifying Median Filter Size
*	Edit the text box beside Median Filter Size to filter out the mouse tail and edges of the aparatus that may shift slightly
 

### Setting Zones
![](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/zone%20settings.png)

**Specifying maze type**
*	Select the radio button in the Maze Type panel for the type of maze is being used 
Viewing Zones
*	Select Yes in the Overlay Zone menu
Editing Zones
*	Select Edit Zones to launch the zone editing interface
*	Click and drag the center of the zones to move them around
*	Click and drag the corners to resize the zones
*	Double click the yellow zone (or the center for open field) to save the zones
*	You will be asked if you want to change the zones for just this video, all videos, or all future videos

![](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/zone%20GUI.png)


**Editing Ruler**
*	Select Edit Ruler to launch the ruler editing interface
*	Click and drag the ruler to change its position
*	Click and drag the corners to resize the ruler
*	Specify the ruler length in centimeters in the text box
*	You will be asked if you want to change the ruler for just this video, all videos, or all future videos
*	Accurate ruler placement is essential for measuring distance traveled and specifying the center box in the open field maze

![](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/recording%20parameters.png)


### Setting Recording Parameters:
![](https://github.com/pspratt/MouseTracker/blob/master/Docs/graphics/Ruler%20editor.png)
*	Edit the text beside Recording Time (sec) to specify the amount of time to record in seconds
*	Edit the text beside Sample Rate (/sec)  to specify the sample rate for tracking
  *	Lower sample rates will track faster, but be less precise
  *	Make sure the sample rate evenly divides into the frame rate of the video, otherwise the sample rate will be changed to make the frames all the same size

### Tracking the videos
*	Select Start Tracking to begin tracking the videos
*	This will close the user interface and launch a wait bar that shows the progress of tracking of the current video
*	Files generated
  *	.mat file (tracking data, 1 per video file)
  *	.avi file (video with the tracking information added to it, 1 per video file)
  *	.csv file (aggregate tracking information, 1 per batch of videos)

### Data Analysis:
Basic tracking information can be found in the .csv file. If you wish to generate a .csv summary file for trials in different tracking sessions, call behaviorTrial2csv from the command line and select the .mat files you wish to aggregate.

All of the tracking data generated by mouseTracker can be found in the .mat files. The contents of the .mat file can be analyzed by loading it into matlab. 

**Fields include:**
*	Background – index of frame used for the background
*	Distance 
  *	Raw – distance traveled between each frame 
  *	Speed – speed of travel at each frame
  *	Cumulative – total distance traveled up to each frame
  *	Total – total distance traveled over the recording
*	exclusionMask – mask used to exclude regions from tracking
*	heatMap – a matrix that has the same dimensions as the video. Values are the number of seconds the mouse’s body was in each pixel
*	mazeType – Type of maze selected
*	name – name of the video
*	position
  *	center – The xy coordinates of the center of the mouse’s body
*	recordTime – number of seconds recorded
*	ruler
  *	pos – Coordinates of the ruler
  *	length – Length of the ruler in cm
  *	lengthPerPixel – length of each pixel in the video 
* sampleRate – Recording sample rate
*	startframe – index of the start frame
*	time – times of each frame
*	videoPath – File path to the recorded video
*	zones
  *	name – name of zone
  *	pos – coordinates of zone
  *	color – color of the zone
  *	mask – mask used to determine which pixels are within the zone
  *	centerInZone – frames in which the center of the mouse is within the zone
  *	timeCenterInZone – cumulative time mouse was in the zone
  *	CenterEntries – number of entries to the zone









### Known Issues and Limitations
*	The videoReader function used by matlab is very picky about file types and can crash if the wrong ones are used. Therefore, I recommend using .wmv files whenever possible
*	Even if the correct file formats are used, videoReader can get stuck when loading a file. This can be temporarily resolved by pressing control+c from the command window. If the issue persists, restart matlab
*	Maze types are limited. The way I have programmed the zone features requires default zones to be specified within the source code. I hope to change this at some point in the future to make the program more flexible
