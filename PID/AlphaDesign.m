% created by lzq
function alpha = AlphaDesign(fc,fs)

syms x
eq = x^2 + (2*cos(2*pi*fc/fs)-4)*x + 1 == 0;
sol = double(solve(eq,x,"Real",true));
alpha = sol(sol>0 & sol<1);

% alpha = exp(-2*pi*fc/fs); % it's necessary for 2*pi*fc/fs to approach 0

% fvtool([1-alpha,0],[1,-alpha])
