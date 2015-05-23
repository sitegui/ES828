%% ES868 – Relatório Lab 6
% *Identificação de um motor de corrente contínua*
%
% Turma A - 23/05/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza – 117093
% * Vinícius Ragazi David - 120258

dt = 10e-3;

%% Ensaio de motor travado
% Dado coletado
i1 = load('dados_coletados/corrente_parado.lvm');
n1 = numel(i1);
t1 = linspace(0, (n1-1)*dt, n1)';
plot(t1, i1);
title('Corrente observada no teste com motor travado');
xlabel('Tempo (s)');
ylabel('Corrente (A)');

%%
% Corrente de regime permanente
I0 = median(i1(i1 > 1))
Rs = 1;
V = 12;
R = V/I0-Rs

%%
% Constante de tempo elétrica
tau_e = 5e-3; % sabemos somente que tau_e < 10ms :/
L = tau_e*(R+Rs)

%% Ensaio de motor livre
% Dado coletado
i2 = load('dados_coletados/corrente.lvm');
v2 = load('dados_coletados/velocidade.lvm');
n2 = numel(i2);
t2 = linspace(0, (n2-1)*dt, n2)';
plotyy(t2, i2, t2, v2);
title('Valores observados no teste com motor livre');
xlabel('Tempo (s)');
legend('Corrente (A)', 'Velocidade (rad/s)');

%%
% Filtrado
i2_f = smooth(medfilt1(smooth(i2, 9), 9), 9);
v2_f = smooth(medfilt1(smooth(v2, 9), 9), 9);
plotyy(t2, i2_f, t2, v2_f);
title('Valores observados no teste com motor livre');
xlabel('Tempo (s)');
legend('Corrente (A)', 'Velocidade (rad/s)');

%%
% Regime permanente
[v2_inf, index_inf] = max(v2_f)
i2_inf = i2_f(index_inf)
K = (V - (R+Rs)*i2_inf)/v2_inf
b = K*i2_inf/v2_inf

%%
% Constante de tempo mecânica
index_tau_m = find(v2_f(index_inf:end) < 0.3679*v2_inf, 1);
tau_m = index_tau_m*dt
J = tau_m*b