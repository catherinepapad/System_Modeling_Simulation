%% SETUP & INPUT DATA 
clear 
clc
close all

time = 0:0.05:20;    %time

global theta1 theta2 thetam gamma1 gamma2 u h

theta1 = 3;                         %system parameter
theta2 = 0.5;                       %system parameter

u = @(t) 10*sin(3*t);               %system input

h0 = 0.5;                           %noise amplitude
f = 40;                             %noise frequency
h = @(t) h0*sin(2*pi*f*t);          %noise

thetam = 3;                         %mixed configuration parameter 

gamma1 = 10;                        %Lyapunov method parameter
gamma2 = 1;                        %Lyapunov method parameter   

%Choose mode: mode = 0 -> no noise / mode = 1 -> with noise

%% ------------------- PARALLEL CONFIGURATION ---------------------------------------------------------
%% PARALLEL CONFIGURATION , ESTIMATE PARAMETERS WITHOUT NOISE
mode = 0;
initial_cond = [0 0 0 0 ];
    
[t_out,var_out_parallel] = ode45(@(t,var) lyap_parallel_estimator(t,var,mode), time, initial_cond);

x_nonoise_parallel = var_out_parallel(:,1);               %real x
theta1_est_nonoise_parallel = var_out_parallel(:,2);      %estimated theta1
theta2_est_nonoise_parallel = var_out_parallel(:,3);      %estimated theta2
x_est_nonoise_parallel = var_out_parallel(:,4);           %estimated x    

sz = size(time);
theta1_matrix_parallel = zeros(sz(2),1) + theta1;          %matrix with all values theta1        
theta2_matrix_parallel = zeros(sz(2),1) + theta2;          %matrix with all values theta2

theta1_final_est_nonoise_parallel = theta1_est_nonoise_parallel;             %final estimated value of theta1
theta2_final_est_nonoise_parallel = theta2_est_nonoise_parallel;             %final estimated value of theta2

%% PARALLEL CONFIGURATION , ESTIMATE PARAMETERS WITH NOISE
mode = 1;
initial_cond = [0 0 0 0 ];
    
[~,var_out_parallel] = ode45(@(t,var) lyap_parallel_estimator(t,var,mode), time, initial_cond);


x_noise_parallel = var_out_parallel(:,1);               %real x
theta1_est_noise_parallel = var_out_parallel(:,2);      %estimated theta1
theta2_est_noise_parallel = var_out_parallel(:,3);      %estimated theta2
x_est_noise_parallel = var_out_parallel(:,4);           %estimated x    

theta1_final_est_noise_parallel = theta1_est_noise_parallel;             %final estimated value of theta1
theta2_final_est_noise_parallel = theta2_est_noise_parallel;             %final estimated value of theta2

%% PLOTS FOR PARALLEL CONFIGURATION
figure
subplot(2,1,1)
plot(t_out,x_nonoise_parallel)
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of $x$ without noise','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(t_out,x_est_nonoise_parallel)
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of $\hat{x}$ without noise','Interpreter', 'latex','FontSize',15)
sgtitle({'Parallel Configuration';'Plot of actual and estimated output without noise';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2)]},'Interpreter', 'latex','FontSize',20)

figure
subplot(2,1,1)
plot(t_out,x_noise_parallel)
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of $x$ with noise','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(t_out,x_est_noise_parallel)
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of $\hat{x}$ with noise','Interpreter', 'latex','FontSize',15)
sgtitle({'Parallel Configuration';'Plot of actual and estimated output with noise';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2),' , $\eta_0$ = ',num2str(h0),' , $f$ = ',num2str(f)]},'Interpreter', 'latex','FontSize',20)


figure
subplot(2,1,1)
plot(t_out,x_nonoise_parallel - x_est_nonoise_parallel)
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of error without noise','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(t_out,x_noise_parallel - x_est_noise_parallel)
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of error with noise','Interpreter', 'latex','FontSize',15)
sgtitle({'Parallel Configuration';'Plot of error $x - \hat{x}$';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2),' , $\eta_0$ = ',num2str(h0),' , $f$ = ',num2str(f)]},'Interpreter', 'latex','FontSize',20)

figure
subplot(2,1,1)
plot(t_out,theta1_matrix_parallel,'k')
hold on
plot(t_out,theta1_final_est_nonoise_parallel,'b')
hold on
plot(t_out,theta1_final_est_noise_parallel,'r')
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of $\theta_1$ and $\hat{\theta}_1$','Interpreter', 'latex','FontSize',15)
legend('$\theta_1$','$\hat{\theta}_1$ without noise','$\hat{\theta}_1$ with noise','interpreter','latex')
subplot(2,1,2)
plot(t_out,theta2_matrix_parallel,'k')
hold on
plot(t_out,theta2_final_est_nonoise_parallel,'b')
hold on
plot(t_out,theta2_final_est_noise_parallel,'r')
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of $\theta_2$ and $\hat{\theta}_2$','Interpreter', 'latex','FontSize',15)
legend('$\theta_2$','$\hat{\theta}_2$ without noise','$\hat{\theta}_2$ with noise','interpreter','latex')
sgtitle({'Parallel Configuration';'Plot of actual and estimated values of $\theta_1$ and $\theta_2$';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2),' , $\eta_0$ = ',num2str(h0),' , $f$ = ',num2str(f)]},'Interpreter', 'latex','FontSize',20)

figure
subplot(2,1,1)
plot(t_out,theta1_matrix_parallel - theta1_final_est_nonoise_parallel,'b')
hold on
plot(t_out,theta1_matrix_parallel - theta1_final_est_noise_parallel,'r')
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of error $\theta_1 - \hat{\theta}_1$','Interpreter', 'latex','FontSize',15)
legend('Without noise','With noise')
subplot(2,1,2)
plot(t_out,theta2_matrix_parallel - theta2_final_est_nonoise_parallel,'b')
hold on
plot(t_out,theta2_matrix_parallel - theta2_final_est_noise_parallel,'r')
xlim([0 time(sz(2))])
xlabel('Time [s]')
title('Plot of error $\theta_2 - \hat{\theta}_2$','Interpreter', 'latex','FontSize',15)
legend('Without noise','With noise')
sgtitle({'Parallel Configuration';'Plot of parameter estimation errors';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2),' , $\eta_0$ = ',num2str(h0),' , $f$ = ',num2str(f)]},'Interpreter', 'latex','FontSize',20)


%% -----------------------------------------------------------------------------------------------------------------------------------------------------------

%% ------------------- MIXED CONFIGURATION ---------------------------------------------------------
%% MIXED CONFIGURATION ,  ESTIMATE PARAMETERS WITHOUT NOISE
% mode = 0;
% initial_cond = [0 0 0 0 ];
%     
% [t_out,var_out_mixed] = ode45(@(t,var) lyap_mixed_estimator(t,var,mode), time, initial_cond);
% 
% 
% x_nonoise_mixed = var_out_mixed(:,1);               %real x
% theta1_est_nonoise_mixed = var_out_mixed(:,2);      %estimated theta1
% theta2_est_nonoise_mixed = var_out_mixed(:,3);      %estimated theta2
% x_est_nonoise_mixed = var_out_mixed(:,4);           %estimated x    
% 
% sz = size(time);
% theta1_matrix_mixed = zeros(sz(2),1) + theta1;          %matrix with all values theta1        
% theta2_matrix_mixed = zeros(sz(2),1) + theta2;          %matrix with all values theta2
% 
% theta1_final_est_nonoise_mixed = theta1_est_nonoise_mixed;             %final estimated value of theta1
% theta2_final_est_nonoise_mixed = theta2_est_nonoise_mixed;             %final estimated value of theta2

%% MIXED CONFIGURATION , ESTIMATE PARAMETERS WITH NOISE
% mode = 1;
% initial_cond = [0 0 0 0 ];
%     
% [~,var_out_mixed] = ode45(@(t,var) lyap_mixed_estimator(t,var,mode), time, initial_cond);
% 
% 
% x_noise_mixed = var_out_mixed(:,1);               %real x
% theta1_est_noise_mixed = var_out_mixed(:,2);      %estimated theta1
% theta2_est_noise_mixed = var_out_mixed(:,3);      %estimated theta2
% x_est_noise_mixed = var_out_mixed(:,4);           %estimated x    
% 
% theta1_final_est_noise_mixed = theta1_est_noise_mixed;             %final estimated value of theta1
% theta2_final_est_noise_mixed = theta2_est_noise_mixed;             %final estimated value of theta2


%% PLOTS FOR MIXED CONFIGURATION
% figure
% subplot(2,1,1)
% plot(t_out,x_nonoise_mixed)
% xlim([0 time(sz(2))])
% xlabel('Time [s]')
% title('Plot of $x$ without noise','Interpreter', 'latex','FontSize',15)
% subplot(2,1,2)
% plot(t_out,x_est_nonoise_mixed)
% xlim([0 time(sz(2))])
% xlabel('Time [s]')
% title('Plot of $\hat{x}$ without noise','Interpreter', 'latex','FontSize',15)
% sgtitle({'Mixed Configuration';'Plot of actual and estimated output without noise';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2),' , $\theta_m$ = ',num2str(thetam)]},'Interpreter', 'latex','FontSize',20)
% 
% figure
% subplot(2,1,1)
% plot(t_out,x_noise_mixed)
% xlim([0 time(sz(2))])
% xlabel('Time [s]')
% title('Plot of $x$ with noise','Interpreter', 'latex','FontSize',15)
% subplot(2,1,2)
% plot(t_out,x_est_noise_mixed)
% xlim([0 time(sz(2))])
% xlabel('Time [s]')
% title('Plot of $\hat{x}$ with noise','Interpreter', 'latex','FontSize',15)
% sgtitle({'Mixed Configuration';'Plot of actual and estimated output with noise';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2),' , $\theta_m$ = ',num2str(thetam),' , $\eta_0$ = ',num2str(h0),' , $f$ = ',num2str(f)]},'Interpreter', 'latex','FontSize',20)
% 
% figure
% subplot(2,1,1)
% plot(t_out,x_nonoise_mixed - x_est_nonoise_mixed)
% xlim([0 time(sz(2))])
% xlabel('Time [s]')
% title('Plot of error without noise','Interpreter', 'latex','FontSize',15)
% subplot(2,1,2)
% plot(t_out,x_noise_mixed - x_est_noise_mixed)
% xlim([0 time(sz(2))])
% xlabel('Time [s]')
% title('Plot of error with noise','Interpreter', 'latex','FontSize',15)
% sgtitle({'Mixed Configuration';'Plot of error $x - \hat{x}$';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2),' , $\theta_m$ = ',num2str(thetam),' , $\eta_0$ = ',num2str(h0),' , $f$ = ',num2str(f)]},'Interpreter', 'latex','FontSize',20)
% 
% figure
% subplot(2,1,1)
% plot(t_out,theta1_matrix_mixed,'k')
% hold on
% plot(t_out,theta1_final_est_nonoise_mixed,'b')
% hold on
% plot(t_out,theta1_final_est_noise_mixed,'r')
% xlim([0 time(sz(2))])
% xlabel('Time [s]')
% title('Plot of $\theta_1$ and $\hat{\theta}_1$','Interpreter', 'latex','FontSize',15)
% legend('$\theta_1$','$\hat{\theta}_1$ without noise','$\hat{\theta}_1$ with noise','interpreter','latex')
% subplot(2,1,2)
% plot(t_out,theta2_matrix_mixed,'k')
% hold on
% plot(t_out,theta2_final_est_nonoise_mixed,'b')
% hold on
% plot(t_out,theta2_final_est_noise_mixed,'r')
% xlim([0 time(sz(2))])
% xlabel('Time [s]')
% title('Plot of $\theta_2$ and $\hat{\theta}_2$','Interpreter', 'latex','FontSize',15)
% legend('$\theta_2$','$\hat{\theta}_2$ without noise','$\hat{\theta}_2$ with noise','interpreter','latex')
% sgtitle({'Mixed Configuration';'Plot of actual and estimated values of $\theta_1$ and $\theta_2$';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2),' , $\theta_m$ = ',num2str(thetam),' , $\eta_0$ = ',num2str(h0),' , $f$ = ',num2str(f)]},'Interpreter', 'latex','FontSize',20)
% 
% figure
% subplot(2,1,1)
% plot(t_out,theta1_matrix_mixed - theta1_final_est_nonoise_mixed,'b')
% hold on
% plot(t_out,theta1_matrix_mixed - theta1_final_est_noise_mixed,'r')
% xlim([0 time(sz(2))])
% xlabel('Time [s]')
% title('Plot of error $\theta_1 - \hat{\theta}_1$','Interpreter', 'latex','FontSize',15)
% legend('Without noise','With noise')
% subplot(2,1,2)
% plot(t_out,theta2_matrix_mixed - theta2_final_est_nonoise_mixed,'b')
% hold on
% plot(t_out,theta2_matrix_mixed - theta2_final_est_noise_mixed,'r')
% xlim([0 time(sz(2))])
% xlabel('Time [s]')
% title('Plot of error $\theta_2 - \hat{\theta}_2$','Interpreter', 'latex','FontSize',15)
% legend('Without noise','With noise')
% sgtitle({'Mixed Configuration';'Plot of parameter estimation errors';['$\gamma_1$ =',num2str(gamma1),' , $\gamma_2$ = ',num2str(gamma2),' , $\theta_m$ = ',num2str(thetam),' , $\eta_0$ = ',num2str(h0),' , $f$ = ',num2str(f)]},'Interpreter', 'latex','FontSize',20)