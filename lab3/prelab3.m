close all; clear all; clc;

s=tf('s');
syms x;

G=8.993/(0.0003019*s^3+0.03622*s^2+s)
G2=8.993/(0.0003019*x^3+0.03622*x^2+x);

%% controlador 1
b=diff(1/G2);
sr=solve(b,x);
sr1=sr(1);

K=-1/subs(G2,x,sr1);
K=0.8926

%%resposta a rampa controlador 1
t=0:0.001:4;
rampa=t;
Y=minreal(G*K/(1+G*K))
step(Y/s)
hold on
figure, plot(rampa,t); title('Resposta � rampa do controlador proporcional');

%%entrada quadrada
%% Entrada
% Uma onda quadrada de 0,25 Hz e amplitude 1 (volt)
t = 0:.001:4;
sqr = square(2*pi*4*t)*0.5+0.5;
figure, plot(t,sqr);
axis([0 3 -0.1 1.1]);
xlabel('t (s)');
ylabel('r (V)');

%% saidas a onda quadrada

figure,lsim(Y, sqr,t), title('Reposta Y � onda quadrada'), snapnow;
figure,lsim(K*Y-K, sqr,t), title('Reposta do controlador � onda quadrada'), snapnow;

%%saida a onda quadrada * rampa

figure,lsim(Y, sqr.*rampa,t), title('Reposta Y � rampa quadrada'), snapnow;
figure,lsim(K*Y-K, sqr.*rampa,t), title('Reposta do controlador � rampa quadrada'), snapnow;







