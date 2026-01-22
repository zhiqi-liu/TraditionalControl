% created by lzq
function Show(save)
if nargin == 0
    save = 0;
end

global  Pid PlantOut PidOut HallOut

per = 0.05;
err = Pid.target-PlantOut;
gyroAmp = Pid.gyroAmp;
lamda = per*gyroAmp;

%% Figure
figure(1)
subplot(2,1,1); hold on; grid on;
plot(Pid.T,Pid.target,".-","LineWidth",1)
plot(Pid.T,PlantOut,".-","LineWidth",1)
plot(Pid.T,err,".-","Linewidth",1)
plot([0 Pid.T(end)],[lamda lamda],"k--","Linewidth",1)
plot([0 Pid.T(end)],[-lamda -lamda],"k--","Linewidth",1)
legend("Target","PlantOut","Err",num2str(100*per)+"% Amp","Location","best")

subplot(2,1,2); hold on; grid on;
plot(Pid.T,PidOut,".-","Linewidth",1);
legend("PidOut","Location","best")

if save==1
    saveimg(1,"result")
end