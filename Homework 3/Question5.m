%% Common data
clear;
clc;

theta = acos(1/9);
r_o = [-9;0;0];
rho = [1534;1120;1354;1210];
sat_1 = [1000*cos(theta); 1000*sin(theta)];
sat_2 = [-1000*cos(theta); -1000*sin(theta)];
sat_3 = [1000*cos(theta); -1000*sin(theta)];
sat_4 = [-1000*cos(theta); 1000*sin(theta)];

%% Iteration: Least Squares, 4 satelites
r = [r_o(1,1); r_o(2,1)];

d_hat = [norm(sat_1 - r); norm(sat_2 - r); norm(sat_3 - r);norm(sat_4 - r)];
d_rho = rho - d_hat;

e_1 = (sat_1 - r)/d_hat(1,1);
e_2 = (sat_2 - r)/d_hat(2,1);
e_3 = (sat_3 - r)/d_hat(3,1);
e_4 = (sat_4 - r)/d_hat(4,1);

H = [-1 * e_1' 1; -1 * e_2' 1; -1 * e_3' 1; -1 * e_4' 1];

delta_r = inv(H'*H)*H'*d_rho;

r = delta_r + r_o;

%% Iteration: Affine Minimum Variance, 4 satelites
r = [r_o(1,1); r_o(2,1)];
delta_r_bar = [0; 4; 0];
P_inv = inv(1000*eye(3));
R_inv = inv(100*eye(4));

d_hat = [norm(sat_1 - r); norm(sat_2 - r); norm(sat_3 - r);norm(sat_4 - r)];
d_rho = rho - d_hat;

e_1 = (sat_1 - r)/d_hat(1,1);
e_2 = (sat_2 - r)/d_hat(2,1);
e_3 = (sat_3 - r)/d_hat(3,1);
e_4 = (sat_4 - r)/d_hat(4,1);

H = [-1 * e_1' 1; -1 * e_2' 1; -1 * e_3' 1; -1 * e_4' 1];

delta_r = inv(H'*R_inv*H + P_inv)*H'*R_inv*(d_rho - H*delta_r_bar) + delta_r_bar;

r = delta_r + r_o;
%% Iteration: Least Squares, 3 satelites
r = [r_o(1,1); r_o(2,1)];

y_3 = [d_rho(1,1);d_rho(2,1);d_rho(3,1)];

H_3 = [H(1,:);H(2,:);H(3,:)];
P_3 = inv(H_3'*H_3);

x_3 = P_3*H_3'*y_3;

%% Recursive Least Squares Update
y_4 = d_rho(4,1);

delta_r = x_3 + P_3*H(4,:)'/(1+H(4,:)*P_3*H(4,:)')*(y_4-H(4,:)*x_3)

r = delta_r + r_o
