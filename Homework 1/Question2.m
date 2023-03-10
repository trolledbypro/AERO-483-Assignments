% Zachary Zalass
% 40098539
% Assignment 1
% Question 2

clear;
clc;
format long g;

% Read the data
data = readtable('opendata_covid19_tests_total.csv'); % Comes from https://opendata.digilugu.ee/docs/#/en/opendata/covid19/test/opendata_covid19_tests_total
table = [data(1027:1061,2) data(1027:1061,3) data(1027:1061,4) data(1027:1061,5)];
%% Part 1
days = 1:1:35;
dates = table2array(table(:,"StatisticsDate"));
total_cases = table2array(table(:,"TotalCases"));

% Create the least-squares linear fit
H = [days.^2' days.^1' days.^0'];
coeff = inv(H'*H)*H'*log(total_cases);

% Least-squares linear fit expression
least_squares_linear = coeff(1,1) .* days.^2 + coeff(2,1) .* days + coeff(3,1);
disp("Linear fit coefficients in form y = ax^2 + bx +c: ");
fprintf("a: %d\tb: %d\tc: %d\n", coeff(1,1), coeff(2,1), coeff(3,1));

% Plot
figure;
hold on;
plot(dates, log(total_cases));
plot(dates,least_squares_linear);
xlabel('Dates');
ylabel('Log of Accumulative Cases');
title('Overplot of least-squares linear fit and accumulative cases');
legend('Log of Acumulative Cases', 'Least-Squares Linear fit');
hold off;

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
x_t = [succeptible(1:34)'; infected(1:34)'];
x_t_plus_1 = [succeptible(2:35)'; infected(2:35)'];
A = [1/tested_population * x_t_plus_1 * x_t']*inv([1/tested_population * x_t * x_t'])
disp("A matrix coefficients:");
fprintf("Beta: %d\tGamma: %d\n", -1*A(1,2), -1*A(1,2) - A(2,2) + 1);

%% Part 3

prediction_span = 36:1:50;
t1 = datetime(2023,01,22);
t2 = datetime(2023,02,5);
prediction_span_dates = t1:t2;

% Create prediction from model in Part 1
least_squares_prediction = coeff(1,1) .* prediction_span.^2 + coeff(2,1) .* prediction_span + coeff(3,1);

% Create prediction from model in Part 2
S_I_prediction = zeros(2,15);
S_I_prediction(:,1) = x_t_plus_1(:,34);
for c=1:14
    S_I_prediction(1,c + 1) = A(1,1)*S_I_prediction(1,c) + A(1,2)*S_I_prediction(2,c);
    S_I_prediction(2,c + 1) = A(2,1)*S_I_prediction(1,c) + A(2,2)*S_I_prediction(2,c);
end

% Plot the prediction
figure;
hold on;
plot(prediction_span_dates,least_squares_prediction);
plot(prediction_span_dates,log(S_I_prediction(2,:)));
xlabel('Dates');
ylabel('Log of Accumulative Cases Prediction');
legend('Least-squares prediction', 'S-I model prediction');
title('Overplot of least-squares linear fit and accumulative cases');
