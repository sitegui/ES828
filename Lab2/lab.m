close all;
clear all;
clc;
format short;

s=tf('s');

z1=100000;
z2=10000;
z3=100000;
z4=220000;
z5=100000;
z6=470000;
z7=1000000;
c1=0.1*10^(-6);
c2=0.1*10^(-6);
c3=0.1*10^(-6);

%Para pegar o valor de y/r
r=1;

v1=-r*z2/z1;
v2=-v1*z4/(z3*z4*c1*s+z3);
v3=-v2*z6/(z5*z6*c2*s+z5);
y=-v3/(z7*c3*s)

margin (y)

t = 0:.0001:4;
r = square(2*pi*t);
plot(t,r)

