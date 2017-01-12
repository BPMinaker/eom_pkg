m=sym('m');
r=sym('r');
g=sym('g');
l=sym('l');
c=sym('c');
k=sym('k');
s=sym('s');

M=[1/12*m*l^2 0; 0 3/2*m*r^2];
C=[0 0;0 0];
K=[k+m*g*r -m*g*r;-m*g*r 0];

A=[zeros(2) eye(2); -M\K -M\C]

lambda=eig(A)

K2=[m*g*r -m*g*r;-m*g*r 0];

lam2=[sqrt(-eig(M\K2)); -sqrt(-eig(M\K2))]


r=0.25;
m=1;

k=5*0;
c=0.5*0;
l=1;
g=9.81;

format long

eval(A)
eval(det(eye(4)*s-A))

eval(det(M*s^2+K2))*128

eval(lambda)

eval(lam2)
