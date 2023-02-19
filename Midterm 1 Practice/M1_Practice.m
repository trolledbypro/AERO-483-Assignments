clear;
clc;
format long g;

%% Model identification

% Import from file
data = readtable("opendata_covid19_tests_total.csv");

population = 1048576;
M = 20;

infected = data.TotalCasesLast14D(1043:1063,:);
succeptible = population - data.TotalCases(1043:1063,:);

x_k = [succeptible(1:20,:)';infected(1:20,:)'];
x_k_p_1 = [succeptible(2:21,:)';infected(2:21,:)'];

A = [1/M * x_k_p_1 * x_k']*inv([1/M * x_k * x_k']);

% import from a sheet
infected = [1088 1075 1028 993 952];
total = [612573 612660 612715 612769 612797];

succeptible = population - total;

x_k = [succeptible(:,1:4); infected(:,1:4)];
x_k_p_1 = [succeptible(:,2:5); infected(:,2:5)];

A = [1/M * x_k_p_1 * x_k'] * inv([1/M * x_k * x_k']);

%% Line fitting

x = 1:5;
y = succeptible;

H = [x.^2' x.^1' x.^0'];

a = inv(H'*H)*H'*y'

fprintf("linear fit of the form y = a1*x^2 + a2*x + a3 where a = [a1; a2; a3]\n");