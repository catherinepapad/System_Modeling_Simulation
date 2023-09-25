function sys_out = gradient_method(t,var)
% implementetion of gradient descent method

global n m time_step gamma filter y u_fun

time_index = floor(t/time_step+1);
y_now = y(time_index);
u_now = u_fun(t);

phi_1 = zeros(n,1);
phi_2 = zeros(m+1,1);
phi_dot_1 = zeros(n,n);
phi_dot_2 = zeros(n,m+1);

C1 = zeros(n,n);
D1 = zeros(1,n);
C2 = zeros(n,m+1); 
D2 = zeros(1,m+1);

num = zeros(1,n);
denom = [1,filter];

for i=1:1:n
    num(i) = 1;
    [A,B,C1(:,i),D1(i)] = tf2ss(num,denom);
    phi_dot_1(:,i) = A*var((i-1)*n+1:(i-1)*n+n) + B*y_now;
    num(i) = 0; 
end

num = zeros(1,m+1); 

for i=1:1:m+1
    num(i) = 1;
    [A,B,C2(:,i),D2(i)] = tf2ss(num,denom);
    phi_dot_2(:,i) = A*var(n*n+(i-1)*n+1:n*n+(i-1)*n+n) + B*u_now;
    num(i) = 0; 
end

phi_dot = reshape([phi_dot_1,phi_dot_2],[],1); 

for i=1:1:n
    phi_1(i) = C1(:,i).'*var((i-1)*n+1:(i-1)*n+n) + D1(i)*y_now;
end    

for i=1:1:m+1
    phi_2(i) = C2(:,i).'*var(n*n+(i-1)*n+1:n*n+(i-1)*n+n) + D2(i)*u_now;
end 

phi = [phi_1 ; phi_2]; 

theta_est = var(end-n-m:end);

error = y_now - theta_est'*phi;

theta_est_dot = gamma*error*phi;

sys_out=[phi_dot;theta_est_dot];
    
end