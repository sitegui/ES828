%% ES868 � Pr� Relat�rio Lab 6
% *Controle por realimenta��o de sa�da de uma planta eletr�nica*
%
% Turma A - 26/04/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza � 117093
% * Vin�cius Ragazi David - 120258

load ../G.mat
clear all

%% Localiza��o dos polos
% Deseja-se que o tempo de estabiliza��o seja de 0.5s e o coeficiente de
% amortecimento seja $\sqrt{2}/2$
%
% Dessa forma, $\xi = \sqrt{2}/2$
t_e = 0.5;
xi = sqrt(2)/2

%%
% Como $t_e = 4 / (\xi \cdot \omega_n)$, obt�m-se
omega_n = 4/t_e/xi

%%
% Dessa forma, os dois p�los dominantes ser�o
p1 = omega_n*(-xi+i*sqrt(1-xi*xi))
p2 = omega_n*(-xi-i*sqrt(1-xi*xi))

%%
% O terceiro polo foi escolhido arbitrariamente como sendo em -30
p3 = -30;
p = [p1, p2, p3];
