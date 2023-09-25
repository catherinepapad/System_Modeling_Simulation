%% Setup
clear
close all

l1 = 100;       %Double pole for first filter
l2 = 100;       %Double pole for second filter

t_in = 0;
t_fin = 15;
step = 0.0001;
N = (t_fin - t_in)/step;
t = linspace(t_in,t_fin,N);

%% Calculate V_R and V_C values from v.p file
[VR, VC] = v(t);

% figure
% plot(t,VR)
% title('VR')

% figure
% plot(t,VC)
% title('VC')

%% Calculate u_1 and u_2 values 
u1 = 2*sin(4*t);

% figure
% plot(t,u1)
% title('u_1')

u2(1:1,1:N) = 4;

% figure
% plot(t,u2)
% title('u_2')


%% CREATE OULIERS FOR VR
n1 = randsample(N,3);

VR(n1(1)) = 100*VR(n1(1));
VR(n1(2)) = 100*VR(n1(2));
VR(n1(3)) = 100*VR(n1(3));

% figure
% plot(t,VR)
% title('VR new')

%% CREATE OUTLIERS FOR VC
n2 = randsample(N,3);

VC(n2(1)) = 100*VC(n2(1));
VC(n2(2)) = 100*VC(n2(2));
VC(n2(3)) = 100*VC(n2(3));

% figure
% plot(t,VC)
% title('VC new')
%% CALCULATIONS FOR VR
disp('Calculation for VR')

%% Calculate phi1 matrix 
filter11 = tf(1,[1 2*l1 l1*l1]);                %1/L1
filter12 = tf([1 0],[1 2*l1 l1*l1]);            %s/L1
filter13 = tf([1 0 0],[1 2*l1 l1*l1]);          %s^2/L1

[phi11,~] = lsim(filter11,VR,t);
[phi12,~] = lsim(filter12,VR,t);
[phi13,~] = lsim(filter11,u1,t);
[phi14,~] = lsim(filter13,u1,t);
[phi15,~] = lsim(filter11,u2,t);
[phi16,~] = lsim(filter13,u2,t);

phi1 = [phi11 phi12 phi13 phi14 phi15 phi16];       %phi1 matrix

phi1_new = phi1' *phi1;

phi1_new_inv = inv(phi1_new);

z1 = VR * phi1;                                 %%z1 matrix = VR_transpose * phi1         
%% Estimate theta1 matrix and LC , RC values
%theta1 = z1*phi1_new_inv;
theta1 = z1/phi1_new;
disp('Estimated theta1 matrix: ')
disp(theta1)

LC_hat_1_1 = 1/theta1(1,3);
LC_hat_1_2 = 1/(l1*l1 - theta1(1,1));
RC_hat_1 = 1/(2*l1-theta1(1,2));
disp(['First estimated value of LC: ', num2str(LC_hat_1_1)])
disp(['Second estimated value of LC: ', num2str(LC_hat_1_2)])
disp(['Estimated value of RC: ', num2str(RC_hat_1)])
%% Least Squares Method for VR
VR_hat = [];

for k=1:1:N
   val = theta1*phi1(k,:)';
   VR_hat = [VR_hat;val]; 
end

VR_hat = VR_hat';

%% Find error
e1 = VR - VR_hat;

%% Plots
figure
subplot(2,1,1);
plot(t,VR,"-",'LineWidth',1)
xlabel('Time (t)','Interpreter','latex','fontsize',14) 
ylabel('$V_R(t)$','Interpreter','latex','fontsize',14)
grid on
l = legend('$V_R$');
set(l, 'interpreter', 'latex')
title('Plot of actual and estimated values of $V_R$ with ouliers using the Least Squares Method','Interpreter','latex','fontsize',14)

subplot(2,1,2);
plot(t,VR_hat,"r-",'LineWidth',1)
xlabel('Time (t)','Interpreter','latex','fontsize',14) 
ylabel('$\hat{V}_R(t)$','Interpreter','latex','fontsize',14)
grid on
l = legend('$\hat{V}_R$');
set(l, 'interpreter', 'latex')

figure
plot(t,e1,"-",'LineWidth',1)
legend('e', 'interpreter', 'latex');
xlabel('Time (t)', 'interpreter', 'latex','fontsize',14) 
ylabel('Error e(t)', 'interpreter', 'latex','fontsize',14)
grid on
title('Plot of error $e = V_R - \hat{V}_R$ with ouliers', 'interpreter', 'latex','fontsize',14)

%% CALCULATIONS FOR VR
fprintf('\n');
disp('Calculation for VC')

%% Calculate phi2 matrix 
filter21 = tf(1,[1 2*l2 l2*l2]);                %1/L2
filter22 = tf([1 0],[1 2*l2 l2*l2]);            %s/L2

[phi21,~] = lsim(filter21,VC,t);
[phi22,~] = lsim(filter22,VC,t);
[phi23,~] = lsim(filter21,u1,t);
[phi24,~] = lsim(filter22,u1,t);
[phi25,~] = lsim(filter21,u2,t);
[phi26,~] = lsim(filter22,u2,t);

phi2 = [phi21 phi22 phi23 phi24 phi25 phi26];       %phi2 matrix

phi2_new = phi2' *phi2;

phi2_new_inv = inv(phi2_new);

z2 = VC * phi2;                                 %%z2 matrix = VC_transpose * phi2         

%% Estimate theta2 matrix and LC , RC values
%theta2 = z2*phi2_new_inv;
theta2 = z2/phi2_new;
disp('Estimated theta2 matrix: ')
disp(theta2)

LC_hat_2_1 = 1/theta2(1,5);
LC_hat_2_2 = 1/(l2*l2 - theta2(1,1));
RC_hat_2_1 = 1/(2*l2 - theta2(1,2));
RC_hat_2_2 = theta2(1,4);
RC_hat_2_3 = theta2(1,6);
disp(['First estimated value of LC: ', num2str(LC_hat_2_1)])
disp(['Second estimated value of LC: ', num2str(LC_hat_2_2)])
disp(['First estimated value of RC: ', num2str(RC_hat_2_1)])
disp(['Second estimated value of RC: ', num2str(RC_hat_2_2)])
disp(['Third estimated value of RC: ', num2str(RC_hat_2_3)])

%% Least Squares Method for VC
VC_hat = [];

for k=1:1:N
   val = theta2*phi2(k,:)';
   VC_hat = [VC_hat;val]; 
end

VC_hat = VC_hat';

%% Find error
e2 = VC - VC_hat;

%% Plots
figure
subplot(2,1,1);
plot(t,VC,"-",'LineWidth',0.5)
xlabel('Time (t)','Interpreter','latex','fontsize',14) 
ylabel('$V_C(t)$','Interpreter','latex','fontsize',14)
grid on
l = legend('$V_C$');
set(l, 'interpreter', 'latex')
title('Plot of actual and estimated values of $V_C$ with ouliers using the Least Squares Method','Interpreter','latex','fontsize',14)

subplot(2,1,2);
plot(t,VC_hat,"r-",'LineWidth',0.5)
plot(t,VC_hat,"r-",'LineWidth',1)
xlabel('Time (t)','Interpreter','latex','fontsize',14) 
ylabel('$\hat{V}_C(t)$','Interpreter','latex','fontsize',14)
grid on
l = legend('$\hat{V}_C$');
set(l, 'interpreter', 'latex')

figure
plot(t,e2,"-",'LineWidth',0.5)
legend('e', 'interpreter', 'latex');
xlabel('Time (t)', 'interpreter', 'latex','fontsize',14) 
ylabel('Error e(t)', 'interpreter', 'latex','fontsize',14)
grid on
title('Plot of error $e = V_C - \hat{V}_C$ with ouliers', 'interpreter', 'latex','fontsize',14)