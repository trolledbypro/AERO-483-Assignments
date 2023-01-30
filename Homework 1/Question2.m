% Zachary Zalass
% 40098539
% Assignment 1
% Question 2

clear;
clc;
 
data = readtable('opendata_covid19_tests_total.csv'); % Comes from https://opendata.digilugu.ee/docs/#/en/opendata/covid19/test/opendata_covid19_tests_total
table = [data(1027:1061,2) data(1027:1061,3) data(1027:1061,4) data(1027:1061,5)];
%% Part 1
days = 1:1:35;
dates = table2array(table(:,"StatisticsDate"));
total_cases = table2array(table(:,"TotalCases"));

% Create the least-squares linear fit
H = [days' days.^0'];
coeff = inv(H'*H)*H'*log(total_cases);

% Least-squares linear fit expression
least_squares_linear = coeff(1,1) .* days + coeff(2,1);
disp("Linear fit coefficients in form y = ax + b: ");
fprintf("a: %d\tb: %d\n", coeff(1,1), coeff(2,1));

% Plot
hold on;
plot(dates, log(total_cases));
plot(dates,least_squares_linear);
xlabel('Dates');
ylabel('Log of Accumulative Cases');
title('Overplot of least-squares linear fit and accumulative cases');
legend('Log of Acumulative Cases', 'Least-Squares Linear fit');

%% Part 2
tested_population = 1048576; % Comes from https://opendata.digilugu.ee/docs/#/en/opendata/covid19/test/opendata_covid19_test_results
infected = table2array(table(:,"TotalCasesLast14D"));

% Create recovered population (total cases 14 days ago)
%table.Recovered = data(1027 - 14:1061 - 14,4);
%recovered = table2array(table(:,"Recovered"));
recovered = table2array(data(1027 - 14:1061 - 14,4));

% Create succeptible population
succeptible = tested_population - infected - recovered;

% Create A matrix
x_t = [infected(1:34)'; succeptible(1:34)'];%; recovered(1:34)'];
x_t_plus_1 = [infected(2:35)'; succeptible(2:35)'];%; recovered(2:35)'];
A = [1/tested_population * x_t_plus_1 * x_t']*inv([1/tested_population * x_t * x_t'])
disp("A matrix coefficients:");
fprintf("Beta: %d\tGamma: %d\n", A(1,1), A(1,2));

%% Part 3