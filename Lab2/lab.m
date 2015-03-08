%% Lab 2 - Pr� Relat�rio
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

%% Fun��es de transfer�ncia de cada est�gio
% As equa�es foram obtidas pelo circuito j� transformado para a frequ�ncia por Laplace
s = tf('s');
G1 = tf(-z2/z1)
G2 = -z4/(z3*(z4*c1*s+1))
G3 = -z6/(z5*(z6*c2*s+1))
G4 = -1/(z7*c3*s)

%% Fun��o de trasfer�ncia completa
G = minreal(G1*G2*G3*G4)

%% Diagrama de bode
% Incluindo margens de fase e ganho do sistema
margin(G);

%% Entrada
% Uma onda quadrada de 1 Hz e amplitude 1 (volt)
t = 0:.0001:3;
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