function sys_out =  lyap_2ndorder_mixed_estimator(t,var)

global a11 a12 a21 a22 b1 b2 g A B C gamma1 gamma2 u

sys_out = zeros(length(var),1);

x1 = var(1);
x2 = var(2);
x1_est = var(3);
x2_est = var(4);
a11_est = var(5);
a12_est = var(6);
a21_est = var(7);
a22_est = var(8);
b1_est = var(9);
b2_est = var(10);

e1 = x1 - x1_est;
e2 = x2 - x2_est;

x1dot = a11*x1 + a12*x2 + b1*u(t);
x2dot = a21*x1 + a22*x2 + b2*u(t);
x1_est_dot = a11_est*x1 + a12_est*x2 + b1_est*u(t) + g*e1;
x2_est_dot = a21_est*x1 + a22_est*x2 + b2_est*u(t) + g*e2;
% a11_est = gamma1*e1*x1_est;
% a12_est = gamma1*e1*x2_est;
% a21_est = gamma1*e2*x1_est;
% a22_est = gamma1*e2*x2_est;
a11_est = gamma1*e1*x1;
a12_est = gamma1*e1*x2;
a21_est = gamma1*e2*x1;
a22_est = gamma1*e2*x2;
b1_est = gamma2*e1*u(t);
b2_est = gamma2*e2*u(t);

sys_out(1) = x1dot;
sys_out(2) = x2dot;
sys_out(3) = x1_est_dot;
sys_out(4) = x2_est_dot;
sys_out(5) = a11_est;
sys_out(6) = a12_est;
sys_out(7) = a21_est;
sys_out(8) = a22_est;
sys_out(9) = b1_est;
sys_out(10) = b2_est;


end