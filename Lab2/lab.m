close all;
clear all;
clc;
format short;

s=tf('s');

%os valores dos resistores e capacitores
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

%v1 e a saida da 1a etapa, v2 da 2a, v3 da 3a e y da ultima.
%as equacoes foram obtidas pelo circuito ja transformado para a frequencia
%por laplace
v1=-z2/z1*(s/s); %s/s foi migue pra funcionar a resposta ao quadrado
v1=minreal(v1)
v2=-v1*z4/(z3*z4*c1*s+z3)
v3=-v2*z6/(z5*z6*c2*s+z5)
y=-v3/(z7*c3*s)

%margem de fase e ganho
margin (y)

%para fazer a resposta a entrada quadrada
t = 0:.0001:5;
r = square(2*pi*t)*0.5+0.5;
%figure, plot(t,r);

%malha aberta
figure, lsim(v1,r,t)
figure, lsim(v2,r,t)
figure, lsim(v3,r,t)
figure, lsim(y,r,t)
