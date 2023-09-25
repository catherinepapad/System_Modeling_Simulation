%% Setup
clear
clc
close all

t = 0:.01:30;           %time
N = size(t,2);

result_matrix = zeros(15,4);
format shortG

%% Input & Test signals -- Choose one of them
u_fun =@(time) 2*sin(time) + 3*cos(2*time) + sin(3*time) + 0.5*cos(4*time) + sin(5*time);    %input signal
%u_fun =@(time) 2*sin(2*time) + 6*cos(3*time) + 0.6*sin(5*time) + 0.5*cos(4*time) + sin(7*time) + 1.5*cos(10*time);   %test signal 1
%u_fun =@(time) cos(2*time) + sin(4*time) + cos(6*time) + sin(8*time) + cos(10*time) + sin(12*time) + cos(14*time);  %test signal 2

%% Calculate u values 
u = u_fun(t);

%% Calculate y values from sys.p
[y, ~] = sys(t, u_fun);

%figure
%plot(t,y); 

%% Call Least Squares Method for n=1,...,5 and m=0,...,4
i = 1;
for n = 1:1:5
    for m = 0:1:4
        if (n>m)
            filter = filter_coef(n);
            phi = least_squares_method(n,m,y,u,t,[1,filter]);
            
            phi_new = phi' * phi;              %phi * phi_transpose 
            %phi_new_inv = inv(phi_new);        %inverse matrix of phi * phi_transpose 

            z = y'*phi;                        %z matrix = y_transpose * phi

            theta_est = z/phi_new;
            
            y_est = zeros(N,1);
            for k=1:1:N
               y_est(k) = theta_est*phi(k,:)';
            end

%             figure
%             plot(t,y);
%             hold on
%             plot(t,y_est);
%             xlabel('Time [s]')
%             legend('$y$','$\hat{y}$','interpreter','latex')
%             title({'Plot of actual and estimayed system output';['n = ',num2str(n),' , m = ',num2str(m)]},'Interpreter', 'latex','FontSize',20)

            error = y - y_est;
            
            figure
            plot(t,error);
            xlabel('Time [s]')
            title({'Plot of error $e = y - \hat{y}$';['n = ',num2str(n),' , m = ',num2str(m)]},'Interpreter', 'latex','FontSize',20)
            
            BIC = bayesian_criterion(y,y_est,N,n+m+1);
            
%             text = ['n=' , num2str(n) , ' , m=' , num2str(m) , ' , BIC=' , num2str(BIC) , ' , theta_est='];
%             disp(text)
%             disp(theta_est)
            
            result_matrix(i,1) = n;
            result_matrix(i,2) = m;
            result_matrix(i,3) = BIC;
            result_matrix(i,4:4+n+m) = theta_est;
            i = i+1;
        end
    end
end

%% Display results
text = sprintf('\t\t   n \t\t    m \t\t  BIC \t\t theta_est');
disp(text)
disp(result_matrix)

