%% GOKART DRIVETRAIN DYNAMICS & ACCELERATION SIMULATION
clear; clc; close all;

global eta u r JM JK1 JK2 JV1 JV2 JL f m g c rho A

% Parametrar
m   = 135;      r   = 0.135;    A   = 0.50;
f   = 0.012;    g   = 9.81;     c   = 0.60;     rho = 1.22;
JM  = 0.020;    JK1 = 0.000;    JK2 = 0.0001;
JV1 = 0.000;    JV2 = 0.002;    JA  = 0.001;    JB  = 0.002;    JH = 0.023;
JL  = JA + JB + 4*JH + m*r^2;
n0  = 1000;     u   = 3.0;      eta = 0.97;

% 1. Momentkurvor
n1 = n0:8000;
omega1 = n1 * 2*pi / 60;
v_eval = (omega1 / u) * r;
MM = motormoment(omega1);
MK = kopplingsmoment(omega1);
ML = lastmoment(v_eval);

fig1 = figure('Position', [100, 100, 750, 450]);
plot(n1, MM, 'b-', 'LineWidth', 2); hold on;
plot(n1, MK, 'r-', 'LineWidth', 2);
plot(n1, ML/(eta*u), 'Color', [0.85, 0.65, 0.13], 'LineWidth', 2);
grid on;
xlabel('Engine Speed n_1 [rpm]'); ylabel('Torque M [Nm]');
title('Torque Matching: Honda GC190 vs Centrifugal Clutch & Road Load');
legend('Engine Torque (M_m)', 'Clutch Torque Capacity (M_k)', 'Reflected Load (M_L / \eta u)', 'Location', 'NorthEast');
xlim([1000, 8000]); ylim([0, 12]);
% saveas(fig1, '../assets/torque_characteristics.png');

% 2. Dynamisk integrering
tspan = 0:0.001:90;
IC = [n0*2*pi/60, 0, 0, 0, 0];
opts = odeset('RelTol', 1e-9);
[T, Y] = ode45(@derivataacceleration, tspan, IC, opts);

N1 = Y(:,1) * 60 / (2*pi);
N2 = Y(:,2) * 60 / (2*pi);
N3 = Y(:,3) * 60 / (2*pi);
V_kmh = Y(:,4) * 3.6;

fig2 = figure('Position', [150, 150, 800, 500]);
subplot(2,1,1);
plot(T, N1, 'b-', 'LineWidth', 2); hold on;
plot(T, N2, 'r--', 'LineWidth', 1.8);
plot(T, N3, 'Color', [0.85, 0.65, 0.13], 'LineWidth', 1.8);
grid on; ylabel('Rotational Speed [rpm]');
legend('Engine (n_1)', 'Clutch Drum (n_2)', 'Rear Axle (n_3)', 'Location', 'East');
title('Transient Velocity & Speed Response');

subplot(2,1,2);
plot(T, V_kmh, 'k-', 'LineWidth', 2);
grid on; xlabel('Time t [s]'); ylabel('Vehicle Speed [km/h]');
saveas(fig2, '../assets/acceleration_profile.png');
disp('Bilder sparade i assets/!');