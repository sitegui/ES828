%% ES868 – Pré Relatório Lab 8
% *Controle de velocidade de um motor de corrente contínua*
%
% Turma A - 25/05/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza – 117093
% * Vinícius Ragazi David - 120258

clear all
load ../lab7/planta.mat
num = G.num{1};
den = G.den{1};
x = sym('x');
Gx = poly2sym(num, x)/poly2sym(den, x);

%% Controlador proporcional
%
poles = pole(G)
encontro = (poles(1)+poles(2))/2
K = -1/eval(subs(Gx, x, encontro))
Ck = K;
sistema = feedback(Ck*G, 1);
controle = Ck*(1-sistema);
step(50*sistema), figure;
stepinfo(50*sistema)
step(50*controle);