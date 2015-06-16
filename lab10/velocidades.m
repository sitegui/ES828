clear all;

v = load('../lab9/velocidade_livre_disco1.lvm');
v = smooth(medfilt1(smooth(v, 5), 17), 5);
v = v(70:3800);

v1 = load('velocidade.lvm');
v2 = load('velocidade_1.lvm');
v3 = load('velocidade_2.lvm');
v4 = load('velocidade_3.lvm');
v5 = load('velocidade_4.lvm');
v6 = load('velocidade_5.lvm');

c1 = load('controle.lvm');
c2 = load('controle_1.lvm');
c3 = load('controle_2.lvm');
c4 = load('controle_3.lvm');
c5 = load('controle_4.lvm');
c6 = load('controle_5.lvm');

n = min([numel(v1), numel(v2), numel(v3), numel(v4), numel(v5), numel(v6)]);
v1 = v1(1:n);
v2 = v2(1:n);
v3 = v3(1:n);
v4 = v4(1:n);
v5 = v5(1:n);
v6 = v6(1:n);
c1 = c1(1:n);
c2 = c2(1:n);
c3 = c3(1:n);
c4 = c4(1:n);
c5 = c5(1:n);
c6 = c6(1:n);
v = [v; ones(n-numel(v), 1)*v(end)];
t = linspace(0, (n-1)*10e-3, n)';

v1 = smooth(medfilt1(smooth(v1, 5), 17), 5);
v2 = smooth(medfilt1(smooth(v2, 5), 17), 5);
v3 = smooth(medfilt1(smooth(v3, 5), 17), 5);
v4 = smooth(medfilt1(smooth(v4, 5), 17), 5);
v5 = smooth(medfilt1(smooth(v5, 5), 17), 5);
v6 = smooth(medfilt1(smooth(v6, 5), 17), 5);
plot(t, [v1 v2 v3 v4 v5 v6 v]);
legend('1 0.1', '2 0.2', '1 0.2', '1 0', '2 0', '2 0.1', 'Sem Controle');
xlim([0, 30]);
ylim([0, 100]);