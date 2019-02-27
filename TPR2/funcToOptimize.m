function f = funcToOptimize(x)
  x1 = x(:,1);
  x2 = x(:,2);

  f = 11/5 .* x1 .^ 2 + 13/5 .* x2 .^ 2 + 2 .* x2 - 13/10 .* x1 .- 2;
endfunction