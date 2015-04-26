%% ES868 – Pré Relatório Lab 6
% *Controle por realimentação de saída de uma planta eletrônica*
%
% Turma A - 26/04/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza – 117093
% * Vinícius Ragazi David - 120258

clear all
load ../G.mat

%% Localização dos polos
% Deseja-se que o tempo de estabilização seja de 0.5s e o coeficiente de
% amortecimento seja $\sqrt{2}/2$
%
% Dessa forma, $\xi = \sqrt{2}/2$
t_e = 0.5;
xi = sqrt(2)/2

%%
% Como $t_e = 4 / (\xi \cdot \omega_n)$, obtém-se
omega_n = 4/t_e/xi

%%
% Dessa forma, os dois pólos dominantes serão
p1 = omega_n*(-xi+i*sqrt(1-xi*xi))
p2 = omega_n*(-xi-i*sqrt(1-xi*xi))

%%
% O terceiro polo foi escolhido arbitrariamente como sendo em -30
p3 = -30;
p = [p1; p2; p3];

%% Modelo de estados
Gss = ss(G)

%% Determinação da matriz K
K = place(Gss.a, Gss.b, p)

%% Pólos do observador
% Os pólos do observador devem ser escolhidos de forma que o estado
% estimado siga o estado verdadeiro o mais rápido possível. Para isso, eles
% devem estar mais à esqueda que os pólos do controlador.
%
% Dessa forma, foi escolhido arbitrariamente que a parte real deveria ser
% 50% mais negativa
po = p+real(p)*0.5

%% Determinação da matriz L
L = place(Gss.a', Gss.c', po)'