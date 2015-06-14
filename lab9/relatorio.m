%% ES868 � Relat�rio Lab 9
% *Identifica��o de um motor de corrente cont�nua*
%
% Turma A - 15/06/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza � 117093
% * Vin�cius Ragazi David - 120258

clear all;
dt1 = 1e-3;
dt2 = 10e-3;

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
% Constante de tempo el�trica
inicio = find(i1_f > 0.06, 1);
fim = find(i1_f > 0.63*I0, 1);
tau_e = (fim-inicio)*dt1;
L = tau_e*R

%% Ensaio de motor livre
% Dado coletado
i2 = load('dados_coletados/corrente_livre_disco1.lvm');
v2 = load('dados_coletados/velocidade_livre_disco1.lvm');
n2 = numel(i2);
t2 = linspace(0, (n2-1)*dt2, n2)';
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
% Constante de tempo mec�nica
index_tau_m = find(v2_f(index_inf:end) < 0.3679*v2_inf, 1);
tau_m = index_tau_m*dt2
J = tau_m*b

%% Modelo de estado
% Juntando as seguintes equa��es:
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

%% Compara��o te�rico x real
v2_t = V*(i2_f>0.5);
[Y, T] = lsim(planta, v2_t, t2);
plot(T, Y(:,1), t2, i2_f);
title('Corrente (A)');
legend('Te�rico', 'Experimental');
xlabel('Tempo (s)');
snapnow;
plot(T, Y(:,2), t2, v2_f);
title('Velocidade (rad/s)');
legend('Te�rico', 'Experimental');
xlabel('Tempo (s)');

%% G(s) = v/V
s = tf('s');
G = tf([K/(J*L)], [1, (R/L + b/J), (R*b+K^2)/(J*L)])
