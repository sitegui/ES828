close all; clear all; clc;

load matlab.mat

t1 = a1(:, 1) * 10e-3;
t2 = a2(:, 1) * 10e-3;
t3 = a3(:, 1) * 10e-3;
t4 = a4(:, 1) * 10e-3;

t11 = a11(:, 1) * 10e-3;
t22 = a22(:, 1) * 10e-3;
t33 = a33(:, 1) * 10e-3;
t44 = a44(:, 1) * 10e-3;

figure, plot(t1,a1( :,2));
figure, plot(t2,a2( :,2));
figure, plot(t3,a3( :,2));
figure, plot(t4,a4( :,2));
