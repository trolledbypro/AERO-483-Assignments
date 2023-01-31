% Zachary Zalass
% 40098539
% Assignment 1
% Question 4

% Part 4

clear;
clc;
syms b c;

A_c = [0 1 0;
       0 0 -1*b;
       0 c 0];
B_c = [0;
       1;
       0];

ev = eig(A_c);