% created by lzq
function Init()

global Adrc Flag AdrcOut PlantOut HallOut Plant Hall

%% Plant
K = 25; Omega0 = 60; Qm = 2;
P = tf(K, [1/Omega0^2 1/(Omega0*Qm) 1]);
disp("plant set: ok")
% SAT
Adrc.threshold = 130;

%% Param
Adrc.fs = 2e3;
Adrc.Ts = 1/Adrc.fs;
Adrc.tend = 4;
Adrc.T = 0:Adrc.Ts:Adrc.tend;

Adrc.gyroAmp = 1000;
Adrc.gyroFreq = 4;
Adrc.target = Adrc.gyroAmp*sin(2*pi*Adrc.gyroFreq*Adrc.T);

Flag.sat = 1;
Flag.iir = 1;

Adrc.r = 5e7;                       % TD.r
Adrc.b0 = K*Omega0^2;               % K*omega0^2
Adrc.omegac = 2*pi*110;             % Controller BW
Adrc.gamma = 1.5;                   % omegac*gamma is ESO BW

Adrc.h0 = 1/Adrc.fs;             % TD.h0
Adrc.omegao = Adrc.omegac*Adrc.gamma;   % ESO BW
Adrc.beta1 = 3*Adrc.omegao;
Adrc.beta2 = 3*Adrc.omegao^2;
Adrc.beta3 = Adrc.omegao^3;
Adrc.l1 = Adrc.omegac^2;
Adrc.l2 = 2*Adrc.omegac;
disp("adrc param set: ok")

%% Out
AdrcOut = zeros(1, length(Adrc.target));
PlantOut = zeros(1, length(Adrc.target));
HallOut = zeros(1, length(Adrc.target)+1);
disp("process data preparation: ok")


%% Plant
dsysp = c2d(P,Adrc.Ts,'t');
[Plant.bz, Plant.az] = tfdata(dsysp, 'v');
disp("Plant coefficient: ok")

%% Hall
% IIR
alpha = AlphaDesign(400,Adrc.fs);
Hall.iir_bz = [1-alpha, 0];
Hall.iir_az = [1, -alpha];
disp("Hall IIR coefficient: ok")