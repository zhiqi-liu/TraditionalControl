% created by lzq
function Init

global Flag Pid Plant Hall PidOut PlantOut HallOut

%% Param set
% Basic
Pid.fs = 2e3;
Pid.tend = 2;
Pid.Ts = 1/Pid.fs;
Pid.T = 0:Pid.Ts:Pid.tend;

Pid.CrosFreq = 200;
Pid.PM = 60;

% Target
Pid.gyroAmp = 1000;
Pid.gyroFreq = 4;
Pid.target = Pid.gyroAmp*sin(2*pi*Pid.gyroFreq*Pid.T);

% Flag
Flag.ff = 1;
Flag.sat = 1;
Flag.clamp = 1;
Flag.iir = 1;
Flag.notch = 0;

disp("param set: ok")

%% Out
PidOut = zeros(1, length(Pid.target));
PlantOut = zeros(1, length(Pid.target));
HallOut = zeros(1, length(Pid.target)+1);
disp("process data preparation: ok")

%% Pid
K = 25; Omega0 = 60; Qm = 2;
P = tf(K, [1/Omega0^2 1/(Omega0*Qm) 1]);
disp("plant set: ok")

% Kp, Ki, Kd
pidtype = "pid";
opts = pidtuneOptions("CrossoverFrequency",Pid.CrosFreq*2*pi,"PhaseMargin",Pid.PM);
[C,info] = pidtune(P,pidtype,opts);
Pid.Kp = C.Kp;
Pid.Ki = C.Ki;
Pid.Kd = C.Kd;

CP = C*P;
[mag,~,~] = bode(CP,10*2*pi);
loopgain = 20*log10(mag);

disp("Controller design: ok")
if info.Stable == 1
    disp(" - Controller is stable. ")
    disp(" - CrossoverFrequency: "+num2str(round(info.CrossoverFrequency/(2*pi)))+" Hz. ")
    disp(" - PhaseMargin: "+num2str(round(info.PhaseMargin))+" degree. ")
    disp(" - 10Hz loopgain: "+num2str(loopgain)+" dB. ")
    disp(" - Kp: "+num2str(Pid.Kp)+". ")
    disp(" - Ki: "+num2str(Pid.Ki)+". ")
    disp(" - Kd: "+num2str(Pid.Kd)+". ")
else
    warning("Controller is unstable. ")
end

% SAT
Pid.threshold = 130;

Fc = 400;
% Diff
Kd_bs = [Pid.Kd 0];
Kd_as = [1/(Fc*2*pi) 1];
sysd = tf(Kd_bs,Kd_as);
dsysd = c2d(sysd,Pid.Ts,'t');
[Pid.Kd_bz,Pid.Kd_az] = tfdata(dsysd,'v');
disp("PID Diff coefficient: ok")

% Integ
Ki_bs = [0 Pid.Ki];
Ki_as = [1 0];
sysi = tf(Ki_bs,Ki_as);
dsysi = c2d(sysi,Pid.Ts,'t');
[Pid.Ki_bz,Pid.Ki_az] = tfdata(dsysi,'v');
disp("PID Integ coefficient: ok")

% FF
ff_bs =  [1/Omega0^2 1/(Omega0*Qm) 1];
ff_as =  K*[(1/(Fc*2*pi))^2 2/(Fc*2*pi) 1];
sysf = tf(ff_bs,ff_as);
dsysf = c2d(sysf,Pid.Ts,'t');
[Pid.ff_bz,Pid.ff_az] = tfdata(dsysf,'v');
disp("PID FF coefficient: ok")

%% Plant
dsysp = c2d(P,Pid.Ts,'t');
[Plant.bz, Plant.az] = tfdata(dsysp, 'v');
disp("Plant coefficient: ok")

%% Hall
% IIR
alpha = AlphaDesign(400,Pid.fs);
Hall.iir_bz = [1-alpha, 0];
Hall.iir_az = [1, -alpha];
disp("Hall IIR coefficient: ok")