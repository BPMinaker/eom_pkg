function pnlty=penalty_fn(params)

item.kf=params(1);
item.kr=params(2);
item.cf=params(3);
item.cr=params(4);
%item.tf=params(5);
%item.tr=params(6);


eqns=run_eom('Baja2013',item,'quiet');

[vec,val]=eig(eqns.a, eqns.e);

rnd=1e-2;
val=rnd*round(val/rnd);
val=diag(val);

ind=find(imag(val)~=0);

val=val(ind);
vec=vec(:,ind);

val=sort(val(1:2:length(ind)));

%vec=vec(:,1:2:length(ind));

% mat=eqns.c*vec;
% 
% for i=1:(length(ind))/2
% 	mat(:,i)=mat(:,i)/max(mat(:,i));
% end	
% 
% 
% [~,ind]=max(mat,[],2);

%eqns.c*vec
%abs(eqns.c*vec)*10
%ind
%scr

%val=val(ind)

if (length(val)<3)

	pnlty=100;

else
	
val=val(1:3)

wn=2*pi*[1.5;1.8;2];
zeta=0.3;

a=-wn*zeta;
b=((1-zeta^2)*wn.^2).^(0.5);


pnlty=sqrt(sum((a-real(val)).^2)+sum((b-abs(imag(val))).^2))



end


% temp=sort(val);
% 
% if(length(temp)<6)
% 	pad=6-length(temp);
% 	temp=[temp;zeros(pad,1)];
% end
% 
% result=abs([temp(1);temp(3);temp(5)])


%result=abs(diag(val(ind,ind)));


