% created by lzq
function pidout = PID(target, hall)

global Pid Flag;

persistent ziki;
persistent zikd;
persistent ziff;
persistent integ_flag;
if isempty(ziki)
    ziki = zeros(1,length(Pid.Ki_az)-1);
    zikd = zeros(1,length(Pid.Kd_az)-1);
    ziff = zeros(1,length(Pid.ff_az)-1);
    integ_flag = 0;
end

%% ERR
err = target - hall;

%% PID
Kp_out = Pid.Kp*err;
if(integ_flag == 0)
    [Ki_out,ziki] = filter(Pid.Ki_bz,Pid.Ki_az,err,ziki);
else
    [Ki_out,ziki] = filter(Pid.Ki_bz,Pid.Ki_az,0,ziki);
end
[kd_out,zikd] = filter(Pid.Kd_bz,Pid.Kd_az,err,zikd);

%% FF
if(Flag.ff == 1)
    [ff_out,ziff] = filter(Pid.ff_bz,Pid.ff_az,target,ziff);
else
    ff_out = 0;
end

%% SAT
pidout = Kp_out + Ki_out + kd_out + ff_out;

if(Flag.sat == 1)
    if abs(pidout) > Pid.threshold
        pidout = sign(pidout)*Pid.threshold;
    end
end

%% clamp
if(Flag.clamp == 1)
    if pidout >= Pid.threshold && Pid.Ki*err > 0
        integ_flag = 1;
    elseif pidout <= -Pid.threshold && Pid.Ki*err < 0
        integ_flag = 1;
    else
        integ_flag = 0;
    end
end