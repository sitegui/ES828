%% ES868 – Pré Relatório Lab 5
% *Controle de plantas eletrˆonicas utilizando um controlador atraso-avanço digital*
%
% Turma A - 06/04/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza – 117093
% * Vinícius Ragazi David - 120258

load ../G.mat
load ../pids.mat
s = tf('s');

%% Determinação do K
% Fazendo $C(s) = K$ e buscando por um erro em regime permanente a uma
% entrada rampa de 2%:
%
% $$\frac{e(s)}{u(s)} = \frac{1}{1+C(s) G(s)}$$
% 
% $$\lim_{s \to 0}{s \cdot \frac{e(s)}{u(s)} \cdot \frac{1}{s^2}} = 0.02$$
% 
% With $gk = \lim_{s \to 0}{s G(s)}$:
%
% $$K = \frac{50}{gk}$$
kg = evalfr(minreal(s*G), 0)
K = 50/kg