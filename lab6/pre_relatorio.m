%% ES868 � Pr� Relat�rio Lab 6
% *Controle por realimenta��o de sa�da de uma planta eletr�nica*
%
% Turma A - 26/04/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza � 117093
% * Vin�cius Ragazi David - 120258

clear all
load ../G.mat

%% Localiza��o dos polos
% Deseja-se que o tempo de estabiliza��o seja de 0.5s e o coeficiente de
% amortecimento seja $\sqrt{2}/2$
%
% Dessa forma, $\xi = \sqrt{2}/2$
t_e = 0.5;
xi = sqrt(2)/2

%%
% Como $t_e = 4 / (\xi \cdot \omega_n)$, obt�m-se
omega_n = 4/t_e/xi

%%
% Dessa forma, os dois p�los dominantes ser�o
p1 = omega_n*(-xi+i*sqrt(1-xi*xi))
p2 = omega_n*(-xi-i*sqrt(1-xi*xi))

%%
% O terceiro polo foi escolhido arbitrariamente como sendo em -30
p3 = -30;
p = [p1; p2; p3];

%% Modelo de estados
Gss = ss(G)
A = Gss.a;
B = Gss.b;
C = Gss.c;

%% Determina��o da matriz K
K = acker(A, B, p)

%% P�los do observador
% Os p�los do observador devem ser escolhidos de forma que o estado
% estimado siga o estado verdadeiro o mais r�pido poss�vel. Para isso, eles
% devem estar mais � esqueda que os p�los do controlador.
%
% Dessa forma, foi escolhido arbitrariamente que a parte real deveria ser
% 50% mais negativa
po = [-150, -150, -150]

%% Determina��o da matriz L
L = acker(A', C', po)'

%% Determina��o de M(s)
% Para determinar M(s) precisamos antes definir S
%
% $$S(s) = C (s I - (A - B K))^{-1} B$$
s = tf('s');
I = eye(3);
S = C*inv(s*I - (A - B*K))*B

%%
% O primeiro passo � determinar M(0) = [m1; m2; m3], fazendo
% 
% $$S(0) K M(0) = 1$$
M0 = pinv(evalfr(S, 0)*K)

%%
% Supondo:
%
% $$M(s) = \frac{s/\tau + 1}{s/30 + 1} M0$$
%
% Deve-se determinar $\tau$ de forma que:
%
% $$(\frac{d}{ds} S(s) K M(s))_{s=0} = 0$$
sx = sym('s');
taux = sym('tau');
Sx = poly2sym(S.num{1}, sx)/poly2sym(S.den{1}, sx);
Mx = (sx/taux+1)/(sx/30+1)*M0;
tau = eval(solve(subs(diff(Sx*K*Mx, sx), sx, 0) == 0))
M = (s/tau+1)/(s/30+1)*M0

%% Simula��o do sistema
H = minreal(K*M)
temp = minreal(inv(s*I - (A - L*C)));
C_u = minreal(K*temp*B)
C_y = minreal(minreal(K*temp)*L)

%% Fun��o de transfer�ncia de malha fechada
sistema = minreal(H*G / (1+C_u+G*C_y), 1e-4)
step(sistema)
stepinfo(sistema)