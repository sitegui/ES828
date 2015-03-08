%% Lab 2 - Pré Relatório
% Intro

%% Valores dos resistores
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

%% Funções de transferência de cada estágio
% As equaçes foram obtidas pelo circuito já transformado para a frequência por Laplace
s = tf('s');
G1 = tf(-z2/z1)
G2 = -z4/(z3*(z4*c1*s+1))
G3 = -z6/(z5*(z6*c2*s+1))
G4 = -1/(z7*c3*s)

%% Função de trasferência completa
G = G1*G2*G3*G4

%% Diagrama de bode
% Incluindo margens de fase e ganho do sistema
margin(G);

%% Entrada
% Uma onda quadrada de 1 Hz e amplitude 1 (volt)
t = 0:.0001:4;
r = square(2*pi*t)*0.5+0.5;
plot(t,r);
axis([0 4 -0.1 1.1]);
xlabel('t (s)');
ylabel('r (V)');

%malha aberta
% figure, lsim(v1,r,t)
% figure, lsim(v2,r,t)
% figure, lsim(v3,r,t)
% figure, lsim(y,r,t)
