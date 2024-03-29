%% ES868 � Pr�-Relat�rio Lab 8
% *Identifica��o de um motor de corrente cont�nua*
%
% Turma A - 23/05/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza � 117093
% * Vin�cius Ragazi David - 120258
% clear all; close all; clc;
load ../lab7/planta.mat

%% Controlador proporcional

% Compensador para o damping sugerido de 0.7102 n�o � poss�vel para o
% proporcional, com C1 = 124.75 (o sistema n�o consegue fornecer a voltagem necess�ria).
% Pode-se, no entanto, utilizar um controlador de menor ganho, 10.

C1 = 10;

T1 = feedback(G * C1,1)


for vel = [50,80,100]
figure
step(T1*vel,vel)
legend('Sa�da')
figure
step(C1*(vel-T1), vel);
legend('Esfor�o de Controle')
end

%% Controlador proporcional para os outros dois requisitos.

C2 = 126;
T2 = feedback(G * C2,1)

for vel = [50,80,100]
figure
step(T2*vel,vel)
legend('Sa�da')
figure
step(C2*(vel-T2), vel);
legend('Esfor�o de Controle')
end

%% Controlador Integral


