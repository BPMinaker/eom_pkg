function lat_tire_force=tire_lat(sideslip,load,camber)

global params;

sideslip=sideslip*180/pi; % tire sideslip angle input in radians
camber=camber*180/pi;
C=params.a_mtm(1);
mu_yp=params.a_mtm(2)*load/1000+params.a_mtm(3);
D=mu_yp.*load/1000;
E=params.a_mtm(7)*load/1000+params.a_mtm(8);
B=params.a_mtm(4)*sin(2*atan(load/1000/params.a_mtm(5))).*(1-params.a_mtm(6)*abs(camber))/C./D;
lat_tire_force=-D.*sin(C*atan(B.*(1-E).*(sideslip)+E.*atan(B.*(sideslip))));

lat_tire_force(load<0)=0;

end  %% Leave


%Sh=params.a_mtm(9)*camber+params.a_mtm(10)*load/1000+params.a_mtm(11);
%Sv=(params.a_mtm(12)*load/1000+params.a_mtm(13))*camber*load/1000+params.a_mtm(14)*load/1000+params.a_mtm(15);
%lat_tire_force=D*sin(C*atan(B*(1-E)*(sideslip+Sh)+E*atan(B*(sideslip+Sh)))); %+Sv;
