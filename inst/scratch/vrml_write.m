function vrml_write(writepath)

global params

% interpolate ode45 output to reduce the data set size
vrml_time=0:1:round(max(params.tout));
vrml_X=interp1(params.tout,params.X,vrml_time,'linear','extrap');
vrml_Y=interp1(params.tout,params.Y,vrml_time,'linear','extrap');
vrml_yaw=interp1(params.tout,params.yaw,vrml_time,'linear','extrap');

camaro_vrml_script;
track_vrml_script;

string_vrml_code=['DEF timer TimeSensor {\n'];
string_vrml_code=[string_vrml_code 'cycleInterval ' num2str(max(vrml_time)) '\n'];
% string_vrml_code=[string_vrml_code 'startTime 0\n'];
% string_vrml_code=[string_vrml_code 'stopTime 0\n'];
string_vrml_code=[string_vrml_code 'loop TRUE\n'];
string_vrml_code=[string_vrml_code '}\n'];
string_vrml_code=[string_vrml_code '\n'];

string_vrml_code=[string_vrml_code 'DEF animateCamaro PositionInterpolator {\n'];
string_vrml_code=[string_vrml_code 'key[' num2str(linspace(0,1,length(vrml_time))) ']\n'];
string_vrml_code=[string_vrml_code 'keyValue [\n'];
for i=1:length(vrml_time)
    string_vrml_code=[string_vrml_code num2str(vrml_X(i)) ' ' num2str(vrml_Y(i)) ' 0\n'];
end
string_vrml_code=[string_vrml_code ']\n'];
string_vrml_code=[string_vrml_code '}\n'];

string_vrml_code=[string_vrml_code 'DEF animateCamaro2 OrientationInterpolator {\n'];
string_vrml_code=[string_vrml_code 'key[' num2str(linspace(0,1,length(vrml_time))) ']\n'];
string_vrml_code=[string_vrml_code 'keyValue [\n'];
for i=1:length(vrml_time)
    string_vrml_code=[string_vrml_code '0 0 1 ' num2str(vrml_yaw(i)) '\n'];
end
string_vrml_code=[string_vrml_code ']\n'];
string_vrml_code=[string_vrml_code '}\n'];

string_vrml_code=[string_vrml_code 'ROUTE timer.fraction_changed TO animateCamaro.set_fraction\n'];
string_vrml_code=[string_vrml_code 'ROUTE timer.fraction_changed TO animateCamaro2.set_fraction\n'];
string_vrml_code=[string_vrml_code 'ROUTE animateCamaro.value_changed TO Camaro.set_translation\n'];
string_vrml_code=[string_vrml_code 'ROUTE animateCamaro2.value_changed TO Camaro.set_rotation\n'];

% create vrml file
string_vrml=[string_vrml string_camaro_vrml string_vrml_code];
string_filename_track_vrml='track_vrml_file_MATLAB.wrl';
file_track_vrml=fopen([writepath filesep() string_filename_track_vrml],'w');
fprintf(file_track_vrml,string_vrml);
fclose(file_track_vrml);
