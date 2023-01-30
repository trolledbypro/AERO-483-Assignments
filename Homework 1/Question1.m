% Zachary Zalass
% 40098539
% Assignment 1
% Question 1

clear;
format long g;

% Setup constants
interest = 0.02;
principal = 0.8 * 375000;
years = 1:1:30;
payments = 12 * years;

% Plot equations for dependant variables
u_t = (interest/12 * principal * (1 + interest/12).^payments)./((1+interest/12).^payments - 1);
interest_by_month = principal * (1 + interest/12).^(payments);

% Plots
figure;
plot(years, interest_by_month);
title('Question 1, Part 4: Interest of a mortgage as a function of mortgage term (in years)');
xlabel('Years');
ylabel('Interest ($)');

figure;
plot(years, u_t);
title('Question 1, Part 5: Monthly payment of a mortgage as a function of mortgage term (in years)');
xlabel('Years');
ylabel('Monthly payment ($)');