function varargout = EDGUI(varargin)
% EDGUI MATLAB code for EDGUI.fig
%      EDGUI, by itself, creates a new EDGUI or raises the existing
%      singleton*.
%
%      H = EDGUI returns the handle to a new EDGUI or the handle to
%      the existing singleton*.
%
%      EDGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDGUI.M with the given input arguments.
%
%      EDGUI('Property','Value',...) creates a new EDGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EDGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EDGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EDGUI

% Last Modified by GUIDE v2.5 17-Aug-2013 02:37:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @EDGUI_OpeningFcn, ...
    'gui_OutputFcn',  @EDGUI_OutputFcn, ...
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
end

% --- Executes just before EDGUI is made visible.
function EDGUI_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for EDGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


%% Loading Lena
% add the original image handle, filter image handle and the modified image
% handle (the one to be shown)
lena = imread('lena.jpg');
handles.imgHandle = imshow(lena); hold on
set(handles.imgHandle, 'CData', lena);
handles.filterImgHandle = imshow(lena); hold on
set(handles.filterImgHandle, 'CData', lena);
handles.modImgHandle = imshow(lena); hold on
set(handles.modImgHandle, 'CData', lena);

resize('lena.jpg', handles);

guidata(hObject, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = EDGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

function openTool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,pathName,filterIndex] = uigetfile;
imagePath = horzcat(pathName, fileName);
openImage(handles, imagePath);
end

function edTool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to edTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

applyED(eventdata,handles);
end

function superpositionTool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to superpositionTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
originalImage = get(handles.imgHandle, 'CData');
modImage = get(handles.modImgHandle, 'CData');

isOn = get(hObject, 'State');
if(isequal(isOn,'on'))
    dif = im2single(originalImage);
    result = im2single(modImage) + 0.3.*dif;
else %should take it off
    result = modImage;
end

imshow(result);
end

function restoreTool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to restoreTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image = get(handles.imgHandle, 'CData');
showImg(image,handles);

set(handles.filterImgHandle, 'CData', image);

set(handles.edTool, 'State', 'off');
set(handles.superpositionTool, 'State', 'off');

guidata(hObject, handles);
end

% --- Executes on slider movement.
function gaussSlider_Callback(hObject, eventdata, handles)
% hObject    handle to gaussSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

applyFilters(handles, eventdata);
end

% --- Executes during object creation, after setting all properties.
function gaussSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

set(hObject, 'Min', 1, 'Max', 25, 'Value', 1);
end

% --- Executes on selection change in edMethodPopupMenu.
function edMethodPopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to edMethodPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns edMethodPopupMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edMethodPopupMenu

% selection
selection = get(hObject, 'Value');
method = methodFromSelection(selection);

enablePropertie(method,handles);

if(~isequal(method, 'Canny'))
    set(handles.minThresholdText, 'Enable', 'off');
    set(handles.minThresholdSlider, 'Enable', 'off');
    
else
    set(handles.minThresholdText, 'Enable', 'on');
    set(handles.minThresholdSlider, 'Enable', 'on');
    setMinLessThanMax(handles);
end

applyED(eventdata,handles);
end

% --- Executes during object creation, after setting all properties.
function edMethodPopupMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edMethodPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'string', {'Canny', 'Sobel', 'Prewitt','Roberts', 'Log', 'Zerocross'});
end

% --- Executes on maxThresholdSlider movement.
function maxThresholdSlider_Callback(hObject, eventdata, handles)
% hObject    handle to maxThresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of maxThresholdSlider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of maxThresholdSlider

applyED(eventdata,handles);

%% set value in the text box
maxValue = get(hObject, 'Value');
string = [maxValue];
set(handles.maxThresholdText, 'String', string );

%update handles structure
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function maxThresholdSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxThresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: maxThresholdSlider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% set min, max values and slide step
set(hObject, 'SliderStep', [0.001 0.03], 'Min', 0.0, 'Max', 0.99, 'Value', 0.5);
end

% --- Executes on slider movement.
function minThresholdSlider_Callback(hObject, eventdata, handles)
% hObject    handle to minThresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

applyED(eventdata,handles)

%% set value in the text box
minValue = get(hObject, 'Value');
string = [minValue];
set(handles.minThresholdText, 'String', string );

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function minThresholdSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minThresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% set min, max values and slide step
set(hObject, 'SliderStep', [0.001 0.03], 'Min', 0.0, 'Max', 0.99, 'Value', 0.1);
end

% --- Executes during object creation, after setting all properties.
function maxThresholdText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxThresholdText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function minThresholdText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minThresholdText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on slider movement.
function edPropertieSlider_Callback(hObject, eventdata, handles)
% hObject    handle to edPropertieSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

applyED(eventdata,handles);
end

% --- Executes during object creation, after setting all properties.
function edPropertieSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edPropertieSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% --- Executes during object creation, after setting all properties.
function edPropertieTextValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edPropertieTextValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes during object creation, after setting all properties.
function edPropertieText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edPropertieText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in directionPopUpMenu.
function directionPopUpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to directionPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns directionPopUpMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from directionPopUpMenu
applyED(eventdata,handles);
end

% --- Executes during object creation, after setting all properties.
function directionPopUpMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to directionPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'string', {'Horizontal', 'Vertical', 'Both'});
end



% --- Executes on slider movement.
function histogramSlider_Callback(hObject, eventdata, handles)
% hObject    handle to histogramSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
applyFilters(handles,eventdata);
end

% --- Executes during object creation, after setting all properties.
function histogramSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to histogramSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'SliderStep', [0.05 0.3], 'Min', 1, 'Max', 20, 'Value', 1);
end


function saveTool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imsave(handles.modImgHandle);
end

%% ---------------------------------------------------------------------------

function method = methodFromSelection(selection)

switch selection
    case 1
        method = 'Canny';
    case 2
        method = 'Sobel';
    case 3
        method = 'Prewitt';
    case 4
        method = 'Roberts';
    case 5
        method = 'Log';
    case 6
        method = 'Zerocross';
end
end

function applyED(eventdata,handles)
%% Appling Edge Detection
edIsOn = get(handles.edTool , 'State');
if( isequal(edIsOn,'off'))
    set(handles.edTool , 'State', 'on');
end
%ED will be applyed in the filtered image
filteredImage = get(handles.filterImgHandle, 'CData');

% selection
selection = get(handles.edMethodPopupMenu, 'Value');
method = methodFromSelection(selection);

switch method
    case 'Canny'
        % Check if min is less than max
        setMinLessThanMax(handles);

        threshold(1) = get(handles.minThresholdSlider, 'Value');
        threshold(2) = get(handles.maxThresholdSlider, 'Value');

        sigma = get(handles.edPropertieSlider, 'Value');

        ED = edge(filteredImage,'Canny',threshold, sigma);

        % Set value in the text box
        setTextFromSliderValue(threshold(2), handles.maxThresholdText);
        setTextFromSliderValue(threshold(1), handles.minThresholdText);
        setTextFromSliderValue(sigma, handles.edPropertieTextValue);
    case 'Sobel'
        threshold = get(handles.maxThresholdSlider, 'Value');
        
        selection = get(handles.directionPopUpMenu, 'Value');
        direction = directionFromSelection(selection);
        
        ED = edge(filteredImage,method, threshold, direction);

        % Set value in the text box
        setTextFromSliderValue(threshold, handles.maxThresholdText);
    case 'Prewitt'
        threshold = get(handles.maxThresholdSlider, 'Value');

        selection = get(handles.directionPopUpMenu, 'Value');
        direction = directionFromSelection(selection);
        
        ED = edge(filteredImage,method, threshold, direction);

        % Set value in the text box
        setTextFromSliderValue(threshold, handles.maxThresholdText);
    case 'Roberts'
        threshold = get(handles.maxThresholdSlider, 'Value');

        ED = edge(filteredImage ,method, threshold);

        % Set value in the text box
        setTextFromSliderValue(threshold, handles.maxThresholdText);
    case 'Log'
        threshold = get(handles.minThresholdSlider, 'Value');

        sigma = get(handles.edPropertieSlider, 'Value');

        ED = edge(filteredImage, method, threshold, sigma);

        % Set value in the text box
        setTextFromSliderValue(threshold, handles.maxThresholdText);
        setTextFromSliderValue(sigma, handles.edPropertieTextValue);
    case 'Zerocross'
        threshold = get(handles.maxThresholdSlider, 'Value');

        ED = edge(filteredImage, method, threshold);

        % Set value in the text box
        setTextFromSliderValue(threshold, handles.maxThresholdText);

    otherwise

end
showImg(ED,handles);

checkSuperposition(eventdata, handles);
end

function showImg(image,handles)
% The image to be shown is the image in the handles.modImgHandle
set(handles.modImgHandle, 'CData', image);
imshow(image);
end

function checkSuperposition(eventdata, handles)
superpositionTool_ClickedCallback(handles.superpositionTool, eventdata, handles);
end

function setMinLessThanMax(handles)
    min = get(handles.minThresholdSlider, 'Value');
    max = get(handles.maxThresholdSlider, 'Value');
if (min >= max)
    if ~isequal(max,0)
        set(handles.minThresholdSlider, 'Value', max - 0.001);
    else
        set(handles.minThresholdSlider, 'Value', 0);
        set(handles.maxThresholdSlider, 'Value', max + 0.001);
    end
end
end

function resize(imagePath, handles)
set(handles.imgAxes, 'Units', 'pixels');
set(handles.mainPanel, 'Units', 'pixels');
set(handles.lateralPanel, 'Units', 'pixels');

img = imread(imagePath);
%% Declarate sizes
imgSize = size(img) % [height width]

% Dimension of main windown 
position = get(handles.mainPanel, 'Position');

% image coordinates
xImg = 5;
yImg = 57;

% lateral panel dimensions
wL = 150;

% right gaps between image and corner
wRImg = 47;

% window dimension
width = xImg + imgSize(2) + wRImg + wL;
height = yImg + 3 + imgSize(1);
x = position(1);
y = position(2) + (position(4) - width);

hL = height;

% lateral panel position
yL = 0;
xL = width - wL;

set(handles.imgAxes,'Position', [xImg yImg imgSize(2) imgSize(1)]);
get(handles.imgAxes,'Position')
set(handles.mainPanel,'Position', [x y width height]);
set(handles.lateralPanel, 'Position', [xL yL wL hL]);

imshow(img);
end

function openImage(handles, imagePath)
image = imread(imagePath);

sizeImg = size(size(image));
if (isequal(sizeImg(2),3))
   image = image(:,:,1);
end

set(handles.imgHandle, 'CData', image);
set(handles.filterImgHandle, 'CData', image);
set(handles.modImgHandle, 'CData', image);

resize(imagePath, handles);
end

function enablePropertie(method, handles)
    switch method
        case 'Canny'
            enableSigma(1, handles);
            enableDirection(0, handles);
        case 'Sobel'
            enableSigma(0, handles);
            enableDirection(1, handles);
        case 'Prewitt'
            enableSigma(0, handles);
            enableDirection(1, handles);
        case 'Roberts'
            enableSigma(0, handles);
            enableDirection(0, handles);
        case 'Log'
            enableSigma(1, handles);
            enableDirection(0, handles);
        case 'Zerocross'
            enableSigma(0, handles);
            enableDirection(0, handles);
        otherwise
            enableSigma(0, handles);
            enableDirection(0, handles);
    end
end

function enableSigma(true, handles)
state = 'off';
if true
    state = 'on';
end
set(handles.sigmaPanel, 'Visible', state);
end

function enableDirection(true, handles)
state = 'off';
if true
    state = 'on';
end
set(handles.directionPanel, 'Visible', state);
end

function method = directionFromSelection(selection)

switch selection
    case 1
        method = 'Horizontal';
    case 2
        method = 'Vertical';
    case 3
        method = 'Both';
end
end

function setTextFromSliderValue(string, handle)
    set(handle, 'String', string );
end

function  applyFilters(handles, eventdata)
% Gauss
originalImage = get(handles.imgHandle, 'CData');

%Reading value from slider
oversampling = floor(get(handles.gaussSlider, 'Value'));
gaussfilter = gaussfir(.3,10,oversampling);
%Applying filter on the original image
gaussImage = imfilter(originalImage, gaussfilter);

%Histeq
histLevel = floor(get(handles.histogramSlider, 'Value'));
if(~isequal(histLevel,1))
    filteredImage = histeq(gaussImage,22-histLevel);
else
    filteredImage = gaussImage;
end
set(handles.filterImgHandle, 'CData', filteredImage);

edIsOn = get(handles.edTool, 'State');
if(isequal(edIsOn, 'on'))
    applyED(eventdata,handles);
else
    showImg(filteredImage, handles);
    checkSuperposition(eventdata, handles);
end
end
