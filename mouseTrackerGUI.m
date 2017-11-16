function varargout = mouseTrackerGUI(varargin)
%%% 5 MOUSETRACKERGUI MATLAB code for mouseTrackerGUI.fig
%      MOUSETRACKERGUI, by itself, creates a new MOUSETRACKERGUI or raises the existing
%      singleton*.
%
%      H = MOUSETRACKERGUI returns the handle to a new MOUSETRACKERGUI or the handle to
%      the existing singleton*.
%
%      MOUSETRACKERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOUSETRACKERGUI.M with the given input arguments.
%
%      MOUSETRACKERGUI('Property','Value',...) creates a new MOUSETRACKERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mouseTrackerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mouseTrackerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mouseTrackerGUI

% Last Modified by GUIDE v2.5 16-Sep-2016 12:40:03

%%%%%%%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mouseTrackerGUI_OpeningFcn, ...
    'gui_OutputFcn',  @mouseTrackerGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT




















%% --- Executes just before mouseTrackerGUI is made visible.
function mouseTrackerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mouseTrackerGUI (see VARARGIN)

%Set the value of all of the edit strings
set(handles.startFrameText,'String','');
set(handles.edit_backgroundFrameText,'String','');
set(handles.edit_currentFrameText,'String','');
set(handles.edit_setBodyThreshold,'String','0.3');
set(handles.edit_setTailThreshold,'String','0.3');
set(handles.edit_setTailFilter,'String','9');
set(handles.edit_recordTime,'String','600');
set(handles.edit_sampleRate,'String','15');

% Choose default command line output for mouseTrackerGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes mouseTrackerGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mouseTrackerGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




%% Buttons
% --- Executes on button press in button_previousVideo.
function button_previousVideo_Callback(hObject, eventdata, handles)
% hObject    handle to button_previousVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.currentFile ~= 1
    handles.currentFile = handles.currentFile-1;
    handles = initializeNewVideo(hObject, eventdata, handles);
end

guidata(hObject, handles);

% --- Executes on button press in button_nextVideo.
function button_nextVideo_Callback(hObject, eventdata, handles)
% hObject    handle to button_nextVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.currentFile ~= length(handles.trials)
    handles.currentFile = handles.currentFile+1;
    handles = initializeNewVideo(hObject, eventdata, handles);
end

guidata(hObject, handles);

% --- Executes on button press in button_setstartframe.
function button_setStartFrame_Callback(hObject, eventdata, handles)
% hObject    handle to button_setstartframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.trials(handles.currentFile).startframe = round(handles.currentFrame);
set(handles.startFrameText, 'String', num2str((handles.trials(handles.currentFile).startframe-1)./round(handles.videoReader.FrameRate)));

guidata(hObject, handles);

% --- Executes on button press in button_setBackground.
function button_setBackground_Callback(hObject, eventdata, handles)
% hObject    handle to button_setBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.trials(handles.currentFile).background = round(handles.currentFrame);
set(handles.edit_backgroundFrameText, 'String', num2str((handles.trials(handles.currentFile).background-1)./round(handles.videoReader.FrameRate)));

handles = updateFrame(hObject, eventdata, handles);

guidata(hObject, handles);

% --- Executes on button press in button_back.
function button_back_Callback(hObject, eventdata, handles)
% hObject    handle to button_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.currentFrame- handles.videoReader.FrameRate > 1
    
    handles.currentFrame = handles.currentFrame - round(handles.videoReader.FrameRate);
    
    handles = updateFrame(hObject, eventdata, handles);
    set(handles.edit_currentFrameText,'String', num2str((handles.currentFrame-1)./round(handles.videoReader.FrameRate)));
    
end

guidata(hObject, handles);

% --- Executes on button press in button_forward.
function button_forward_Callback(hObject, eventdata, handles)
% hObject    handle to button_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if handles.currentFrame+handles.videoReader.FrameRate < handles.videoReader.NumberOfFrames;
    
    handles.currentFrame = handles.currentFrame + round(handles.videoReader.FrameRate);
    handles = updateFrame(hObject, eventdata, handles);
    set(handles.edit_currentFrameText,'String', num2str((handles.currentFrame -1)./round(handles.videoReader.FrameRate)));
    
end

guidata(hObject, handles);

% --- Executes on button press in button_showRGB.
function button_showRGB_Callback(hObject, eventdata, handles)
% hObject    handle to button_showRGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.displayType = 1;
updateFrame(hObject, eventdata, handles);

guidata(hObject, handles);




% --- Executes on button press in button_showBackSub.
function button_showBackSub_Callback(hObject, eventdata, handles)
% hObject    handle to button_showBackSub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.displayType = 2;
updateFrame(hObject, eventdata, handles);

guidata(hObject, handles);

% --- Executes on button press in button_showTailThresh.
function button_showTailThresh_Callback(hObject, eventdata, handles)
% hObject    handle to button_showTailThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.displayType = 3;
updateFrame(hObject, eventdata, handles);

guidata(hObject, handles);


% --- Executes on button press in button_showBodyThresh.
function button_showBodyThresh_Callback(hObject, eventdata, handles)
% hObject    handle to button_showBodyThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.displayType = 4;
updateFrame(hObject, eventdata, handles);

guidata(hObject, handles);

















% --- Executes when selected object is changed in uipanel_overlayZones.
function uipanel_overlayZones_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_overlayZones 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

%Set the value of handles.zoneOverlay if uipanel selection changes
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radio_overlayYes'
        handles.zoneOverlay = 1;
    case 'radio_overlayNo'
        handles.zoneOverlay = 0;
end
handles = updateFrame(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes when selected object is changed in uipanel_setMazeType.
function uipanel_setMazeType_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_setMazeType
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radio_setEPM'
        handles.mazeType = 'EPM';
        handles = defaultEPMzones(hObject, eventdata, handles);
    case 'radio_setOF'
        handles.mazeType = 'OF';
       handles = defaultOFzones(hObject, eventdata, handles);
    case 'radio_setSocial'
        handles.mazeType = 'Social';
       handles = defaultSocialZones(hObject, eventdata, handles);
end
handles = updateFrame(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes on button press in button_editZones.
function button_editZones_Callback(hObject, eventdata, handles)
% hObject    handle to button_editZones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Remove Overlays if present
temp = handles.zoneOverlay;
handles.zoneOverlay = 0;
handles = updateFrame(hObject, eventdata, handles);

switch handles.mazeType
    case 'EPM'
        zones = setEPMZones(hObject, eventdata, handles);
    case 'OF'
       zones  = setOFZones(hObject, eventdata, handles);
    case 'Social'
        zones = setEPMZones(hObject, eventdata, handles);
end

% Construct a questdlg with three options
choice = questdlg('Which videos would you like to set zones for?', ...
    'Set Zones', ...
    'All Videos','This+Future Videos','This Video','This Video');
% Handle response
switch choice
    case 'All Videos'
        for i=1:length(handles.trials)
            handles.trials(i).zones = zones;
        end
    case 'This+Future Videos'
        for i=handles.currentFile:length(handles.trials)
            handles.trials(i).zones = zones;
        end
    case 'This Video'
        handles.trials(handles.currentFile).zones = zones;
end
handles.zoneOverlay = temp;
handles = updateFrame(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes on button press in button_editRuler.
function button_editRuler_Callback(hObject, eventdata, handles)
% hObject    handle to button_editRuler (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Determine Ruler Position

displayImage = handles.currentVideo(handles.displayType).cData;

position = [7 5];
text = ['Click and hold ruler to move'];
displayImage = insertText(displayImage,position,text,'FontSize',12,'BoxColor','black','BoxOpacity',0.4,'TextColor','white');
handles.image = image(displayImage);

position = [7 450];
text = ['Double click ruler end point to save'];
displayImage = insertText(displayImage,position,text,'FontSize',12,'BoxColor','black','BoxOpacity',0.4,'TextColor','white');
handles.image = image(displayImage);


h = imline(gca,handles.trials(handles.currentFile).ruler.pos);
wait(h);
ruler.pos = h.getPosition;
ruler.pixelLength = pdist2(ruler.pos(1,:),ruler.pos(2,:));
% wait(h(end));
delete(h);

ruler.length = str2double(get(handles.edit_rulerLength,'String'));
ruler.lengthPerPixel = ruler.length/ruler.pixelLength;

% Construct a questdlg with three options
choice = questdlg('Which videos would you like to set the ruler for?', ...
    'Set Zones', ...
    'All Videos','This+Future Videos','This Video','This Video');
% Handle response
switch choice
    case 'All Videos'
        for i=1:length(handles.trials)
            handles.trials(i).ruler = ruler;
        end
    case 'This+Future Videos'
        for i=handles.currentFile:length(handles.trials)
            handles.trials(i).ruler = ruler;
        end
    case 'This Video'
        handles.trials(handles.currentFile).ruler = ruler;
end

handles = updateFrame(hObject, eventdata, handles);


guidata(hObject, handles);


% --- Executes on button press in button_setExclusionMask.
function button_setExclusionMask_Callback(hObject, eventdata, handles)
% hObject    handle to button_setExclusionMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = impoly(gca);

fcn = makeConstrainToRectFcn('impoly',get(gca,'XLim'),get(gca,'YLim'));
h.setPositionConstraintFcn(fcn);

wait(h);

choice = questdlg('Which videos would you like to set an exclusion zone for?', ...
    'Set Zones', ...
    'All Videos','This+Future Videos','This Video','This Video');
% Handle response
switch choice
    case 'All Videos'
        for i=1:length(handles.trials)
            handles.trials(i).exclusionMask = imcomplement(createMask(h,handles.image));
        end
    case 'This+Future Videos'
        for i=handles.currentFile:length(handles.trials)
            handles.trials(i).exclusionMask = imcomplement(createMask(h,handles.image));
        end
    case 'This Video'
        handles.trials(handles.currentFile).exclusionMask = imcomplement(createMask(h,handles.image));
end

delete(h);

handles = updateFrame(hObject, eventdata, handles);

guidata(hObject, handles);


% --- Executes on button press in button_setInclusionMask.
function button_setInclusionMask_Callback(hObject, eventdata, handles)
% hObject    handle to button_setInclusionMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = impoly(gca);

fcn = makeConstrainToRectFcn('impoly',get(gca,'XLim'),get(gca,'YLim'));
h.setPositionConstraintFcn(fcn);

wait(h);

choice = questdlg('Which videos would you like to set an exclusion zone for?', ...
    'Set Zones', ...
    'All Videos','This+Future Videos','This Video','This Video');
% Handle response
switch choice
    case 'All Videos'
        for i=1:length(handles.trials)
            handles.trials(i).exclusionMask = (createMask(h,handles.image));
        end
    case 'This+Future Videos'
        for i=handles.currentFile:length(handles.trials)
            handles.trials(i).exclusionMask = (createMask(h,handles.image));
        end
    case 'This Video'
        handles.trials(handles.currentFile).exclusionMask = (createMask(h,handles.image));
end

delete(h);

handles = updateFrame(hObject, eventdata, handles);

guidata(hObject, handles);










% --- Executes on button press in button_startTracking.
function button_startTracking_Callback(hObject, eventdata, handles)
% hObject    handle to button_startTracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

recordTime = str2double(get(handles.edit_recordTime,'String'));
sampleRate = str2double(get(handles.edit_sampleRate,'String'));
bodyThresh = str2double(get(handles.edit_setBodyThreshold,'string'));
tailThresh = str2double(get(handles.edit_setTailThreshold,'string'));
tailFilter = str2double(get(handles.edit_setTailFilter,'string'));

close(handles.figure1)

for i=1:length(handles.trials)
    handles.trials(i).recordTime = recordTime;
    handles.trials(i).sampleRate = sampleRate;
    trial = handles.trials(i);
    
%     save([trial.name ' ' trial.mazeType ' Trial.mat'], '-struct', 'trial');
    
end

for i=1:length(handles.trials)
    try
        handles.trials(i) = mouseTracker(handles.trials(i),bodyThresh,tailThresh,tailFilter);
    catch
        disp(['failed to track ' handles.trials(i).name]);
    end
end

behaviorTrial2csv(handles.trials);


% --- Executes on button press in button_saveTrials.
function button_saveTrials_Callback(hObject, eventdata, handles)
% hObject    handle to button_saveTrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warndlg({'This function currently is under construction'});
% close(handles.figure1)
% 
% for i=1:length(handles.trials)
%     try
%         trial = inZoneAnalysis(handles.trials(i));%update zone data if position data
%     catch
%         trial = handles.trials(i);
%     end
%     save([trial.name ' ' trial.mazeType ' Trial.mat'], '-struct', 'trial');
%     
% end

% --- Executes on button press in button_loadVideoFiles.
function button_loadVideoFiles_Callback(hObject, eventdata, handles)
% hObject    handle to button_loadVideoFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%check type of file
files = [];
% fmtList = VideoReader.getFileFormats();
% if any(ismember({fmtList.Extension},'mov'))
%     files = uipickfiles('FilterSpec','*.mov');
% elseif any(ismember({fmtList.Extension},'wmv'))
%     files = uipickfiles('FilterSpec','*.wmv');
% else
%     files = uipickfiles('FilterSpec','*.avi');
% end
% files = uipickfiles('FilterSpec','*.avi');
files = uipickfiles;

for i=1:length(files)
    handles.trials(i) = createNewTrial(files{i});
    handles.trials(i) = standardizeTrialFields(handles.trials(i));
end

if get(handles.radio_overlayYes,'value') == 1
    handles.zoneOverlay = 1;
else
    handles.zoneOverlay = 0;
end

handles.currentFile = 1;
handles.displayType = 1;
set(handles.text_totalVideos,'String',['out of ' num2str(length(handles.trials))]);
handles = initializeNewVideo(hObject, eventdata, handles);


if get(handles.radio_setEPM,'value') == 1
    handles.mazeType = 'EPM';
    handles = defaultEPMzones(hObject, eventdata, handles);
elseif get(handles.radio_setOF,'value') == 1
    handles.mazeType = 'OF';
    handles = defaultOFzones(hObject, eventdata, handles);
elseif get(handles.radio_setSocial,'value') == 1
    handles.mazeType = 'Social';  
    handles = defaultSocialZones(hObject, eventdata, handles);
end

if get(handles.radio_overlayYes,'value') == 1
    handles.zoneOverlay = 1;
else
    handles.zoneOverlay = 0;
end

handles = updateFrame(hObject, eventdata, handles);
  


guidata(hObject, handles);


% --- Executes on button press in button_loadMatFiles.
function button_loadMatFiles_Callback(hObject, eventdata, handles)
% hObject    handle to button_loadMatFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warndlg({'This function currently is under construction'});


% files = uipickfiles('FilterSpec','*.mat');
% for i=1:length(files)
%     trial =  load(files{i});
%     handles.trials(i) = standardizeTrialFields(trial);
% end
% handles.currentFile = 1;
% handles.displayType = 1;
% handles = initializeNewVideo(hObject, eventdata, handles);
% guidata(hObject, handles);





%% GUI Specific functions
function handles = initializeNewVideo(hObject, eventdata, handles)
%Set VideoReader
handles.videoReader = VideoReader(handles.trials(handles.currentFile).videoPath);
handles.currentFrame = 1;
handles = updateFrame(hObject, eventdata, handles);

set(handles.startFrameText, 'String', num2str((handles.trials(handles.currentFile).startframe-1)./round(handles.videoReader.FrameRate)));

set(handles.edit_backgroundFrameText, 'String', num2str((handles.trials(handles.currentFile).background-1)./round(handles.videoReader.FrameRate)));
set(handles.edit_currentFrameText,'String', num2str(handles.currentFrame - 1));

set(handles.edit_currentVideoText,'String',num2str(handles.currentFile));

guidata(hObject, handles);

function handles = updateFrame(hObject, eventdata, handles)

rgbFrame = read(handles.videoReader,handles.currentFrame);
backgroundFrame = read(handles.videoReader,handles.trials(handles.currentFile).background);
bodyThresh = str2double(get(handles.edit_setBodyThreshold,'String'));
tailThresh = str2double(get(handles.edit_setTailThreshold,'String'));
tailFilter = str2double(get(handles.edit_setTailFilter,'String'));

if isempty(handles.trials(handles.currentFile).exclusionMask)
    handles.currentVideo(1).cData = mouseTrackerFrame(rgbFrame,backgroundFrame,bodyThresh,tailThresh,tailFilter);
    handles.currentVideo(2).cData = backgroundSubtraction(rgbFrame,backgroundFrame);
    [handles.currentVideo(3).cData,handles.currentVideo(4).cData] = backgroundThreshold(rgbFrame,backgroundFrame,bodyThresh,tailThresh,tailFilter);
else
    %color with tracking
    rgbFrame (:,:,1) = rgbFrame(:,:,1) .* uint8(handles.trials(handles.currentFile).exclusionMask);
    rgbFrame (:,:,2) = rgbFrame(:,:,2) .* uint8(handles.trials(handles.currentFile).exclusionMask);
    rgbFrame (:,:,3) = rgbFrame(:,:,3) .* uint8(handles.trials(handles.currentFile).exclusionMask);
    backgroundFrame(:,:,1) = backgroundFrame(:,:,1).* uint8(handles.trials(handles.currentFile).exclusionMask);
    backgroundFrame(:,:,2) = backgroundFrame(:,:,2).* uint8(handles.trials(handles.currentFile).exclusionMask);
    backgroundFrame(:,:,3) = backgroundFrame(:,:,3).* uint8(handles.trials(handles.currentFile).exclusionMask);
    
    handles.currentVideo(1).cData = mouseTrackerFrame(rgbFrame,backgroundFrame,bodyThresh,tailThresh,tailFilter);
    handles.currentVideo(2).cData = backgroundSubtraction(rgbFrame,backgroundFrame);
    [handles.currentVideo(3).cData, handles.currentVideo(4).cData] = backgroundThreshold(rgbFrame,backgroundFrame,bodyThresh,tailThresh,tailFilter);
end

%overlay zone outlines if option is selected
if handles.zoneOverlay == 1
    for j=1:length(handles.trials(handles.currentFile).zones)
        zone = handles.trials(handles.currentFile).zones(j).pos';
        handles.currentVideo(1).cData = insertShape(handles.currentVideo(1).cData, 'polygon', zone(:)','color', handles.trials(handles.currentFile).zones(j).color);
    end
end

handles.image = image(handles.currentVideo(handles.displayType).cData);
title(handles.trials(handles.currentFile).name);

guidata(hObject, handles);


function handles = defaultOFzones(hObject, eventdata, handles)
% initializes zones and ruler to open field defaults for all trials
b = waitbar(0,'Setting Open Field Zones');
for i=1:length(handles.trials)
    
    zones(1).name = 'Perimeter';
    zones(1).pos = [  150.1774   25.0614;...
        555.1774   25.0614;...
        555.1774  430.0614;...
        150.1774  430.0614];
    zones(1).color = 'black';
    h = impoly(gca,zones(1).pos);
    zones(1).mask = createMask(h,handles.image);
    delete(h);
    
    ruler.pos = [151.6521,26.4649;...
        151.6521,429.2719];
    ruler.length = 50;
    ruler.lengthPerPixel = ruler.length/pdist2(ruler.pos(1,:),ruler.pos(2,:));
    trial.ruler = ruler;
    set(handles.edit_rulerLength,'String','50');
    handles.trials(i).mazeType = 'OF';
    zones(2).name = 'Center';
    
    zones(2).pos(1,1) =  zones(1).pos(1,1) + 10/ruler.lengthPerPixel;
    zones(2).pos(1,2) =  zones(1).pos(1,2) + 10/ruler.lengthPerPixel;
    
    zones(2).pos(2,1) =  zones(1).pos(2,1) - 10/ruler.lengthPerPixel;
    zones(2).pos(2,2) =  zones(1).pos(2,2) + 10/ruler.lengthPerPixel;
    
    zones(2).pos(3,1) =  zones(1).pos(3,1) - 10/ruler.lengthPerPixel;
    zones(2).pos(3,2) =  zones(1).pos(3,2) - 10/ruler.lengthPerPixel;
    
    zones(2).pos(4,1) =  zones(1).pos(4,1) + 10/ruler.lengthPerPixel;
    zones(2).pos(4,2) =  zones(1).pos(4,2) - 10/ruler.lengthPerPixel;
    
    zones(2).color = 'Red';
    h = impoly(gca,zones(2).pos);
    zones(2).mask = createMask(h,handles.image);
    delete(h);
    
    handles.trials(i).ruler = [];
    handles.trials(i).ruler = ruler;
    set(handles.edit_rulerLength,'String',num2str(ruler.length));
    handles.trials(i).zones = [];
    handles.trials(i).zones = zones;
    
    waitbar(i / length(handles.trials));
end
close(b);
guidata(hObject, handles);


function handles = defaultEPMzones(hObject, eventdata, handles)
% initializes zones and ruler to elevated plus defaults for all trials

b = waitbar(0,'Setting Elevated Plus Zones');
for i=1:length(handles.trials)
    zones(1).name = 'open1';
    zones(1).pos = [281.5614  225.4386;...
        281.5614   37.4386;...
        350.2544   37.2719;...
        350.2544  225.3421];
    zones(1).color = 'red';
    h = impoly(gca,zones(1).pos);
    zones(1).mask = createMask(h,handles.image);
    delete(h);
    
    zones(2).name = 'open2';
    zones(2).pos = [284.3684  457.2982;...
        284.3684  269.2982;...
        353.0614  269.1316;...
        353.0614  457.2018];
    zones(2).color = 'red';
    h = impoly(gca,zones(2).pos);
    zones(2).mask = createMask(h,handles.image);
    delete(h);
    
    zones(3).name = 'closed1';
    zones(3).pos = [334.5351  263.5175;...
        334.5351  224.2193;...
        553.4825  224.2193;...
        553.4825  263.5175];
    zones(3).color = 'green';
    h = impoly(gca,zones(3).pos);
    zones(3).mask = createMask(h,handles.image);
    delete(h);
    
    zones(4).name = 'closed2';
    zones(4).pos = [89.2018  269.1316;...
        89.2018  229.8333;...
        301.9737  229.8333;...
        301.9737  269.1316];
    zones(4).color = 'green';
    h = impoly(gca,zones(4).pos);
    zones(4).mask = createMask(h,handles.image);
    delete(h);
    
    zones(5).name = 'center';
    zones(5).pos = [301.4123  266.3246;...
        301.4123  227.0263;...
        335.6579  227.0263;...
        335.6579  266.3246];
    zones(5).color = 'yellow';
    h = impoly(gca,zones(5).pos);
    zones(5).mask = createMask(h,handles.image);
    delete(h);
    
    ruler.pos = [292.2413   52.5336;...
        288.2612  228.3992];
    ruler.length = 30;
    ruler.lengthPerPixel = ruler.length/pdist2(ruler.pos(1,:),ruler.pos(2,:));   
    
    handles.trials(i).ruler = [];
    handles.trials(i).ruler = ruler;
    set(handles.edit_rulerLength,'String',num2str(ruler.length));
    handles.trials(i).zones = [];
    handles.trials(i).zones = zones;

    handles.trials(i).mazeType = 'EPM';
    waitbar(i / length(handles.trials));
end
close(b);
guidata(hObject, handles);


function handles = defaultSocialZones(hObject, eventdata, handles)

b = waitbar(0,'Setting Three Chamber Social Zones');
for i=1:length(handles.trials)
    zones(1).name = 'juv1';
    zones(1).pos = [43.2628  130.1000;...
              234.4940  130.1000;...
              234.4940   353.8538;...
              43.2628   353.8538];
    zones(1).color = 'green';
    h = impoly(gca,zones(1).pos);
    zones(1).mask = createMask(h,handles.image);
    delete(h);
    
    zones(2).name = 'juv2';
    zones(2).pos = [ 418.9985,  130.1000;...
             596.7763,   130.1000;...
             596.7763,   353.8538;...
            418.9985,   353.8538];
    zones(2).color = 'red';
    h = impoly(gca,zones(2).pos);
    zones(2).mask = createMask(h,handles.image);
    delete(h);
    
    
    zones(3).name = 'center';
    zones(3).pos = [ 234.4940,  130.1000;...
        418.9985,  130.1000;...
        418.9985, 353.8538;...
        234.4940,  353.8538];
    zones(3).color = 'yellow';
    h = impoly(gca,zones(3).pos);
    zones(3).mask = createMask(h,handles.image);
    delete(h);
    
    
    ruler.pos = [ 43.2628,  127.8846;...
               598.6982,  127.8846];
    ruler.length = 56;
    ruler.lengthPerPixel = ruler.length/pdist2(ruler.pos(1,:),ruler.pos(2,:));   
    
    handles.trials(i).ruler = [];
    handles.trials(i).ruler = ruler;
    set(handles.edit_rulerLength,'String',num2str(ruler.length));
    handles.trials(i).zones = [];
    handles.trials(i).zones = zones;

    handles.trials(i).mazeType = 'Social';
    waitbar(i / length(handles.trials));
end
close(b);
guidata(hObject, handles);

   









function zones = setOFZones(hObject, eventdata, handles)

displayImage = handles.currentVideo(handles.displayType).cData;

position = [7 5];
text = ['Click and hold zones to move'];
displayImage = insertText(displayImage,position,text,'FontSize',12,'BoxColor','black','BoxOpacity',0.4,'TextColor','white');
handles.image = image(displayImage);

position = [7 450];
text = ['Double click center zone to save'];
displayImage = insertText(displayImage,position,text,'FontSize',12,'BoxColor','black','BoxOpacity',0.4,'TextColor','white');
handles.image = image(displayImage);

%Determine Perimeter
h = imrect(gca,poly2rectPosition(handles.trials(handles.currentFile).zones(1).pos));
h.setColor(handles.trials(handles.currentFile).zones(1).color);

wait(h);
zones(1) = handles.trials(handles.currentFile).zones(1);
zones(1).pos = rect2polyPosition(h.getPosition);
zones(1).mask = createMask(h,handles.image);

delete(h);

zones(2) = handles.trials(handles.currentFile).zones(2);
zones(2).pos(1,1) =   zones(1).pos(1,1) + 10/ handles.trials(handles.currentFile).ruler.lengthPerPixel;
zones(2).pos(1,2) =  zones(1).pos(1,2) + 10/ handles.trials(handles.currentFile).ruler.lengthPerPixel;
zones(2).pos(2,1) =  zones(1).pos(2,1) - 10/handles.trials(handles.currentFile).ruler.lengthPerPixel;
zones(2).pos(2,2) = zones(1).pos(2,2) + 10/handles.trials(handles.currentFile).ruler.lengthPerPixel;
zones(2).pos(3,1) =  zones(1).pos(3,1) - 10/handles.trials(handles.currentFile).ruler.lengthPerPixel;
zones(2).pos(3,2) =  zones(1).pos(3,2) - 10/handles.trials(handles.currentFile).ruler.lengthPerPixel;
zones(2).pos(4,1) =  zones(1).pos(4,1) + 10/handles.trials(handles.currentFile).ruler.lengthPerPixel;
zones(2).pos(4,2) =  zones(1).pos(4,2) - 10/handles.trials(handles.currentFile).ruler.lengthPerPixel; %bottom left

h = impoly(gca,zones(2).pos);
zones(2).mask = createMask(h,handles.image);
delete(h);




  



function zones = setEPMZones(hObject, eventdata, handles)
%This is the function that sets zones for EPM AND Social

hold on;

%Create overlay text
displayImage = handles.currentVideo(handles.displayType).cData;

position = [7 5];
text = ['Click and hold zones to move'];
displayImage = insertText(displayImage,position,text,'FontSize',12,'BoxColor','black','BoxOpacity',0.4,'TextColor','white');
handles.image = image(displayImage);

position = [7 450];
text = ['Double click yellow zone to save'];
displayImage = insertText(displayImage,position,text,'FontSize',12,'BoxColor','black','BoxOpacity',0.4,'TextColor','white');
handles.image = image(displayImage);

for i=1:length(handles.trials(handles.currentFile).zones)
    position = [7 5+20*i];
    text = handles.trials(handles.currentFile).zones(i).name;
    textColor = handles.trials(handles.currentFile).zones(i).color;
    displayImage = insertText(displayImage,position,text,'FontSize',12,'BoxColor','black','BoxOpacity',0.4,'TextColor',textColor);
    image(displayImage);
end


for i=1:length(handles.trials(handles.currentFile).zones)
    h(i) = impoly(gca,handles.trials(handles.currentFile).zones(i).pos);
    h(i).setColor(handles.trials(handles.currentFile).zones(i).color);
end

wait(h(end));




for j=1:length(handles.trials(handles.currentFile).zones)
    zones(j) = handles.trials(handles.currentFile).zones(j);
    zones(j).pos = h(j).getPosition;
    zones(j).mask = createMask(h(j),handles.image);
end


delete(h(:));
hold off;
guidata(hObject, handles);

function trial = createNewTrial(filePath)
[path name] = fileparts(filePath);

trial.name = name;
trial.videoPath = filePath;
trial.sampleRate = [];
trial.background = 1;
trial.recordTime = [];
trial.startframe = 1;
trial.exclusionMask = [];
trial.mazeType = [];
trial.zones = [];
trial.position = [];
trial.distance = [];
trial.heatMap = [];
trial.ruler = [];
trial.time = [];

function outputTrial = standardizeTrialFields(inputTrial)

if ~isfield(inputTrial, 'name')
    outputTrial.name = [];
else
    outputTrial.name = inputTrial.name;
end

if ~isfield(inputTrial, 'videoPath')
    outputTrial.videoPath = [];
else
    outputTrial.videoPath = inputTrial.videoPath;
end

if ~isfield(inputTrial, 'sampleRate')
    outputTrial.sampleRate = [];
else
    outputTrial.sampleRate = inputTrial.sampleRate;
end

if ~isfield(inputTrial, 'background')
    outputTrial.background = 1;
else
    outputTrial.background = inputTrial.background;
end

if ~isfield(inputTrial, 'recordTime')
    outputTrial.recordTime = [];
else
    outputTrial.recordTime = inputTrial.recordTime;
end

if ~isfield(inputTrial, 'startframe')
    outputTrial.startframe = [];
else
    outputTrial.startframe = inputTrial.startframe;
end

if ~isfield(inputTrial, 'exclusionMask')
    outputTrial.exclusionMask = [];
else
    outputTrial.exclusionMask = inputTrial.exclusionMask;
end

if ~isfield(inputTrial, 'mazeType')
    outputTrial.mazeType = [];
else
    outputTrial.mazeType = inputTrial.mazeType;
end

if ~isfield(inputTrial, 'zones')
    outputTrial.zones = [];
else
    outputTrial.zones = inputTrial.zones;
end

if ~isfield(inputTrial, 'position')
    outputTrial.position = [];
else
    outputTrial.position = inputTrial.position;
end

if ~isfield(inputTrial, 'distance')
    outputTrial.distance = [];
else
    outputTrial.distance = inputTrial.distance;
end

if ~isfield(inputTrial, 'heatMap')
    outputTrial.zones = [];
else
    outputTrial.heatMap = inputTrial.heatMap;
end

if ~isfield(inputTrial, 'ruler')
    outputTrial.ruler = [];
else
    outputTrial.ruler = inputTrial.ruler;
end

if ~isfield(inputTrial, 'time')
    outputTrial.time = [];
else
    outputTrial.time = inputTrial.time;
end
















































%% Graveyard
% --- Executes during object creation, after setting all properties.
function button_forward_CreateFcn(hObject, eventdata, handles)
% hObject    handle to button_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over button_forward.
function button_forward_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to button_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






function startFrameText_Callback(hObject, eventdata, handles)
% hObject    handle to startFrameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startFrameText as text
%        str2double(get(hObject,'String')) returns contents of startFrameText as a double
handles.trials(handles.currentFile).startframe = str2double(get(hObject,'String'))*round(handles.videoReader.frameRate)+1;
updateFrame(hObject, eventdata, handles);

function edit_backgroundFrameText_Callback(hObject, eventdata, handles)
% hObject    handle to edit_backgroundFrameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_backgroundFrameText as text
%        str2double(get(hObject,'String')) returns contents of edit_backgroundFrameText as a double
handles.trials(handles.currentFile).background = str2double(get(hObject,'String'))*round(handles.videoReader.frameRate)+1;
updateFrame(hObject, eventdata, handles);

% --- Executes on button press in button_exit.
function button_exit_Callback(hObject, eventdata, handles)
% hObject    handle to button_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);

function edit_currentFrameText_Callback(hObject, eventdata, handles)
% hObject    handle to edit_currentFrameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_currentFrameText as text
%        str2double(get(hObject,'String')) returns contents of edit_currentFrameText as a double


if str2double(get(hObject,'String'))*round(handles.videoReader.frameRate)+1 > handles.videoReader.numberOfFrames
    
    lastFrame = handles.videoReader.numberOfFrames-round(handles.videoReader.FrameRate)
    handles.currentFrame = floor(lastFrame./round(handles.videoReader.FrameRate))*round(handles.videoReader.FrameRate)+1;
    
    
    
    set(handles.edit_currentFrameText,'String', num2str((handles.currentFrame-1)./(round(handles.videoReader.FrameRate))));
else
    handles.currentFrame = str2double(get(hObject,'String'))*round(handles.videoReader.frameRate)+1;
end

updateFrame(hObject, eventdata, handles);


function edit_currentVideoText_Callback(hObject, eventdata, handles)
% hObject    handle to edit_currentVideoText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_currentVideoText as text
%        str2double(get(hObject,'String')) returns contents of edit_currentVideoText as a double

if str2double(get(hObject,'String')) > length(handles.trials)
    handles.currentFile = length(handles.trials);
elseif str2double(get(hObject,'String')) < 1
    handles.currentFile = 1
else
    handles.currentFile = str2double(get(hObject,'String'));
end

handles = initializeNewVideo(hObject, eventdata, handles);
guidata(hObject, handles);


function edit_recordTime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_recordTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_recordTime as text
%        str2double(get(hObject,'String')) returns contents of edit_recordTime as a double
handles.recordTime = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_recordTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_recordTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    
end
set(hObject,'String','600');

function edit_sampleRate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sampleRate as text
%        str2double(get(hObject,'String')) returns contents of edit_sampleRate as a double
handles.sampleRate = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_sampleRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String','15');
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function startFrameText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startFrameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','1');
guidata(hObject, handles);











% --- Executes during object creation, after setting all properties.
function edit_backgroundFrameText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_backgroundFrameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','1');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_currentFrameText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_currentFrameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','1');
guidata(hObject, handles);

function edit_setBodyThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_setBodyThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_setBodyThreshold as text
%        str2double(get(hObject,'String')) returns contents of edit_setBodyThreshold as a double

if str2double(get(hObject,'String')) > 1
    set(hObject,'String','1')
elseif  str2double(get(hObject,'String')) < 0
    set(hObject,'String','0')
end

updateFrame(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_setBodyThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_setBodyThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String','0.3')
guidata(hObject, handles);

function edit_setTailThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_setTailThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_setTailThreshold as text
%        str2double(get(hObject,'String')) returns contents of edit_setTailThreshold as a double
if str2double(get(hObject,'String')) > 1
    set(hObject,'String','1')
elseif  str2double(get(hObject,'String')) < 0
    set(hObject,'String','0')
end

updateFrame(hObject, eventdata, handles)
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.

function edit_setTailThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_setTailThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','0.3')
guidata(hObject, handles);

function edit_setTailFilter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_setTailFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_setTailFilter as text
%        str2double(get(hObject,'String')) returns contents of edit_setTailFilter as a double
if  str2double(get(hObject,'String')) < 0
    set(hObject,'String','0')
end

updateFrame(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_setTailFilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_setTailFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String','9')
guidata(hObject, handles);

function edit_rulerLength_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rulerLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rulerLength as text
%        str2double(get(hObject,'String')) returns contents of edit_rulerLength as a double





% --- Executes during object creation, after setting all properties.
function edit_rulerLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rulerLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit_currentVideoText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_currentVideoText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
