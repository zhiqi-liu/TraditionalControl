% created by lzq
function [notch_bz,notch_az,notch] = NotchDesign(Fc,Fs,Span,dBdown)
% notch dBdown dB at Freq Hz, notch width adjusted by Span.
if nargin == 2 % Span 100 and dBdown 40 is ok.
    Span = 100;
    dBdown = 40;
end
omega = Fc*2*pi;
magdown = 10^(dBdown/20);
notch = tf([Span,omega,Span*omega^2],[Span,magdown*omega,Span*omega^2]);
dnotch = c2d(notch,1/Fs,"t");
[notch_bz,notch_az] = tfdata(dnotch,"v");
% figure;bode(notch,".-");grid on