%% ES868 – Pré Relatório Lab 3
% *Controle de plantas eletrˆonicas utilizando um controlador PID digital*
%
% Turma A - 16/03/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza – 117093
% * Vinícius Ragazi David - 120258

load ../G.mat
s = tf('s');

%% Controlador proporcional

%% Controlador de Ziegler Nichols
% O primeiro passo no método de Ziegler Nichols é encontrar $k = k_{osc}$
% que deixa a planta no limiar de estabilidade quando em malha fechada:
%
% Para isso pode ser usado o critério de Routh com a equação característica:
%
% $$1 + k G(s) = 0$$
%
% $$1 + \frac{8.993 k}{0.0003019 s^3 + 0.03622 s^2 + s} = 0$$
%
% $$\frac{0.0003019 s^3 + 0.03622 s^2 + s + 8.993 k}{0.0003019 s^3 + 0.03622 s^2 + s} = 0$$
%
% $$0.0003019 s^3 + 0.03622 s^2 + s + 8.993 k = 0$$
%
% Com o critério de Routh chega-se em: $k = \frac{0.03622}{0.0003019 *
% 8.993} = 13.3408$
% 
% 
k_osc = 13.3408;
GC_mf = feedback(G*k_osc,1);
poles = esort(pole(GC_mf));
w_osc = abs(poles(1));
T_osc = 2*pi/w_osc;
kp = 0.6*k_osc;
Ti = T_osc/2;
Td = T_osc/8;
C = kp*(1 + 1/(Ti*s) + Td*s)

%%
% Usando o sisotool para ajustar o valor de kp e melhorar o desempenho do
% controlador, obtemos $kp_2 = 1.31 kp$
kp_2 = 1.31*kp;
C_2 = 1.31*C

%%
% Cálculo dos valores de desempenho
sistema = feedback(G*C_2, 1);
step(sistema)

%% 
% Desempenho do sistema discreto
Ts = 0.001;
Gz = c2d(G, Ts, 'zoh');
Cz = c2d(C_2, Ts, 'matched');
sistemaZ = feedback(Gz*Cz, 1);
step(sistemaZ), snapnow;

%%
% Simulação do sistema discreto
t = 0:.001:4;
onda_quadrada = square(2*pi*4*t)*0.5+0.5;
onda_rampa = cumsum(onda_quadrada);
lsim(sistemaZ, onda_quadrada, t), snapnow;
lsim(sistemaZ, onda_rampa, t)