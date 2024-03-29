%% ES868 � Pr� Relat�rio Lab 3
% *Controle de plantas eletr�nicas utilizando um controlador PID digital*
%
% Turma A - 16/03/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza � 117093
% * Vin�cius Ragazi David - 120258

load ../G.mat
s = tf('s');

%% Controlador proporcional
% Para se obter o tempo m�nimo de estabiliza��o, os p�los de malha fechadas
% tem de estar � mais esquerda poss�vel. Observando o root locus da planta:
rlocus(G)

%%
% Pode-se observar que isso ir� ocorrer quando os dois p�los (verde e azul
% na figura) se encontrarem, no ponto pr�ximo de -20. Para obter a
% coordenada exata desse ponto, pode-se verificar a multiplicidade das
% ra�zes da equa��o carater�stica $1 + k G(s) = 0$.
%
% No nosso caso, com $G(s) = \frac{P(s)}{Q(s)} = \frac{A}{B s^3 + C s^2 + D
% s + E}$ , $k(s) = -\frac{B s^3 + C s^2 + D s + E}{A}$.
%
% Como o ponto buscando � raiz dupla de $k(s)$, ele � raiz da derivada de
% $k(s)$ em $s$, ou seja, raiz de $-\frac{3 B s^2 + 2 C s + D}{A}$.

%% 
% Substituindo os valores dos coeficientes e resolvendo, chegamos em
A = G.num{1}(4);
den = G.den{1};
raizes = roots(-polyder(den)/A)

%%
% Observando o gr�fico do root locus mostrado anteriormente, sabemos ent�o
% que o valor buscado � $s = -17.7369$ e
k = -polyval(den, -17.7369)/A

%%
% 
% <<../imgs/rlocus - C1.jpg>>
%
%%
%
% <<../imgs/Step - C1.jpg>>
%


%%
% A resposta � rampa do controlador � exibida abaixo:
dt = 0.001;
t = 0:dt:5;
rampa = t;
sistema = feedback(k*G, 1);
%lsim(sistema, rampa, t);
%title('Resposta � rampa do controlador proporcional');

%%
%
% <<../imgs/rampa - C1.jpg>>
% 

%%
% Entrada quadrada de amplitude 1 e 0.25Hz
onda_quadrada = square(2*pi*0.25*t)*0.5+0.5;
plot(t, onda_quadrada);
ylim([-0.1, 1.1]);
title('Entrada quadrada');
xlabel('t (s)');

%%
% Resposta � onda quadrada
lsim(sistema, k*(1-sistema), 'g:', onda_quadrada, t);
title('Reposta � onda quadrada');
legend('y(t)', 'u(t)');

%%
% Entrada de rampa
onda_rampa = cumsum(onda_quadrada)*dt;
plot(t, onda_rampa);
title('Entrada em rampa');
xlabel('t (s)');

%%
% Resposta � rampa
lsim(sistema, k*(1-sistema), '-.', onda_rampa, t);
title('Reposta � rampa');
legend('y(t)', 'u(t)');

%% Controlador de Ziegler Nichols
% O primeiro passo no m�todo de Ziegler Nichols � encontrar $k = k_{osc}$
% que deixa a planta no limiar de estabilidade quando em malha fechada:
%
% Para isso pode ser usado o crit�rio de Routh com a equa��o caracter�stica:
%
% $$1 + k G(s) = 0$$
%
% $$1 + \frac{8.993 k}{0.0003019 s^3 + 0.03622 s^2 + s} = 0$$
%
% $$\frac{0.0003019 s^3 + 0.03622 s^2 + s + 8.993 k}{0.0003019 s^3 + 0.03622 s^2 + s} = 0$$
%
% $$0.0003019 s^3 + 0.03622 s^2 + s + 8.993 k = 0$$
%
% Com o crit�rio de Routh chega-se em: $k = \frac{0.03622}{0.0003019 *
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
% Compara��o antes vs depois da altera��o manual do lugar dos p�los:
% 
% <<../imgs/ziegler-nichols.png>>
kp_2 = 1.31*kp;
C_2 = 1.31*C

%%
% C�lculo dos valores de desempenho
sistema = feedback(G*C_2, 1);
%%
% <<../imgs/ziegler-nichols_step.png>>

%% 
% Desempenho do sistema discreto
Ts = 0.001;
Gz = c2d(G, Ts, 'zoh');
Cz = c2d(C_2, Ts, 'matched');
sistemaZ = feedback(Gz*Cz, 1);
%%
% <<../imgs/ziegler-nichols_z_step.png>>

%%
% Simula��o do sistema discreto
lsim(sistemaZ, onda_quadrada, t), snapnow;
lsim(sistemaZ, onda_rampa, t)


%% Controlador utilizando o sisotool

Csiso =  (2.0301*(s+48.86))/(s+70.82);
sistemasiso = feedback(Csiso*G,1);
figure
step(sistemasiso);
figure
step(1/s*(sistemasiso));
hold on
step(1/s)
hold off
%Desempenho discreto

Gz = c2d(G, Ts, 'zoh');
Czsiso = c2d(Csiso, Ts, 'matched');
sistemaZsiso = feedback(Gz*Czsiso, 1);
figure
lsim(sistemaZsiso, onda_quadrada, t), snapnow;
figure
lsim(sistemaZsiso, onda_rampa, t)
