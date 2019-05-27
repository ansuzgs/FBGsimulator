function varargout = GUIPOR_adap(varargin)
% GUIPOR_adap MATLAB code for GUIPOR_adap.fig
%      GUIPOR_adap, by itself, creates a new GUIPOR_adap or raises the existing
%      singleton*.
%
%      H = GUIPOR_adap returns the handle to a new GUIPOR_adap or the handle to
%      the existing singleton*.
%
%      GUIPOR_adap('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIPOR_adap.M with the given input arguments.
%
%      GUIPOR_adap('Property','Value',...) creates a new GUIPOR_adap or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIPOR_adap_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIPOR_adap_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIPOR_adap

% Last Modified by GUIDE v2.5 11-Dec-2017 18:48:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUIPOR_adap_OpeningFcn, ...
    'gui_OutputFcn',  @GUIPOR_adap_OutputFcn, ...
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


% --- Executes just before GUIPOR_adap is made visible.
function GUIPOR_adap_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIPOR_adap (see VARARGIN)

% Choose default command line output for GUIPOR_adap
handles.output = hObject;
set(handles.text8, 'Visible', 'off');
set(handles.edit7, 'Visible', 'off');
set(handles.text9, 'Visible', 'off');
set(handles.edit8, 'Visible', 'off');

set(handles.text10, 'Visible', 'on');
set(handles.edit9, 'Visible', 'on');
set(handles.text12, 'Visible', 'on');
set(handles.edit11, 'Visible', 'on');
set(handles.text6, 'Visible', 'off');
set(handles.edit5, 'Visible', 'off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIPOR_adap wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIPOR_adap_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
tic
cla(handles.axes1,'reset')
cla(handles.axes2,'reset')

lambda = str2num(get(handles.edit1, 'String'))*1e-9;
L =  str2num(get(handles.edit2, 'String'))*1e-2;
h = -str2num(get(handles.edit3, 'String'))*1e-2;
z =  0;
c =  3e8;
ng = str2num(get(handles.edit4, 'String'));
vg = c/ng;

tol = str2num(get(handles.edit10, 'String'));


% k Variable
enventanados = get(handles.popupmenu3, 'String');
enventanado = cell2mat(enventanados (get(handles.popupmenu3, 'Value')));
switch enventanado
    case 'Gaussiano'
        % Fase cuadratica
        k0 = str2num(get(handles.edit9, 'String'));
        g = str2num(get(handles.edit11, 'String'));
        gauss = 1;
    case 'Lineal'
        % Salto de fase
        gauss = 0;
        k0 = str2num(get(handles.edit9, 'String'));
    case 'Reflectividad constante'
        g = str2num(get(handles.edit11, 'String'));
        R = str2num(get(handles.edit5, 'String'));
        gauss = 2;
end

desfases = get(handles.popupmenu1, 'String');
desfase = cell2mat(desfases(get(handles.popupmenu1, 'Value')));
switch desfase
    case 'Cuadrático'
        % Fase cuadratica
        F = -str2num(get(handles.edit6, 'String'));
        cuad = 1;
    case 'Escalón'
        % Salto de fase
        deltaPhi = str2num(get(handles.edit7, 'String'));
        xn = -str2num(get(handles.edit8, 'String'))*1e-2;
        cuad = 0;
end

f_limite = str2num(get(handles.edit12, 'String'))*1e9;
f = linspace(-f_limite, f_limite, 5000);
delta = 2*pi*f/vg;

% Condiciones de contorno
S0 = zeros(1,length(f));
R0 = ones(1,length(f));

Sn = S0;
Rn = R0;
count = 0;
j=1;
gg=0;
haux = h;
it = 0;
itval = 0;
hw = waitbar(0,'Espere por favor...');
while j == 1
    
    if cuad == 1
        phi_z =  F .* ((z+L/2)/(L)).^2;
    else
        if z >= xn
            phi_z = deltaPhi;
        else
            phi_z = 0;
        end
    end
    
    if gauss == 1
        k_z = k0 .* exp(-g.*((z+L/2)/L).^2);
    else
        if gauss == 0
            k_z = k0*z;
        else 
            k_z = (atanh(sqrt(0.9))/L).* exp(-g.*((z+L/2)/L).^2);
        end
    end
    
    dR1 = 1i*delta.*Rn + 1i*Sn*k_z*exp(1i*phi_z);
    dS1 = -1i*delta.*Sn - 1i*Rn*k_z*exp(-1i*phi_z);
    
    R1 = Rn - h*dR1;
    S1 = Sn - h*dS1;
    
    dR2 = 1i*delta.*R1 + 1i*S1*k_z*exp(1i*phi_z);
    dS2 = -1i*delta.*S1 - 1i*R1*k_z*exp(-1i*phi_z);
    
    R2 = R1 - h*(dR1+dR2)/4;
    S2 = S1 - h*(dS1+dS2)/4;
    
    dR3 = 1i*delta.*R2 + 1i*S2.*k_z*exp(1i*phi_z);
    dS3 = -1i*delta.*S2 - 1i*R2.*k_z*exp(-1i*phi_z);
    
    deltaR = h*(dR1 + 4*dR3 + dR2)/6;
    deltaS = h*(dS1 + 4*dS3 + dS2)/6;
    
    errorR = abs(h*(dR1 - 2*dR3 + dR2));
    errorS = abs(h*(dS1 - 2*dS3 + dS2));
    
    % % Comprobación de tolerancia
    if max(errorR) > tol || max(errorS) > tol
        h = h*0.7;
        aux = 1;
        if h > haux
            haux = h;
        end
    else
        itval = itval +1;
        Rn = Rn - deltaR;
        Sn = Sn - deltaS;
        count = count + 1;
        if count == floor(0.015*L/-h)
            h = h*1.2;
        end
        if gg == 1
            j = 0;
        end
        z = z+h;
        if z < -L
            gg =1;
        end
    end
    steps = L/-h;
    itrel = z/h;
    waitbar(itrel/steps,hw)
    it = it+1;
end
close(hw)

coef = Sn./Rn;

value = get(handles.checkbox1, 'Value');
if (value == get(handles.checkbox1,'Max'))

    plot(handles.axes1, f*1e-9, (abs(coef)).^2)
    %plot(handles.axes1, f*1e-9, (abs(coef)).^2)
    %semilogy(handles.axes1, f*1e-9,abs(coef))
    title(handles.axes1,'Reflectividad')
    xlabel(handles.axes1,'Frecuencia (GHz)')
    ylabel(handles.axes1,'Reflectividad')
    grid(handles.axes1,'on')

    tecta = unwrap(angle(coef));
    Ret = -gradient(tecta, 2*pi.*f);
    plot(handles.axes2, f*1e-9,Ret*1e12);
    title('Retardo de grupo')
    xlabel('Frecuencia (GHz)')
    ylabel('Tiempo (ps)')
    a = axis;
    a(4) = 600;
    a(3) = -600;
    axis(handles.axes2, a)
    grid(handles.axes2,'on')
else
    plot(handles.axes1, f*1e-9, 20*log10(abs(coef)))
    %plot(handles.axes1, f*1e-9, (abs(coef)).^2)
    %semilogy(handles.axes1, f*1e-9,abs(coef))
    title(handles.axes1,'Reflectividad')
    xlabel(handles.axes1,'Frecuencia (GHz)')
    ylabel(handles.axes1,'Reflectividad (dB)')
    grid(handles.axes1,'on')

    tecta = unwrap(angle(coef));
    Ret = -gradient(tecta, 2*pi.*f);
    plot(handles.axes2, f*1e-9,Ret*1e12);
    title('Retardo de grupo')
    xlabel('Frecuencia (GHz)')
    ylabel('Tiempo (ps)')
    a = axis;
    a(4) = 600;
    a(3) = -600;
    axis(handles.axes2, a)
    grid(handles.axes2,'on')
end


toc
% haux
% it
% itval

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
desfases = get(hObject, 'String');
desfase = desfases(get(hObject, 'Value'));
switch cell2mat(desfase)
    case 'Cuadrático'
        set(handles.text7, 'Visible', 'on');
        set(handles.edit6, 'Visible', 'on');
        set(handles.text8, 'Visible', 'off');
        set(handles.edit7, 'Visible', 'off');
        set(handles.text9, 'Visible', 'off');
        set(handles.edit8, 'Visible', 'off');
    case 'Escalón'
        set(handles.text7, 'Visible', 'off');
        set(handles.edit6, 'Visible', 'off');
        set(handles.text8, 'Visible', 'on');
        set(handles.edit7, 'Visible', 'on');
        set(handles.text9, 'Visible', 'on');
        set(handles.edit8, 'Visible', 'on');
end


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3

    enventanados = get(hObject, 'String')
    enventanado = enventanados(get(hObject, 'Value'))
    switch cell2mat(enventanado)
        case 'Gaussiano'
            set(handles.text12, 'Visible', 'on');
            set(handles.edit11, 'Visible', 'on');
            set(handles.text10, 'Visible', 'on');
            set(handles.edit9, 'Visible', 'on');
            set(handles.text6, 'Visible', 'off');
            set(handles.edit5, 'Visible', 'off');
        case 'Lineal'
            set(handles.text12, 'Visible', 'off');
            set(handles.edit11, 'Visible', 'off');
            set(handles.text10, 'Visible', 'on');
            set(handles.edit9, 'Visible', 'on');
            set(handles.text6, 'Visible', 'off');
            set(handles.edit5, 'Visible', 'off');
        case 'Reflectividad constante'
            set(handles.text12, 'Visible', 'on');
            set(handles.edit11, 'Visible', 'on');
            set(handles.text10, 'Visible', 'off');
            set(handles.edit9, 'Visible', 'off');
            set(handles.text6, 'Visible', 'on');
            set(handles.edit5, 'Visible', 'on');
    end



% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
