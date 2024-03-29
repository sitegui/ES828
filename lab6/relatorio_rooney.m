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
load ../lab3/sinais_tratados.mat
load ../lab4/sinais_tratados4p5.mat
load ../lab5/sinais_tratados.mat
saida5 = saida;
load sinais_tratados.mat

s = tf('s');

%% Resposta ao degrau
plot(t, saida)
axis([0, 1, 0, 1.2]);
legend('Pr�tico');
xlabel('Tempo (s)');

%% Desempenho
%stepinfo(sistema)
stepinfo(saida, t, 1)

%% Esfor�o de controle
Y = lsim(Caa*(1-sistema), referencia, t);
plot(t, controle)
axis([0, 1, -1.2, 6]);
legend('Pr�tico');
xlabel('Tempo (s)');

%% Resposta � rampa
rampa = lsim(1/s, referencia, t);
Y2 = lsim(1/s, saida, t);
plot(t, Y2, t, rampa, 'r-.')
axis([0, 2, 0, 2]);
legend('Pr�tico', 'Location', 'NorthWest');
xlabel('Tempo (s)');

%% Compara��o entre os controladores pr�ticos

plot(t,[referencia, saida1, saida2, saida3, saida4,saida5,saida]);
legend('Refer�ncia', 'Proporcional', 'Ziegler-Nichols', 'PID Sisotool', 'PID anal�gico','Avan�o-atraso','Estados');
ylim([0, 1.8]);
xlabel('Tempo (s)');
