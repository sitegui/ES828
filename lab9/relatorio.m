%% ES868 – Relatório Lab 9
% *Identificação de um motor de corrente contínua*
%
% Turma A - 15/06/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza – 117093
% * Vinícius Ragazi David - 120258

clear all;
dt1 = 1e-3;
dt = 10e-3;

%% Ensaio de motor travado
% Dado coletado
i1 = load('dados_coletados/corrente_parado_disco1.lvm');
i1_f = medfilt1(i1, 17);
n1 = numel(i1);
t1 = linspace(0, (n1-1)*dt1, n1)';
plot(t1, [i1 i1_f]);
title('Corrente observada no teste com motor travado');
xlabel('Tempo (s)');
ylabel('Corrente (A)');
legend('Original', 'Filtrado');

%%
% Corrente de regime permanente
I0 = median(i1(i1 > 1))
V = 12;
R = V/I0

%%
% Constante de tempo elétrica
inicio = find(i1_f > 0.06, 1);
fim = find(i1_f > 0.63*I0, 1);
tau_e = (fim-inicio)*dt1;
L = tau_e*R

%% Ensaio de motor livre
% Dado coletado
i2 = load('dados_coletados/corrente_livre_disco1.lvm');
v2 = load('dados_coletados/velocidade_livre_disco1.lvm');
n2 = numel(i2);
t2 = linspace(0, (n2-1)*dt, n2)';
plotyy(t2, i2, t2, v2);
title('Valores observados no teste com motor livre');
xlabel('Tempo (s)');
legend('Corrente (A)', 'Velocidade (rad/s)');

%%
% Filtrado
i2_f = smooth(medfilt1(smooth(i2, 5), 17), 5);
v2_f = smooth(medfilt1(smooth(v2, 5), 17), 5);
plotyy(t2, i2_f, t2, v2_f);
title('Valores observados no teste com motor livre');
xlabel('Tempo (s)');
legend('Corrente (A)', 'Velocidade (rad/s)');

%%
% Regime permanente
[v2_inf, index_inf] = max(v2_f)
i2_inf = i2_f(index_inf-1)
K = (V - R*i2_inf)/v2_inf
b = K*i2_inf/v2_inf

%%
% Constante de tempo mecânica
index_tau_m = find(v2_f(index_inf:end) < 0.3679*v2_inf, 1);
tau_m = index_tau_m*dt
J = tau_m*b

%% Ensaio com disco 1 (disco 2 travado)
vd1 = load('dados_coletados/velocidade_disco2_travado.lvm');
pd1 = cumsum(vd1)*dt;
pd1 = pd1 - pd1(end);
nd1 = numel(pd1);
td1 = linspace(0, (nd1-1)*dt, nd1)';
picosd1 = [77, 92, 109, 125, 140, 156, 172, 187, 203, 218, 232]';
p_picosd1 = pd1(picosd1+1);
plot(td1, pd1, picosd1*dt, p_picosd1, 'o');
title('Valores observados no teste com disco 1');
xlabel('Tempo (s)');
legend('Posição (rad)');
xlim([0, 3]);

%%
% Cálculo de $\omega_{n_{d1}}$ e $\xi_{d1}$
m = numel(picosd1);
omegad_d1 = (m-1)*pi/sum(diff(picosd1*dt))
tg = (m-1)*pi/sum(diff(log(abs(p_picosd1))));
xi_d1 = sqrt(1/(tg*tg+1))
omegan_n1 = omegad_d1/sqrt(1-xi_d1*xi_d1)

%% Ensaio com disco 2 (disco 1 travado)
vd2 = load('dados_coletados/velocidade_disco1_travado.lvm');
pd2 = cumsum(vd2)*dt;
pd2 = pd2 - pd2(end);
nd2 = numel(pd2);
td2 = linspace(0, (nd2-1)*dt, nd2)';
picosd2 = [63, 79, 95, 111, 127, 142, 160, 174, 191, 208, 223, 239, 255, 272, 287, 303, 319, 336, 351, 367, 383, 399, 416, 433, 448, 463, 478, 495, 510, 527, 542]';
p_picosd2 = pd2(picosd2+1);
plot(td2, pd2, picosd2*dt, p_picosd2, 'o');
title('Valores observados no teste com disco 2');
xlabel('Tempo (s)');
legend('Posição (rad)');
xlim([0, 7]);

%%
% Cálculo de $\omega_{n_{d1}}$ e $\xi_{d1}$
m = numel(picosd2);
omegad_d2 = (m-1)*pi/sum(diff(picosd2*dt))
tg = (m-1)*pi/sum(diff(log(abs(p_picosd2))));
xi_d2 = sqrt(1/(tg*tg+1))
omegan_n2 = omegad_d2/sqrt(1-xi_d2*xi_d2)

%% Modelo de estado
% Juntando as seguintes equações:
%
% $$L \dot{i} + R i = V - K \dot{\theta}$$
%
% $$J \dot{v} + b v = K i$$
%
% $$\dot{\theta} = v$$
%
% Chega-se no modelo de estados
%
% $$\left[ \begin{array}{c} \dot{i} \\ \dot{v} \\ \dot{\theta} \end{array} \right] =
% \left[ \begin{array}{ccc} -R/L & -K/L & 0 \\ K/J & -b/J & 0 \\ 0 & 1 & 0 \end{array} \right]
% \left[ \begin{array}{c} i \\ v \\ \theta \end{array} \right] + 
% \left[ \begin{array}{c} 1/L \\ 0 \\ 0 \end{array} \right]
% \left[ \begin{array}{c} V \end{array} \right]$$
%
% $$\left[ \begin{array}{c} i \\ v \end{array} \right] =
% \left[ \begin{array}{ccc} 1 & 0 & 0 \\ 0 & 1 & 0 \end{array} \right]
% \left[ \begin{array}{c} i \\ v \\ \theta \end{array} \right]$$
A = [-R/L, -K/L, 0; K/J, -b/J, 0; 0, 1, 0];
B = [1/L; 0; 0];
C = [1, 0, 0; 0, 1, 0];
D = [0; 0];
planta = ss(A, B, C, D)

%% Comparação teórico x real
v2_t = V*(i2_f>0.5);
[Y, T] = lsim(planta, v2_t, t2);
plot(T, Y(:,1), t2, i2_f);
title('Corrente (A)');
legend('Teórico', 'Experimental');
xlabel('Tempo (s)');
snapnow;
plot(T, Y(:,2), t2, v2_f);
title('Velocidade (rad/s)');
legend('Teórico', 'Experimental');
xlabel('Tempo (s)');

%% G(s) = v/V
s = tf('s');
G = tf([K/(J*L)], [1, (R/L + b/J), (R*b+K^2)/(J*L)])
