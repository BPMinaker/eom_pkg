function trac=tire_comb(slip,load,ratio,camber)

global params;

slip=slip.*(180/pi*ratio+100*(1-ratio));

C=params.a_mtm(1)*ratio+params.b_mtm(1)*(1-ratio);
mu_p=(params.a_mtm(2)*ratio+params.b_mtm(2)*(1-ratio)).*load/1000+ (params.a_mtm(3)*ratio+params.b_mtm(3)*(1-ratio));
D=mu_p.*load/1000;

Ea=params.a_mtm(7)*load/1000+params.a_mtm(8);
Eb=params.b_mtm(7)*(load/1000).^2+params.b_mtm(8)*load/1000+params.b_mtm(9);
E=ratio.*Ea+(1-ratio).*Eb;

Ba=params.a_mtm(4)*sin(2*atan(load/1000/params.a_mtm(5))).*(1-params.a_mtm(6)*abs(camber))./C./D;
Bb=(params.b_mtm(4)*(load/1000).^2+params.b_mtm(5)*load/1000).*exp(-params.b_mtm(6)*load/1000)./C./D;
B=ratio.*Ba+(1-ratio).*Bb;

Sh=0;
trac=D.*sin(C.*atan(B.*(1-E).*(slip+Sh)+E.*atan(B.*(slip+Sh))));

trac(load<0)=0;

end  %% Leave

%Sh=params.b_mtm(10)*load/1000+params.b_mtm(11);
