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
load sinais.mat
s = tf('s');


%% controlador proporcional
A = G.num{1}(4);
den = G.den{1};
raizes = roots(-polyder(den)/A);
k = -polyval(den, -17.7369)/A;

%%
% A resposta à rampa do controlador é exibida abaixo:
dt = 0.001;
t = 0:dt:2;
rampa = t;
sistema = feedback(k*G, 1);
%lsim(sistema, rampa, t);

%%
% Entrada quadrada de amplitude 1 e 0.25Hz
onda_quadrada = square(2*pi*0.25*t)*0.5+0.5;
%plot(t, onda_quadrada);
%ylim([-0.1, 1.1]);
%title('Entrada quadrada');
%xlabel('t (s)');

%%
% Resposta à onda quadrada
tempo1=linspace(0, 2.5, length(saida1));

lsim(sistema, k*(1-sistema), 'b -.', onda_quadrada, t);
hold on
plot (tempo1,saida1, 'r');
plot (tempo1,controle1, 'r -.');
title('Reposta à onda quadrada');
legend('y(t)', 'u(t)', 'y(t) real', 'u(t) real');


%%
% Entrada de rampa
onda_rampa = cumsum(onda_quadrada)*dt;
%figure, plot(t, onda_rampa);
%title('Entrada em rampa');
%xlabel('t (s)');

%%
% Resposta à rampa
figure, lsim(sistema, k*(1-sistema), '-.', onda_rampa, t);
title('Reposta à rampa');
hold on
lsim(tf(1,[1 0]),'r',saida1,tempo1);
lsim(tf(1,[1 0]),'r -.',controle1,tempo1);
legend('y(t)', 'u(t)', 'y(t) real', 'u(t) real');
figure,


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
% controlador, obtemos $kp_2 = 1.31 kp$.
%
% Comparação antes vs depois da alteração manual do lugar dos pólos:
% 
% % % % <<../imgs/ziegler-nichols.png>>
kp_2 = 1.31*kp;
C_2 = 1.31*C

%%
% Cálculo dos valores de desempenho
sistema = feedback(G*C_2, 1);
%%
% % % % % <<../imgs/ziegler-nichols_step.png>>

%% 
% Desempenho do sistema discreto
Ts = 0.001;
Gz = c2d(G, Ts, 'zoh');
Cz = c2d(C_2, Ts, 'matched')
sistemaZ = feedback(Gz*Cz, 1);
%%
% % % % % <<../imgs/ziegler-nichols_z_step.png>>

%%
% Simulação do sistema discreto
lsim(sistemaZ, onda_quadrada, t, 'b');
hold on
lsim(Cz*(1-sistemaZ), onda_quadrada, t, 'b -.');
plot (tempo1, saida2, 'r');
plot (tempo1, controle2, 'r -.');
figure;

lsim(sistemaZ,onda_rampa,t,'b');
hold on
lsim(Cz*(1-sistemaZ),onda_rampa,t,'b -.');
lsim(tf(1,[1 0]),'r',saida2,tempo1);
lsim(tf(1,[1 0]),'-. r',controle2,tempo1);
figure;

%% Controlador utilizando o sisotool

Ck;
Csiso;
Czn;