function f = fhan(x1, x2, r, h)

d = r*h^2;
a0 = h*x2;
y = x1 + a0;
a1 = sqrt(d*(d + 8*abs(y)));
a2 = a0 + sign(y)*(a1 - d)/2;
sy = 0.5*(sign(y + d)-sign(y - d));
a = (a0 + y - a2)*sy + a2;
sa = 0.5*(sign(a + d) - sign(a - d));
f = -r*((a/d - sign(a))*sa + sign(a));