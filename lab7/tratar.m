%% Trataos sinais coletados
clear all
close all
dt = 0.01

%% Ensaio com motor travado
% Dado original
corrente1 = load('dados_coletados/corrente_parado.lvm');
n1 = numel(corrente1);
t1 = linspace(0, n1*dt, n1)';
plot(t1, corrente1);

%%
% Filtrado
corrente1 = medfilt1(corrente1, 3);
plot(t1, corrente1);

%% Ensaio com motor livre
% Dado original
corrente2 = load('dados_coletados/corrente.lvm');
velocidade2 = load('dados_coletados/velocidade.lvm');
n2 = numel(velocidade2);
t2 = linspace(0, n2*dt, n2)';
plot(t2, corrente2);
snapnow;
plot(t2, velocidade2);

%%
% Filtrado
corrente2 = smooth(medfilt1(smooth(corrente2, 9), 9), 9);
plot(t2, corrente2);
snapnow;
velocidade2 = smooth(medfilt1(smooth(velocidade2, 9), 9), 9);
plot(t2, velocidade2);