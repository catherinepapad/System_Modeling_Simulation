%% SETUP & INPUT DATA 
clear 
clc
%close all

time = 0:0.1:15;    %time

global a11 a12 a21 a22 b1 b2 g A B C gamma1 gamma2 u

a11 = -0.25;
a12 = 3;
a21 = -5;
a22 = 0;
b1 = 0.5;
b2 = 1.5;

A = [a11 a12 ; a21 a22];               %system parameter
B = [b1 ; b2];                         %system parameter

u = @(t) 3.5*sin(7.2*t)+2*sin(11.7*t);               %system input

g = 5;
C = [g 0 ; 0 g];                   %mixed configuration parameter 

gamma1 = 100;                        %Lyapunov method parameter
gamma2 = 100;                        %Lyapunov method parameter   

%% ------------------- MIXED CONFIGURATION 2nd ORDER SYSTEM ---------------------------------------------------------
%% ESTIMATE PARAMETERS
initial_cond = [0 0 0 0 0 0 0 0 0 0];
    
[t_out,var_out] = ode45(@(t,var) lyap_2ndorder_mixed_estimator(t,var), time, initial_cond);

x1 = var_out(:,1);                              %real x1
x2 = var_out(:,2);                              %real x2
x1_est = var_out(:,3);                          %estimated x1
x2_est = var_out(:,4);                          %estimated x2
a11_est = var_out(:,5);                         %estimated a11
a12_est = var_out(:,6);                         %estimated a12
a21_est = var_out(:,7);                         %estimated a21
a22_est = var_out(:,8);                         %estimated a22
b1_est = var_out(:,9);                          %estimated b1
b2_est = var_out(:,10);                         %estimated b2

sz = size(time);

%% PLOT
figure
subplot(2,1,1)
plot(t_out,x1,'b')
hold on
plot(t_out,x1_est,'r')
xlim([0 time(sz(2))])
xlabel('Time [s]')
legend('$x_1$','$\hat{x}_1$','interpreter','latex')
title('Plot of $x_1$','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(t_out,x2,'b')
hold on
plot(t_out,x2_est,'r')
xlim([0 time(sz(2))])
xlabel('Time [s]')
legend('$x_2$','$\hat{x}_2$','interpreter','latex')
title('Plot of $x_2$','Interpreter', 'latex','FontSize',15)
sgtitle({'Mixed Configuration - 2nd Order';'Plot of actual and estimated output';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2),' , $g$ = ',num2str(g)]},'Interpreter', 'latex','FontSize',20)

figure
subplot(2,1,1)
plot(t_out,x1 - x1_est)
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of error $e_1 = x_1 - \hat{x}_1$','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(t_out,x2 - x2_est)
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of error $e_2 = x_2 - \hat{x}_2$','Interpreter', 'latex','FontSize',15)
sgtitle({'Mixed Configuration - 2nd Order';'Plot of error $x - \hat{x}$';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2),' , $g$ = ',num2str(g)]},'Interpreter', 'latex','FontSize',20)


figure
subplot(2,1,1)
plot(t_out,a11_est,'b')
hold on
plot(t_out,a12_est,'r')
hold on
plot(t_out,a21_est,'k')
hold on
plot(t_out,a22_est,'g')
yline(a11,'b--','$a_{11}$','Interpreter', 'latex');
yline(a12,'r--','$a_{12}$','Interpreter', 'latex');
yline(a21,'k--','$a_{21}$','Interpreter', 'latex');
yline(a22,'g--','$a_{22}$','Interpreter', 'latex');
xlim([0 time(sz(2))])
xlabel('Time [s]')
legend('$\hat{a}_{11}$','$\hat{a}_{12}$','$\hat{a}_{21}$','$\hat{a}_{22}$','Interpreter', 'latex')
title('Plot of A matrix parameters','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(t_out,b1_est,'b')
hold on
plot(t_out,b2_est,'r')
yline(b1,'b--','$b_{1}$','Interpreter', 'latex');
yline(b2,'r--','$b_{2}$','Interpreter', 'latex');
xlim([0 time(sz(2))])
xlabel('Time [s]')
legend('$\hat{b}_{1}$','$\hat{b}_{2}$','Interpreter', 'latex')
title('Plot of B matrix parameters','Interpreter', 'latex','FontSize',15)
sgtitle({'Mixed Configuration - 2nd Order';'Plot of actual and estimated parameter values';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2),' , $g$ = ',num2str(g)]},'Interpreter', 'latex','FontSize',20)