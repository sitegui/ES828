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
% Para se obter o tempo mínimo de estabilização, os pólos de malha fechadas
% tem de estar à mais esquerda possível. Observando o root locus da planta:
rlocus(G)

%%
% Pode-se observar que isso irá ocorrer quando os dois pólos (verde e azul
% na figura) se encontrarem, no ponto próximo de -20. Para obter a
% coordenada exata desse ponto, pode-se verificar a multiplicidade das
% raízes da equação caraterística $1 + k G(s) = 0$.
%
% No nosso caso, com $G(s) = \frac{P(s)}{Q(s)} = \frac{A}{B s^3 + C s^2 + D
% s + E}$ , $k(s) = -\frac{B s^3 + C s^2 + D s + E}{A}$.
%
% Como o ponto buscando é raiz dupla de $k(s)$, ele é raiz da derivada de
% $k(s)$ em $s$, ou seja, raiz de $-\frac{3 B s^2 + 2 C s + D}{A}$.

%% 
% Substituindo os valores dos coeficientes e resolvendo, chegamos em
A = G.num{1}(4);
den = G.den{1};
raizes = roots(-polyder(den)/A)

%%
% Observando o gráfico do root locus mostrado anteriormente, sabemos então
% que o valor buscado é $s = -17.7369$ e
k = -polyval(den, -17.7369)/A

%%
% A resposta à rampa do controlador é exibida abaixo:
dt = 0.001;
t = 0:dt:5;
rampa = t;
sistema = feedback(k*G, 1);
lsim(sistema, rampa, t);
title('Resposta à rampa do controlador proporcional');

%%
% Entrada quadrada de amplitude 1 e 0.25Hz
onda_quadrada = square(2*pi*0.25*t)*0.5+0.5;
plot(t, onda_quadrada);
ylim([-0.1, 1.1]);
title('Entrada quadrada');
xlabel('t (s)');

%%
% Resposta à onda quadrada
lsim(sistema, k*(1-sistema), 'g:', onda_quadrada, t);
title('Reposta à onda quadrada');
legend('y(t)', 'u(t)');

%%
% Entrada de rampa
onda_rampa = cumsum(onda_quadrada)*dt;
plot(t, onda_rampa);
title('Entrada em rampa');
xlabel('t (s)');

%%
% Resposta à rampa
lsim(sistema, k*(1-sistema), '-.', onda_rampa, t);
title('Reposta à rampa');
legend('y(t)', 'u(t)');

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
lsim(sistemaZ, onda_quadrada, t), snapnow;
lsim(sistemaZ, onda_rampa, t)