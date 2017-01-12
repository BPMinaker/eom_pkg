function Mz=tire_rest_moment(slip,load,camber);

global params;

slip=slip*180/pi; % convert sideslip angle from radians to degrees
C=params.c_mtm(1);
D=params.c_mtm(2)*(load/1000).^2+params.c_mtm(3)*load/1000;
E=(params.c_mtm(8)*(load/1000).^2+params.c_mtm(9)*load/1000+params.c_mtm(10))*(1-params.c_mtm(11).*abs(camber));
B=(params.c_mtm(4)*(load/1000).^2+params.c_mtm(5)*load/1000)*(1-params.c_mtm(7).*abs(camber)).*exp(-params.c_mtm(6).*load/1000)/C./D;
Sh=0;
Sv=0;
Mz=D.*sin(C*atan(B.*(1-E).*(slip+Sh)+E.*atan(B.*(slip+Sh))))+Sv;

Mz(load<0)=0;

end

%  Sh=params.c_mtm(12)*camber+params.c_mtm(13)*load/1000+params.c_mtm(14);
%  Sv=(params.c_mtm(15)*(load/1000)^2+params.c_mtm(16)*load/1000)*camber+params.c_mtm(17)*load/1000+params.c_mtm(18);
%  
