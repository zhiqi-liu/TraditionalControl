% created by lzq
clc; clear all; close all

global Adrc AdrcOut PlantOut HallOut

disp("------------ Param Init ------------")
Init();

idx = 0; 
disp("------------- PID Start ------------")
for Adrci = 1:length(Adrc.target)
    idx = idx+1;
    AdrcOut(idx) = ADRC(Adrc.target(Adrci), HallOut(idx));
    [PlantOut(idx),HallOut(idx+1)] = PLANT(AdrcOut(idx));

    if mod(idx,floor(length(Adrc.target)/10)) == 0
        disp(" - "+num2str(round(idx/length(Adrc.target)*100))+"%")
    end
end

disp("-------- Show Result --------")
Show