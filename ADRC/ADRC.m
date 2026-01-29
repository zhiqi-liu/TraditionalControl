% created by liuzhiqi
function AdrcOut = ADRC(target, hall)

global Adrc Flag;

persistent vall_1;
persistent zall_1;
persistent u;
if isempty(u)
    vall_1 = zeros(1,2);
    zall_1 = zeros(1,3);
    u = 0;
end

%% ADRC
% TD
v1 = vall_1(1) + Adrc.Ts*vall_1(2);
v2 = vall_1(2) + Adrc.Ts*fhan(vall_1(1)-target, vall_1(2), Adrc.r, Adrc.h0);
% ESO
ze = zall_1(1) - hall;
z1 = zall_1(1) + Adrc.Ts*(zall_1(2) - Adrc.beta1*ze);
z2 = zall_1(2) + Adrc.Ts*(zall_1(3) - Adrc.beta2*ze + Adrc.b0*u);
z3 = zall_1(3) - Adrc.Ts*Adrc.beta3*ze;
% NLSEF
e1 = v1 - z1;
e2 = v2 - z2;
u = (Adrc.l1*e1+Adrc.l2*e2-z3)/Adrc.b0;


%% SAT
AdrcOut = u;
if(Flag.sat == 1)
    if abs(AdrcOut) > Adrc.threshold
        AdrcOut = sign(AdrcOut)*Adrc.threshold;
    end
end

vall_1(1) = v1;
vall_1(2) = v2;
zall_1(1) = z1;
zall_1(2) = z2;
zall_1(3) = z3;