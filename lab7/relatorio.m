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
t1 = linspace(0, (n1+1)*dt, n1)';
plot(t1, i1);
title('Corrente observada no teste com motor travado');
xlabel('Tempo (s)');
ylabel('Corrente (A)');

%%
% Corrente de regime permanente
I0 = median(i1(i1 > 1))
Rs = 1;
V = 5;
R = V/I0-Rs

%%
% Constante de tempo elétrica
tau_e = 5e-3; % sabemos somente que tau_e < 10ms :/
L = tau_e*(R+Rs)
