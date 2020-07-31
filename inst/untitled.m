
for i=1:100

l=1;
v=10;
m=3;

a=i/100*l;
b=l-a;
k=0.3*m;
rsq=0.21*l*l;
I=m*rsq;

M=m*(a^2+rsq)/l^2;
C=m*(a*b-rsq)*v/l^3;
A=1/l;
Kd=k;
Bd=0;
Kk=-C*v;
Bk=-A*v;

AA=[M 0 0; 0 1 0; 0 0 1];
BB=[C Kd Kk; -1 0 0; -A -Bd -Bk];

lam(:,i)=eig(-AA\BB);

end


plot(1:100,real(lam),1:100,imag(lam));








