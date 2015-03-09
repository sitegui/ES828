%% ES868 – Pré Relatório Lab 2
% *Identificação de plantas eletrônicas*
%
% Turma A - 08/03/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza – 117093
% * Vinícius Ragazi David - 120258

%% Objetivos
% O objetivo do pré-relatório é o equacionamento do circuito dado e a
% definição de alguns parâmetros para serem levados como base para o 
% experimento prático.

%% Equacionamento
% 
% <<equacionamento.png>>
%
% Para o equacionamento dos quatro estágios como também do circuito como um
% todo levamos como base que a corrente que entra pelos polos positivos e
% negativos do amplificador operacional são zero, assim como a sua
% diferença de potencial. Desta forma temos:
% 
% $$\frac{V_{out}}{V_{in}} = -\frac{Z_{out}}{Z_{in}}$$
% 
% Onde $V_{out}$ é a saída e $V_{in}$ é a entrada, ambas em Volts, e
% $Z_{out}$ é a impedância da saída e $Z_{in}$ a impedância de entrada.
% Assim a função de transferência será $H = V_{out}/V_{in}$.

%% Funções de transferência de cada estágio
% Usando os seguintes valores para as impedâncias e capacitâncias:

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
% As equaçes foram obtidas pelo circuito já transformado para a frequência
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

%% Função de trasferência completa
%
% A cascata de todos os estágios com o amplificador operacional 
% impede a influência dos componentes dinâmicos do circuito, gerando:
%
% $$G(s) = G1(s) G2(s) G3(s) G4(s)$$
G = minreal(G1*G2*G3*G4)

%% Diagrama de bode
% Incluindo margens de fase e ganho do sistema.
% Levando em consideração a relação da entrada $r$ para a saída $y$ temos
% a resposta ao impulso do circuito ao todo. Com isso podemos analisar a
% estabilidade do sistema via o diagrama de bode do mesmo.
margin(G);

%%
% Verifica-se desta forma que o sistema é estável, já que tanto a margem de
% fase (54,9º) quanto a de ganho (16,2dB) são positivas.

%% Entrada
% Uma onda quadrada de 1 Hz e amplitude 1 (volt)
t = 0:.001:4;
r = square(2*pi*t)*0.5+0.5;
plot(t,r);
axis([0 3 -0.1 1.1]);
xlabel('t (s)');
ylabel('r (V)');

%% Saída dos estágios
lsim(G1,r,t), title('Saída estágio I (y1)'), snapnow;
lsim(G1*G2,r,t), title('Saída estágio II (y2)'), snapnow;
lsim(G1*G2*G3,r,t), title('Saída estágio III (y3)'), snapnow;
lsim(G,r,t), title('Saída estágio IV (y)');