clear all
close all
clc 
C = [3 1 2]; 
D = [1 1 1; 2 1 -1]; 
B = [1 -1];
Aeq = [1 -1 1];
beq = [0];
lb = zeros(3,1); 
ub = [1 1 1];
f = C';
A = -D';
b = -B'; 
[x,fval] = linprog(f,A,b,Aeq,beq,lb,ub);
x
fval
