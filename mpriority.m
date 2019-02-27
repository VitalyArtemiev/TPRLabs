n = 6;
m = 5;
v = zeros(n, m)
V = zeros(n)

for i = 1:n
  V(i) -= prod(v(i,:)) ^ (1/m)
endfor

sv = sum(V)

W = V ./ sv