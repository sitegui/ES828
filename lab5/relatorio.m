%% ES868 � Relat�rio Lab 5
% *Controle de plantas eletr�onicas utilizando um controlador atraso-avan�o digital*
%
% Turma A - 13/04/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza � 117093
% * Vin�cius Ragazi David - 120258

load ../G.mat
load ../pids.mat
load sinais_tratados.mat
s = tf('s');

%% Resposta ao degrau
sistema = feedback(Caa*G, 1);
Y = lsim(sistema, referencia, t);
plot(t, [Y saida])
axis([0, 1, 0, 1.2]);
legend('Te�rico', 'Pr�tico');
xlabel('Tempo (s)');

%% Desempenho
stepinfo(sistema)
stepinfo(saida, t, 1)

%% Esfor�o de controle
Y = lsim(Caa*(1-sistema), referencia, t);
plot(t, [Y controle])
axis([0, 1, -1.2, 6]);
legend('Te�rico', 'Pr�tico');
xlabel('Tempo (s)');

%% Resposta � rampa
rampa = lsim(1/s, referencia, t);
Y1 = lsim(sistema, rampa, t);
Y2 = lsim(1/s, saida, t);
plot(t, [Y1 Y2], t, rampa, 'r-.')
axis([0, 2, 0, 2]);
legend('Te�rico', 'Pr�tico', 'Location', 'NorthWest');
xlabel('Tempo (s)');