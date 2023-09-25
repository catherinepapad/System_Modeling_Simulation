clear
close all

rng('shuffle') 
syms time

%% Define time, test functions and coefficients
syms u1(time)  u2(time) u3(time) u4(time) u5(time) u6(time)

t = 0:0.01:20; 

u1(time) = 1;                   %step function
u2(time) = time;                %ramp function
u3(time) = time^2/4;            %parabolic function
u4(time) = diracCust(time);     %delta dirac
u5(time) = sin(2*time);         %low frequency sin 
u6(time) = cos(50*time);        %high ferquency cos 

a = -10 + 20*rand(6,1);         %vector with random coefficients

%% Calculate system's response for all the test functions 
[y1, ts] = sys(t, u1);
[y2, ~] = sys(t, u2);
[y3, ~] = sys(t, u3);
[y4, ~] = sys(t, u4);
[y5, ~] = sys(t, u5);
[y6, ~] = sys(t, u6);

%% Calculate system's response for combinations of coefficient*function
[y16, ~] = sys(t, a(1)*u1+a(6)*u6);
[y25, ~] = sys(t, a(2)*u2+a(5)*u5);
[y34, ~] = sys(t, a(3)*u3+a(4)*u4);

[y123456, ~] = sys(t, a(1)*u1+a(2)*u2+a(3)*u3+a(4)*u4+a(5)*u5+a(6)*u6);

%% Plots
figure
subplot(2,1,1)
plot(ts,a(1)*y1+a(6)*y6)
hold on
plot(ts,y16)
xlabel('Time [s]')
legend('$a_1 S[u_1] + a_6 S[u_6]$','$S[a_1 u_1 + a_6 u_6]$','interpreter','latex')
title('Plot of $a_1 S[u_1] + a_6 S[u_6]$ and $S[a_1 u_1 + a_6 u_6]$','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(ts,y16-(a(1)*y1+a(6)*y6))
xlabel('Time [s]')
title('Plot of error $e = S[a_1 u_1 + a_6 u_6] - (a_1 S[u_1] + a_6 S[u_6])$','Interpreter', 'latex','FontSize',15)
sgtitle(['Plot for $u_1(t) = 1$ , $u_6(t) = cos(50t)$ , $a_1$ = ' num2str(a(1)) ', $a_6$ = ',num2str(a(6))],'Interpreter', 'latex','FontSize',20)

figure
subplot(2,1,1)
plot(ts,a(2)*y2+a(5)*y5)
hold on
plot(ts,y25)
xlabel('Time [s]')
legend('$a_2 S[u_2] + a_5 S[u_5]$','$S[a_2 u_2 + a_5 u_5]$','interpreter','latex')
title('Plot of $a_2 S[u_2] + a_5 S[u_5]$ and $S[a_2 u_2 + a_5 u_5]$','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(ts,y25-(a(2)*y2+a(5)*y5))
xlabel('Time [s]')
title('Plot of error $e = S[a_2 u_5 + a_5 u_5] - (a_2 S[u_2] + a_5 S[u_5])$','Interpreter', 'latex','FontSize',15)
sgtitle(['Plot for $u_2(t) = t$ , $u_5(t) = sin(2t)$ , $a_2$ = ' num2str(a(2)) ', $a_5$ = ',num2str(a(5))],'Interpreter', 'latex','FontSize',20)

figure
subplot(2,1,1)
plot(ts,a(3)*y3+a(4)*y4)
hold on
plot(ts,y34)
xlabel('Time [s]')
legend('$a_3 S[u_3] + a_4 S[u_4]$','$S[a_3 u_3 + a_4 u_4]$','interpreter','latex')
title('Plot of $a_3 S[u_3] + a_4 S[u_4]$ and $S[a_3 u_3 + a_4 u_4]$','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(ts,y34-(a(3)*y3+a(4)*y4))
xlabel('Time [s]')
title('Plot of error $e = S[a_3 u_3 + a_4 u_4] - (a_3 S[u_3] + a_4 S[u_4])$','Interpreter', 'latex','FontSize',15)
sgtitle(['Plot for $u_3(t) = t^2/4$ , $u_4(t) = \delta(t)$ , $a_3$ = ' num2str(a(3)) ', $a_4$ = ',num2str(a(4))],'Interpreter', 'latex','FontSize',20)

figure
subplot(2,1,1)
plot(ts,a(1)*y1+a(2)*y2+a(3)*y3+a(4)*y4+a(5)*y5+a(6)*y6)
hold on
plot(ts,y123456)
xlabel('Time [s]')
legend('$\sum_{n=1}^{6} a_n S[u_n]$','$S[\sum_{n=1}^{6} a_n u_n]$','interpreter','latex')
title('Plot of $\sum_{n=1}^{6} a_n S[u_n]$ and $S \biggl[\sum_{n=1}^{6} a_n u_n \biggr]$','Interpreter', 'latex','FontSize',15)
subplot(2,1,2)
plot(ts,y34-(a(3)*y3+a(4)*y4))
xlabel('Time [s]')
title('Plot of error $e = \sum_{n=1}^{6} a_n S[u_n] - S \biggl[\sum_{n=1}^{6} a_n u_n \biggr]$','Interpreter', 'latex','FontSize',15)
sgtitle('Plot for all inputs $u_n(t)$ and all coefficients $a_n$','Interpreter', 'latex','FontSize',20)


%% Custom Dirac
function out = diracCust(t)
    if t == 0
        out = 100;
    else
        out = 0;
    end
end