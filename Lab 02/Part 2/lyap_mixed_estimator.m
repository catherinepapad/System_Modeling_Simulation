function sys_out =  lyap_mixed_estimator(t,var,mode)

global theta1 theta2 thetam gamma1 gamma2 u h

sys_out = zeros(length(var),1);

if mode == 0
    x = var(1);
elseif mode == 1
    x = var(1) + h(t);
end

theta1_est = var(2);
theta2_est = var(3);
x_est = var(4);

xdot = -theta1*x+theta2*u(t);
e = x - x_est;
theta1_est_dot = -gamma1*e*x;
theta2_est_dot = gamma2*e*u(t);
x_est_dot = -theta1_est*x + theta2_est*u(t) + thetam*e;

sys_out(1) = xdot;
sys_out(2) = theta1_est_dot;
sys_out(3) = theta2_est_dot;
sys_out(4) = x_est_dot;

end