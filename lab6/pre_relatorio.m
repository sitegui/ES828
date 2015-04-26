%% ES868 – Pré Relatório Lab 6
% *Controle por realimentação de saída de uma planta eletrônica*
%
% Turma A - 26/04/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza – 117093
% * Vinícius Ragazi David - 120258

clear all
load ../G.mat

%% Localização dos polos
% Deseja-se que o tempo de estabilização seja de 0.5s e o coeficiente de
% amortecimento seja $\sqrt{2}/2$
%
% Dessa forma, $\xi = \sqrt{2}/2$
t_e = 0.5;
xi = sqrt(2)/2

%%
% Como $t_e = 4 / (\xi \cdot \omega_n)$, obtém-se
omega_n = 4/t_e/xi

%%
% Dessa forma, os dois pólos dominantes serão
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

%% Determinação da matriz K
K = place(A, B, p)

%% Pólos do observador
% Os pólos do observador devem ser escolhidos de forma que o estado
% estimado siga o estado verdadeiro o mais rápido possível. Para isso, eles
% devem estar mais à esqueda que os pólos do controlador.
%
% Dessa forma, foi escolhido arbitrariamente que a parte real deveria ser
% 50% mais negativa
po = p+real(p)*0.5

%% Determinação da matriz L
L = place(A', C', po)'

%% Determinação de M(s)
% Para determinar M(s) precisamos antes definir S
%
% $$S(s) = C (s I - (A - B K))^{-1} B$$
s = tf('s');
I = eye(3);
S = C*inv(s*I - (A - B*K))*B

%%
% O primeiro passo é determinar M(0) = [m1; m2; m3], fazendo
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

%% Simulação do sistema
H = minreal(K*M)
temp = minreal(inv(s*I - (A - L*C)));
C_u = minreal(K*temp*B)
C_y = minreal(minreal(K*temp)*L)

%% Função de transferência de malha fechada
sistema = minreal(H*G / (1+C_u+G*C_y), 1e-4)
step(sistema)
[Y, t] = step(sistema);