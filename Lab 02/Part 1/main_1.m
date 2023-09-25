%% SETUP & INPUT DATA 
clear 
clc
close all

time = 0:0.1:20;    %time

global a b g u am

a = 3;              %system parameter
b = 0.5;            %system parameter

%u = @(t) 10*sin(3*t);   %first system input
u = @(t) 10;            %second system input


g = 120;             %gamma
am = 3;             %pole of filter    

%% ESTIMATE PARAMETERS 
initial_cond = [0 0 0 0 0];
    
[t_out,var_out] = ode45(@(t,var) grad_descent_estimator(t,var), time, initial_cond);


x = var_out(:,1);               %real x
phi1 = var_out(:,2);            %phi1 
phi2 = var_out(:,3);            %phi2
theta1_est = var_out(:,4);      %estimated theta1
theta2_est = var_out(:,5);      %estimated theta2

theta_est = [theta1_est theta2_est];    %estimated theta matrix
phi = [phi1 phi2];                      %phi matrix

x_est = theta1_est.*phi1 + theta2_est.*phi2;    %estimated x

sz = size(time);
a_matrix = zeros(sz(2),1) + a;          %matrix with all values a        
b_matrix = zeros(sz(2),1) + b;          %matrix with all values b
am_matrix = zeros(sz(2),1) + am;        %matrix with all values am

a_est = am_matrix - theta1_est;         %estimated a
b_est = theta2_est;                     %estimated b


%% PLOT
figure
subplot(2,1,1)
plot(t_out,x)
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of x','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(t_out,x_est)
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of $\hat{x}$','Interpreter', 'latex','FontSize',15)
sgtitle({'Plot of actual and estimated output';['$\gamma$ =',num2str(g),' , $a_m$ = ',num2str(am)]},'Interpreter', 'latex','FontSize',20)

figure
plot(t_out,x - x_est)
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of error $x - \hat{x}$','Interpreter', 'latex','FontSize',15)

figure
subplot(2,1,1)
plot(t_out,a_matrix,'r')
hold on
plot(t_out,a_est,'b')
xlim([0 time(sz(2))])
xlabel('Time [s]')
legend('$a$','$\hat{a}$','interpreter','latex')
title('Plot of $a$ and $\hat{a}$','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(t_out,b_matrix,'r')
hold on
plot(t_out,b_est,'b')
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of $b$ and $\hat{b}$','Interpreter', 'latex','FontSize',15)
legend('$b$','$\hat{b}$','interpreter','latex')
sgtitle({'Plot of actual and estimated values of system parameters';['$\gamma$ =',num2str(g),' , $a_m$ = ',num2str(am)]},'Interpreter', 'latex','FontSize',20)


figure
subplot(2,1,1)
plot(t_out,a_matrix - a_est)
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of error $a - \hat{a}$','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(t_out,b_matrix - b_est)
title('Plot of error $b - \hat{b}$','Interpreter', 'latex','FontSize',15)
xlim([0 time(sz(2))])
xlabel('Time [s]')
sgtitle({'Plot of parameter estimation errors';['$\gamma$ =',num2str(g),' , $a_m$ = ',num2str(am)]},'Interpreter', 'latex','FontSize',20)
