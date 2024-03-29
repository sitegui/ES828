%% ES868 � Pr� Relat�rio Lab 2
% *Identifica��o de plantas eletr�nicas*
%
% Turma A - 08/03/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza � 117093
% * Vin�cius Ragazi David - 120258

%% Objetivos
% O objetivo do pr�-relat�rio � o equacionamento do circuito dado e a
% defini��o de alguns par�metros para serem levados como base para o 
% experimento pr�tico.

%% Equacionamento
% 
% <<equacionamento.png>>
%
% Para o equacionamento dos quatro est�gios como tamb�m do circuito como um
% todo levamos como base que a corrente que entra pelos polos positivos e
% negativos do amplificador operacional s�o zero, assim como a sua
% diferen�a de potencial. Desta forma temos:
% 
% $$\frac{V_{out}}{V_{in}} = -\frac{Z_{out}}{Z_{in}}$$
% 
% Onde $V_{out}$ � a sa�da e $V_{in}$ � a entrada, ambas em Volts, e
% $Z_{out}$ � a imped�ncia da sa�da e $Z_{in}$ a imped�ncia de entrada.
% Assim a fun��o de transfer�ncia ser� $H = V_{out}/V_{in}$.

%% Fun��es de transfer�ncia de cada est�gio
% Usando os seguintes valores para as imped�ncias e capacit�ncias:

z1 = 100e3;
z2 = 10e3;
z3 = 100e3;
z4 = 220e3;
z5 = 100e3;
z6 = 470e3;
z7 = 1e6;
c1 = 0.1e-6;
c2 = 0.1e-6;
c3 = 0.1e-6;

%%
% As equa�es foram obtidas pelo circuito j� transformado para a frequ�ncia
% por Laplace:
%
% $$G1(s) = -\frac{z_2}{z_1}$$, 
% $$G2(s) = -\frac{z_4}{z_3 (z_4 c_1 s + 1)}$$, 
% $$G3(s) = -\frac{z_6}{z_5 (z_6 c_2 s + 1)}$$, 
% $$G4(s) = -\frac{1}{z_7 c_3 s}$$

s = tf('s');
G1 = tf(-z2/z1)
G2 = minreal(-z4/(z3*(z4*c1*s+1)))
G3 = minreal(-z6/(z5*(z6*c2*s+1)))
G4 = minreal(-1/(z7*c3*s))

%% Fun��o de trasfer�ncia completa
%
% A cascata de todos os est�gios com o amplificador operacional 
% impede a influ�ncia dos componentes din�micos do circuito, gerando:
%
% $$G(s) = G1(s) G2(s) G3(s) G4(s)$$
G = minreal(G1*G2*G3*G4)

%% Diagrama de bode
% Incluindo margens de fase e ganho do sistema.
% Levando em considera��o a rela��o da entrada $r$ para a sa�da $y$ temos
% a resposta ao impulso do circuito ao todo. Com isso podemos analisar a
% estabilidade do sistema via o diagrama de bode do mesmo.
margin(G);

%%
% Verifica-se desta forma que o sistema � est�vel, j� que tanto a margem de
% fase (54,9�) quanto a de ganho (16,2dB) s�o positivas.

%% Entrada
% Uma onda quadrada de 1 Hz e amplitude 1 (volt)
t = 0:.001:4;
r = square(2*pi*t)*0.5+0.5;
plot(t,r);
axis([0 3 -0.1 1.1]);
xlabel('t (s)');
ylabel('r (V)');

%% Sa�da dos est�gios
lsim(G1,r,t), title('Sa�da est�gio I (y1)'), snapnow;
lsim(G1*G2,r,t), title('Sa�da est�gio II (y2)'), snapnow;
lsim(G1*G2*G3,r,t), title('Sa�da est�gio III (y3)'), snapnow;
lsim(G,r,t), title('Sa�da est�gio IV (y)');
%% 
% Verifica-se que as respostas s�o est�veis, a n�o ser o caso levando em
% contas todos os est�gios (fica claro que a amplitude da sa�da cresce
% indefinidamente). Desta forma se levando em considera��o apenas a
% estabilidade do sistema, o �nico a ser controlado � exatamente o
% que possui como entrada r e sa�da y.
