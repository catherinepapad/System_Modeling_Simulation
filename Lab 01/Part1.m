%% Setup
clear
close all

refine=10;
options=odeset('Refine',refine);

l = 5;      %Double pole

%tspan=[0 10];
tspan = 0:.01:10;
y0=[0;0];

%% Calculate y Values from diff eq
[tsol,ysol] = ode45(@(t,y)f(t,y),tspan,y0,options);
% figure
% plot(tsol,ysol(:,1));

%% Calculate u Values
u = 15*sin(3*tsol) + 8;                     

%% Calculate phi matrix
filter1 = tf(1,[1 2*l l*l]);
[phi1,~] = lsim(filter1,u,tsol);               %First column of matrix

filter2 = tf([1 0],[1 2*l l*l]);
[phi2,~] = lsim(filter2,ysol(:,1),tsol);       %Second column of matrix

[phi3,~] = lsim(filter1,ysol(:,1),tsol);       %Third column of matrix

phi = [phi1 phi2 phi3];                     %phi matrix

phi_new = phi' * phi;

phi_new_inv = inv(phi_new);

z = ysol(:,1)'*phi;                         %z matrix = y_transpose * phi

%% Estimate theta matrix and m,k,b values
%theta = z*phi_new_inv;
theta = z/phi_new;
disp('Estimated theta matrix: ')
disp(theta)

m_hat = 1/theta(1);
b_hat = (2*l-theta(2))*m_hat;
k_hat = (l*l-theta(3))*m_hat;
disp(['Estimated value of m: ', num2str(m_hat)])
disp(['Estimated value of b: ', num2str(b_hat)])
disp(['Estimated value of k: ', num2str(k_hat)])

%% Least Squares Method
N = size(tsol);
N = N(1,1);
y_hat = [];

for k=1:1:N
%    ysol(k,1)
   val = theta*phi(k,:)';
   y_hat = [y_hat;val]; 
end

%% Plots
figure
subplot(2,1,1);
plot(tsol,ysol(:,1),"-",'LineWidth',1)
xlabel('Time (t)','Interpreter','latex','fontsize',14) 
ylabel('$y(t)$','Interpreter','latex','fontsize',14)
ylim([-0.5 7])
grid on
l = legend('$y$');
set(l, 'interpreter', 'latex')
title('Plot of actual and estimated values of y using the Least Squares Method','Interpreter','latex','fontsize',14)

subplot(2,1,2);
plot(tsol,y_hat,"r-",'LineWidth',1)
l = legend('$\hat{y}$');
set(l, 'interpreter', 'latex')
xlabel('Time (t)','Interpreter','latex','fontsize',14) 
ylabel('$\hat{y}(t)$','Interpreter','latex','fontsize',14)
ylim([-0.5 7])
grid on

figure
e = ysol(:,1) - y_hat;
plot(tsol,e,"-",'LineWidth',1)
legend('e', 'interpreter', 'latex');
xlabel('Time (t)', 'interpreter', 'latex','fontsize',14) 
ylabel('Error e(t)', 'interpreter', 'latex','fontsize',14)
grid on
title('Plot of error $e = y - \hat{y}$', 'interpreter', 'latex','fontsize',14)


%% Differential Equation of Given System
function yval = f(t,y)
m = 10;      %mass
b = 0.5;     %damper consant
k = 2.5;     %spring constant    

u = 15*sin(3*t) + 8; %external force

pos = y(1,1);
vel = y(2,1);

yval(1,1) = vel;
yval(2,1) = (u - b*vel - k*pos)/m;
end