function sys_out =  grad_descent_estimator(t,var)

global a b g u am
disp(t);
sys_out = zeros(length(var),1);

x = var(1);
phi1 = var(2);
phi2 = var(3);
theta1_est = var(4);
theta2_est = var(5);

xdot = -a*x+b*u(t);
phi1_dot = -am*phi1+x;   
phi2_dot = -am*phi2+u(t);       
e = x - (theta1_est*phi1 + theta2_est*phi2);
theta1_est_dot = g*e*phi1;
theta2_est_dot = g*e*phi2;

sys_out(1) = xdot;
sys_out(2) = phi1_dot;
sys_out(3) = phi2_dot;
sys_out(4) = theta1_est_dot;
sys_out(5) = theta2_est_dot;

end