% created by lzq
clc; clear all; close all

global Pid PidOut PlantOut HallOut

disp("------------ Param Init ------------")
Init();

idx = 0; 
disp("------------- PID Start ------------")
for Pidi = 1:length(Pid.target)
    idx = idx+1;
    PidOut(idx) = PID(Pid.target(Pidi), HallOut(idx));
    [PlantOut(idx),HallOut(idx+1)] = PLANT(PidOut(idx));

    if mod(idx,floor(length(Pid.target)/10)) == 0
        disp(" - "+num2str(round(idx/length(Pid.target)*100))+"%")
    end
end

disp("-------- Show Result --------")
Show