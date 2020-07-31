

clear all
clc


%A=[eye(4);-eye(4)];
%b=[ones(4,1);zeros(4,1)];

%option=gaoptimset('InitialPopulation',[0.5 0.5 0.5 0.5]);

%params=ga(@penalty_fn,4,A,b,[],[],[],[],[],[],option)


params=fminsearch(@penalty_fn,[0.5 0.5 0.5 0.5])

item.kf=params(1);
item.kr=params(2);
item.cf=params(3);
item.cr=params(4);
%item.tf=params(5);
%item.tr=params(6);

eqns=run_eom('Baja2013',item);