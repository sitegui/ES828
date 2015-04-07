%% ES868 – Pré Relatório Lab 5
% *Controle de plantas eletrˆonicas utilizando um controlador atraso-avanço digital*
%
% Turma A - 06/04/2015
%
% * Augusto Miranda Garcia - 104627
% * Guilherme de Oliveira Souza – 117093
% * Vinícius Ragazi David - 120258

load ../G.mat
load ../pids.mat
referencia = ones(2000, 1);
t = linspace(0, 2, 2000);
s = tf('s');

%% Determinação do K
% Fazendo $C(s) = K$ e buscando por um erro em regime permanente a uma
% entrada rampa de 2%:
%
% $$\frac{e(s)}{u(s)} = \frac{1}{1+C(s) G(s)}$$
% 
% $$\lim_{s \to 0}{s \cdot \frac{e(s)}{u(s)} \cdot \frac{1}{s^2}} = 0.02$$
% 
% With $gk = \lim_{s \to 0}{s G(s)}$:
%
% $$K = \frac{50}{gk}$$
kg = evalfr(minreal(s*G), 0)
K = 50/kg
t = 0:0.001:2;
referencia = ones(length(t));
referencia = referencia(1,:);
%% Margem de fase
[~, Mf] = margin(K*G)

%% Margem de fase desejada
Md = 45;
phi = Md-Mf
alpha_v = (1+sin(degtorad(phi)))/(1-sin(degtorad(phi)))

%% Frequência de cruzamento
amplitude = sqrt(alpha_v);
[~, ~, ~, Wg] = margin(K*G/amplitude)

%% Parâmetros restantes
tau_v = 1/(Wg*sqrt(alpha_v))
alpha_t = 1/alpha_v
tau_t = 10*alpha_v*tau_v/alpha_t

%% Controlador
C_v = (alpha_v*tau_v*s+1)/(tau_v*s+1);
C_t = (alpha_t*tau_t*s+1)/(tau_t*s+1);
C = K*C_v*C_t

%% Comparação de desempenho
Y1 = lsim(feedback(C*G, 1), referencia, t);
Y2 = lsim(feedback(Ck*G, 1), referencia, t);
Y3 = lsim(feedback(Csiso*G, 1), referencia, t);
plot(t, [Y1 Y2 Y3])
xlim([0, 1]);
legend('Atraso-avanço', 'Proporcional', 'Siso Tool');
xlabel('Tempo (s)');

%%
% Desempenho
stepinfo(feedback(C*G, 1))

%% Erro à rampa
rampa = lsim(1/s, referencia, t);
lsim(feedback(C*G, 1), rampa, t);
axis([0, 1, 0, 1])