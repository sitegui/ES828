%% ES868 – Relatório Lab 3
% *Controle de plantas eletrônicas utilizando um controlador PID digital*
%
% Turma A - 16/03/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza – 117093
% * Vinícius Ragazi David - 120258
close all;

load ../G.mat
load ../pids.mat
load sinais_tratados.mat
s = tf('s');

%% controlador proporcional
A = G.num{1}(4);
den = G.den{1};
raizes = roots(-polyder(den)/A);
k = -polyval(den, -17.7369)/A;

%%
% A resposta à rampa do controlador é exibida abaixo:
sistema = feedback(k*G, 1);

%%
% Entrada quadrada de amplitude 1 e 0.25Hz
onda_quadrada = square(2*pi*0.25*t)*0.5+0.5;

%%
% Resposta à onda quadrada
y = lsim(sistema, onda_quadrada, t);
u = lsim(k*(1-sistema), onda_quadrada, t);
plot(t, y, t, u, 'b-.', t, saida1, 'r', t, controle1, 'r-.');
axis([0, 1, 0, 1]);
title('Reposta à onda quadrada');
xlabel('Tempo (s)');
legend('y(t)', 'u(t)', 'y(t) real', 'u(t) real');

%%
% Entrada de rampa
onda_rampa = cumsum(onda_quadrada)*(t(2)-t(1));

%%
% Resposta à rampa
y = lsim(sistema, onda_rampa, t);
u = lsim(k*(1-sistema), onda_rampa, t);
y2 = lsim(tf(1, [1, 0]), saida1, t);
u2 = lsim(tf(1, [1, 0]), controle1, t);
plot(t, y, t, u, 'b-.', t, y2, 'r', t, u2, 'r-.');
axis([0, 1, 0, 1]);
title('Reposta à rampa');
xlabel('Tempo (s)');
legend('y(t)', 'u(t)', 'y(t) real', 'u(t) real');

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
% controlador, obtemos $kp_2 = 1.31 kp$.
%
% Comparação antes vs depois da alteração manual do lugar dos pólos:
%
kp_2 = 1.31*kp;
C_2 = 1.31*C/(0.0001*s+1)

%%
% Resposta ao degrau do PID de Ziegler Nichols
sistema = feedback(G*C_2, 1);
y = lsim(sistema, onda_quadrada, t);
plot(t, y, t, saida2, 'r');
axis([0, 1, 0, 2]);
title('Reposta à onda quadrada');
xlabel('Tempo (s)');
legend('y(t)', 'y(t) real');
snapnow;
u = lsim(C_2*(1-sistema), onda_quadrada, t);
plot(t, u, 'b-.', t, controle2, 'r-.');
axis([0, 1, -10, 10]);
title('Reposta à onda quadrada');
xlabel('Tempo (s)');
legend('u(t)', 'u(t) real');

%%
% Resposta à rampa do PID de Ziegler Nichols
y = lsim(sistema, onda_rampa, t);
y2 = lsim(tf(1, [1, 0]), saida2, t);
plot(t, y, t, y2, 'r');
axis([0, 1, 0, 1]);
title('Reposta à rampa');
xlabel('Tempo (s)');
legend('y(t)', 'y(t) real');
snapnow;
u = lsim(C_2*(1-sistema), onda_rampa, t);
u2 = lsim(tf(1, [1, 0]), controle2, t);
plot(t, u, 'b-.', t, u2, 'r-.');
axis([0, 1, 0, 0.5]);
title('Reposta à rampa');
xlabel('Tempo (s)');
legend('u(t)', 'u(t) real');

%% Controlador utilizando o sisotool
% Resposta ao degrau
Csiso_ = Csiso/(0.0001*s+1)
sistema = feedback(G*Csiso_, 1);
y = lsim(sistema, onda_quadrada, t);
plot(t, y, t, saida3, 'r');
axis([0, 1, 0, 2]);
title('Reposta à onda quadrada');
xlabel('Tempo (s)');
legend('y(t)', 'y(t) real');
snapnow;
u = lsim(Csiso_*(1-sistema), onda_quadrada, t);
plot(t, u, 'b-.', t, controle3, 'r-.');
axis([0, 1, -10, 10]);
title('Reposta à onda quadrada');
xlabel('Tempo (s)');
legend('u(t)', 'u(t) real');

%%
% Resposta à rampa
y = lsim(sistema, onda_rampa, t);
y2 = lsim(tf(1, [1, 0]), saida3, t);
plot(t, y, t, y2, 'r');
axis([0, 1, 0, 1]);
title('Reposta à rampa');
xlabel('Tempo (s)');
legend('y(t)', 'y(t) real');
snapnow;

u = lsim(Csiso_*(1-sistema), onda_rampa, t);
u2 = lsim(tf(1, [1, 0]), controle3, t);
plot(t, u, 'b-.', t, u2, 'r-.');
axis([0, 1, 0, 0.5]);
title('Reposta à rampa');
xlabel('Tempo (s)');
legend('u(t)', 'u(t) real');