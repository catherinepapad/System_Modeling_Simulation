function [phi] = least_squares_method(n,m,y,u,t,filter)
%implementetion of least squares method    

phi = zeros(size(t,2),n+m+1);
column = 0;

for i=n:-1:1
    column = column+1;
    num = zeros(1,i);
    num(1,1) = -1;
    denom = filter;
    filter_tf = tf(num,denom);
    [phi_column,~] = lsim(filter_tf,y,t);
    phi(:,column) = phi_column;
end

for i=m:-1:0
    column = column+1;
    num = zeros(1,i+1);
    num(1,1) = 1;
    denom = filter;
    filter_tf = tf(num,denom);
    [phi_column,~] = lsim(filter_tf,u,t);
    phi(:,column) = phi_column;
end

end