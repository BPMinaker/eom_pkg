eqns=run_eom('input_ex_quarter_car');
[x,z]=random_road(6);

t=x/10;
[y,t]=lsim(eqns,z,t);
figure(2)
plot(t,[y,z']);
 
