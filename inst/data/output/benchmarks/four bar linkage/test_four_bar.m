params.c=0;
a=run_eom('input_ex_four_bar',1:1:1000,'quiet',params);

format long

norm(pole(a)-[2.14767663837i;-2.14767663837i])

a=run_eom('input_ex_four_bar',1:1:1000,'quiet');

format long

norm(pole(a)-[-0.2423858093+2.1339550282i;-0.2423858093-2.1339550282i])

