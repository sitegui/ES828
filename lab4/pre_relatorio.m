%% ES868 � Pr� Relat�rio Lab 4
% *Controle de plantas eletr�onicas utilizando um controlador PID anal�gico*
%
% Turma A - 30/03/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza � 117093
% * Vin�cius Ragazi David - 120258

load ../G.mat
load ../pids.mat
load ../lab3/sinais_tratados.mat
s = tf('s');

%% Controlador escolhido
% Dentre os tr�s controladores PID desenvolvidos no lab passado, o que
% apresentou melhor desempenho (menor overshoot e melhor tempo de
% estabiliza��o) foi o terceiro, feito pelo sisotool.
%
% Veja compara��o abaixo:
plot([referencia, saida1, saida2, saida3]);
legend('Refer�ncia', 'Proporcional', 'Ziegler-Nichols', 'Siso Tools');
ylim([0, 1.8]);
xlabel('Tempo (s)');

%% Compara��o teoria vs pr�tica
% O gr�fico abaixo mostra a compara��o do comportamento do modelo te�rico
% da planta e do controlador com os dados coletados no laborat�rio:
sistema = feedback(Csiso*G,1);
saida_teorica = lsim(sistema, referencia, t);
plot(t, [referencia, saida_teorica, saida3]);
xlim([0, 1]);
xlabel('Tempo (s)');
legend('Refer�ncia', 'Sa�da esperada', 'Sa�da observada');

%% Desempenho buscado
% O desempenho te�rico do controlador �:
desempenho = stepinfo(sistema)
tempo = desempenho.SettlingTime;
overshoot = desempenho.Overshoot;

%% Valores de resistores
% Os poss�veis valores de resistores s�o:
valores = [1, 10, 27, 39, 47, 68, 100, 120, 150, 180,...
	200, 220, 270, 330, 390, 470, 560, 680, 1e3, 1.2e3,...
	1.5e3, 1.8e3, 2.2e3, 2.7e3, 3.3e3, 3.9e3, 4.7e3, 6.8e3, 10e3, 12e3,...
	15e3, 20e3, 22e3, 27e3, 33e3, 39e3, 51e3, 56e3, 58e3, 68e3,...
	100e3, 150e3, 330e3, 470e3, 510e3, 560e3, 820e3, 200e3, 220e3, 270e3];

%% Poss�veis arranjos
% Todos os arranjos ser�o considerados
C = 1e-6;
erro = 0.25;
minKd = (1-erro)*Csiso.Kd;
maxKd = (1+erro)*Csiso.Kd;
minKp = (1-erro)*Csiso.Kp;
maxKp = (1+erro)*Csiso.Kp;
minKi = (1-erro)*Csiso.Ki;
maxKi = (1+erro)*Csiso.Ki;
arranjos = [];
for R1 = valores
	for R2 = valores
		if R2 >= R1/10
			% Queremos R2 << R1
			continue
		end
		for R3 = valores
			Kd = R1*R3*C/(R1+R2);
			Kp = (R1+R3)/(R1+R2);
			Ki = 1/((R1+R2)*C);
			if Kd > minKd && Kd < maxKd && Kp > minKp && Kp < maxKp && Ki > minKi && Ki < maxKi
				arranjos = [arranjos [R1 R2 R3]'];
			end
		end
	end
end
arranjos

%% Melhor arranjo
tempos = [];
overshoots = [];
Ys = [];
for R = arranjos
	numerador = R(1)*R(3)*C^2*s^2+(R(1)+R(3))*C*s+1;
	denominador = R(1)*R(2)*C^2*s^2+(R(1)+R(2))*C*s;
	controlador = numerador/denominador;
	sistema2 = feedback(controlador*G, 1);
	desempenho2 = stepinfo(sistema2);
	tempos = [tempos desempenho2.SettlingTime];
	overshoots = [overshoots desempenho2.Overshoot];
	Ys = [Ys lsim(sistema2, referencia, t)];
end
plot(t, Ys);
xlim([0 1]);
xlabel('Tempo (s)');

diff_tempos = abs(tempos/tempo-1);
diff_overshoots = abs(overshoots/overshoot-1);
diff_t_o = diff_tempos.^2 + diff_overshoots.^2;
melhor_i = find(diff_t_o == min(diff_t_o), 1)

%%
% O melhor arranjo escolhido foi:
arranjos(:, melhor_i)

plot(t, [referencia, saida_teorica, saida3, Ys(:,melhor_i)]);
xlim([0, 1]);
xlabel('Tempo (s)');
legend('Refer�ncia', 'Sa�da esperada', 'Sa�da observada', 'Nova sa�da');

%% Sinal de controle
% Veremos se o sinal est� entre -10 e +10 (limites f�sicos da planta)
R = arranjos(:, melhor_i);
numerador = R(1)*R(3)*C^2*s^2+(R(1)+R(3))*C*s+1;
denominador = R(1)*R(2)*C^2*s^2+(R(1)+R(2))*C*s;
controlador = numerador/denominador;
sistema2 = feedback(controlador*G, 1);
step(controlador*(1-sistema2), 1);
ylim([-10, 10]);

%%
% Com isso, � poss�vel observar que o sinal de controle tem um grande pico
% em t0, mas todo o restante fica contido na faixa desejada.