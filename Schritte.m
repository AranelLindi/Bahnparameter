close all;
clear all;

%% Berechnung der Bahnparameter in 8 Schritten:
% Voraussetzung: r(t0) und v(t0) müssen gegeben sein, hier eintragen:

mu = 398600; % Gravitationskonstante in km^3/s^2; hier: Erde

t0 = 0; % in s
r0 = [-39020; 44500; 38500]; % r(t0) in km
v0 = [3.150; -4.830; -2.860]; % v(t0) in km/s

%% Vorberechnung einiger Parameter:
% Einheitsvektoren in Orbitalebene:
betr_r0 = norm(r0);

e_zE = [0; 0; r0(3,1)] / norm(r0);
e_xE = [r0(1,1); 0; 0] / norm(r0);
e_yE = [0; r0(2,1); 0] / norm(r0);

e_r = r0 / norm(r0);

%% 1.) Bestimmung von h (Drehimpuls) und q (Integrationskonstante)

% Gilt wegen Drehimpulserhaltung:
h = cross(r0, v0);

% Wird über Hammilton-Integral berechnet:
q = cross(v0, h) - mu * r0 / norm(r0); % Norm gibt den Betrag eines Vektors zurück!

%% 2.) Berechnung der Exzentrizität e:

% Berechnung des Halbparameters p:
p = norm(h)^2 / mu;

% Berechnung der Exzentrizität e:
e = norm(q) / mu;

% Abhängig von der Exzentrizität e, die große Halbachse berechnen:
if e == 0 % Kreis
    disp("Kreis");
    a = p / (1 - e^2); % Orbit ist Kreis
elseif e < 1 % Ellipse
    disp("Ellipse");
    a = p / (1 - e^2); % Orbit ist entweder Kreis oder Ellipse
elseif e == 1 % Orbit ist parabolisch
    disp("Parabel");
    % Bei parabolischem Verlauf als Grenzfall, geht a gegen unendlich!
    a = inf;
elseif e > 1 % Orbit ist hyperbolisch 
    disp("Hyperbel");
    a = p / (e^2 - 1); % (Gleichung gilt nur für diesen Fall!)
end
%% 3.) Berechnung der Einheitsvektoren:

% Vektor in z-Richtung:
e_z0 = h/norm(h);

% Vektor in x-Richtung:
e_x0 = q/norm(q);

% Vektor in y-Richtung:
e_y0 = cross(e_z0, e_x0);

% Knotenlinie zwischen Äquator und Orbitalebene:
n = norm(cross(e_zE, e_z0)) * cross(e_zE, e_z0);

%% 4.) Neigung des Orbits i:
% Inklination i:
i = acos(dot(e_z0, e_zE) / (norm(e_z0) * norm(e_zE)));
i_rad = i * 180 / pi;

%% 5.) Lage des aufsteigenden Knotens / Raan / Omega:
Omega = acos(dot(n, e_xE) / (norm(n) * norm(e_xE)));
Omega_rad = Omega * 180 / pi;

%% 6.) Perigäumsargument omega
omega = acos(dot(n, e_x0) / (norm(n) * norm(e_x0)));
omega_rad = omega * 180 / pi;

%% 7.) Wahre Anomalie Theta0:
Theta0 = acos(dot(e_r, e_x0) / (norm(e_r) * norm(e_x0)));
Theta0_rad = Theta0 * 180 / pi;

%% 8.) Bestimmung des Perigäumsdurchganges aus der Keplergleichung tp:
tp = 0;
tau0 = 0;

% Berechnung von tp abhängig von der Exzentrizität e, also dem
% Bahncharakteristik
if e == 0 % Kreis
    tp = t0 - Theta0 * T / (2 * pi);
elseif e < 1 % Ellipse
    E = 2 * atan(sqrt((1-e)/(1+e)) * tan(Theta0/2)); % gilt nur für Ellipse!
    tau0 = E - e * sin(E);
    T = 2 * pi * sqrt(a^3 / mu);
    tp = t0 - ((tau0 * T) / (2 * pi));
elseif e == 1 % Parabel
    u = tan(Theta0/2);
    tau0 = u^3 / 3 + u;
    tp = t0 - tau0 / 2 * sqrt(norm(p)^3 / mu);
elseif e > 1 % Hyperbel
    F = 2 * atanh(sqrt((e-1) / (e+1)) * tanh(Theta0 / 2));
    tau0 = e * sinh(F) - F;
    tp = t0 - tau0 * sqrt(a^3 / mu);
end