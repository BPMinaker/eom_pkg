function trac=tire_long(slip,load);

global params;

slip=slip*100;
C=params.b_mtm(1);
mu_p=params.b_mtm(2)*load/1000+params.b_mtm(3);
D=mu_p.*load/1000;
B=(params.b_mtm(4)*(load/1000).^2+params.b_mtm(5)*load/1000).*exp(-params.b_mtm(6)*load/1000)/C./D;
E=params.b_mtm(7)*(load/1000).^2+params.b_mtm(8)*load/1000+params.b_mtm(9);
Sh=0;
trac=D.*sin(C*atan(B.*(1-E).*(slip+Sh)+E.*atan(B.*(slip+Sh))));

trac(load<0)=0;

end  %% Leave

%Sh=params.b_mtm(10)*load/1000+params.b_mtm(11);
