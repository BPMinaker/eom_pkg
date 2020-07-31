function dss2ss(A,B,C,D,E)

[Q,S,P]=svd(E)

Q=Q'


Q*E*P


s=diag(S)
n=sum(s>1e-10)
S=diag(s(1:n))


Atilde=Q*A*P
Btilde=Q*B
Ctilde=C*P


A11=Atilde(1:n,1:n)
A12=Atilde(1:n,n+1:end)
A21=Atilde(n+1:end,1:n)
A22=Atilde(n+1:end,n+1:end)

B1=Btilde(1:n,:)
B2=Btilde(n+1:end,:)

C1=Ctilde(:,1:n)
C2=Ctilde(:,n+1:end)


A=S\(A11-A12*(A22\A21))
B=S\(B1-A12*(A22\B2))
C=C1-C2*(A22\A21)

D=D-C2*(A22\B2)

sys1=ss(A,B,C,D)

bode(sys1)
