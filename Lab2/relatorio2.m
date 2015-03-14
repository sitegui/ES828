close all; clear all; clc;

load matlab.mat

t1 = a1(:, 1) * 10e-3;
t2 = a2(:, 1) * 10e-3;
t3 = a3(:, 1) * 10e-3;
t4 = a4(:, 1) * 10e-3;

t1 = t1 - t1(1);
t2 = t2 - t2(1);
t3 = t3 - t3(1);
t4 = t4 - t4(1);

t11 = a11(:, 1) * 10e-3;
t22 = a22(:, 1) * 10e-3;
t33 = a33(:, 1) * 10e-3;
t44 = a44(:, 1) * 10e-3;

est1 = a1( :,2);
est2 = a2( :,2);
est3 = a3( :,2);
est4 = a4( :,2);

figure, scatter(t1,est1);
figure, plot(t2,est2);
figure, plot(t3,est3);
figure, plot(t4,est4);

% Maneira de achar meio do degrau "corretamente"
% Pego a parte debaixo do degrau
indEst1 = find(est1<-0.04);
est1l_min = est1(indEst1);
trandom = 1:length(est1l_min);
figure, scatter(trandom,est1l_min)
hold on
% fit simples do vetor.
[f,weight]=polyfit(trandom',est1l_min,0)
[f1,delta] = polyval (f,trandom,weight);
plot(trandom,f1,'r')
% Para a planta 1, a saída degrau é de -0.1011+-0.0198
% não curto médias . . . . 