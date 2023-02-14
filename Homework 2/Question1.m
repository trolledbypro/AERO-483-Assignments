% Zachary Zalass
% 40098539
% Assignment 2
% Question 1

clear;
clc;
format long g;

%% Part 1


% Define constants
lambda = [5;7;6];
r = [0;4;0];

position = [r(1,1);r(2,1)];

sat_a = [0;0];
sat_b = [5; sqrt(11) + 4];
sat_c = [-5;sqrt(11) + 4];

sat_a_pos = sat_a - position;
sat_b_pos = sat_b - position;
sat_c_pos = sat_c - position;

d_hats = [norm(sat_a_pos); norm(sat_b_pos); norm(sat_c_pos)];
delta_lambda = lambda - d_hats;

uv_a = sat_a_pos/d_hats(1,1);
uv_b = sat_b_pos/d_hats(2,1);
uv_c = sat_c_pos/d_hats(3,1);

H = [-uv_a' 1; -uv_b' 1; -uv_c' 1];

delta_r = inv(H'*H)*H'*delta_lambda;
r_new = r + delta_r;

%% Part 2

L = 2 * eye(3);
S = 10 * eye(3);

delta_r = inv(H'*L*H + S)*H'*L*delta_lambda;
r_new = r + delta_r;
