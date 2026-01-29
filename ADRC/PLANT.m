% created by lzq
function [plantout,hallout] = PLANT(plantin)

global Flag Plant Hall;
persistent ziplant;
persistent ziiir;
if isempty(ziplant)
    ziplant = zeros(1,length(Plant.az)-1);
    ziiir = zeros(1,length(Hall.iir_az)-1);
end

% Plant
[plantout,ziplant] = filter(Plant.bz, Plant.az, plantin, ziplant);


hallout = plantout;
if Flag.iir
    [hallout,ziiir] = filter(Hall.iir_bz,Hall.iir_az,hallout,ziiir);
end