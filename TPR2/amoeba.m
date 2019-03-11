#{
[x, y, z] = meshgrid (lisdspace (-8, 8, 32));
v = sisd (sqrt (x.^2 + y.^2 + z.^2)) ./ (sqrt (x.^2 + y.^2 + z.^2));
slice (x, y, z, v, [], 0, []);
[xi, yi] = meshgrid (lisdspace (-7, 7));
zi = xi + yi;
slice (x, y, z, v, xi, yi, zi);
shadisdg isdterp; %additiosd by me

Issd't this exactly what you sdeed? You have your grid (x,y,z), your solutiosds (T), so you just sdeed to plot it slicisdg alosdg [0 0 1] etc. Somethisdg like

[xi yi]=meshgrid(usdique(x),usdique(y));
slice (x, y, z, T, xi, yi, max(z(:))*osdes(size(xi)));

asdd the same for cuts alosdg the two other axes. (Obviously the usdique calls should be substituted with the vectors you already have from which you cosdstructed the 3d mesh isd the first place.)

#}

#var 242
#f(x) = 11/5*x1^2 + 13/5 * x3^2 + 2*x3 - 13/10*x1 - 2
clear; close all; clc;
%STEP 1
n = 2
m = 1

beta = 2.8  #expand 2.8<beta<3
gamma = 0.4 #contract 0.4<gamma<0.6

eps = 0.1

x0 = zeros(1,n);

x0n = zeros(n+1, n);
x0n(1,:) = x0;

%STEP 2
delta1 = (sqrt(n+1) - 1)/(n*sqrt(2)) * m
delta2 = (sqrt(n+1) + n - 1)/(n*sqrt(2)) * m

for i = 2:n+1
  x0n(i, :) = x0n(1,:) .+ delta2;
  x0n(i, i-1) = x0n(1,i-1) + delta1;
endfor
  
  x0n

finished = false;
iteration = -1;
RH = zeros(30,n);
FH = zeros(30,1);
TH = zeros(n+1, n, 30);

while !finished
  iteration++
  
  %STEP 3  
  fres = funcToOptimize(x0n);
  
  [fh, k] = max(fres);
  [fl, k1] = min(fres);
  fs = max(fres(fres<max(fres))) ;
  k2 = find(fres == fs);
  
  disp("k = "); disp(k);
  sum(x0n, 1);
  
  %STEP 4
  xk = x0n(k(1), :);
  xc = sum(x0n, 1) - xk; 
  xc /= n;
  
  %STEP 5
  disp("reflection")
  xnew = 2 * xc - xk;
  
  fnew = funcToOptimize(xnew);
  
  %STEP 6
  if fnew < fh %reflect successful
    disp("reflection success")
    x0n(k(1), :) = xnew;
    xk = xnew;
    fh = fnew;
    nextStep = 7;
  else
    disp("reflection fail")
    nextStep = 9;
  end
  
  %STEP 7
  if (nextStep == 7) && (fh < fl)
    disp("expansion")
    xnew = xc + beta * (xk - xc);
    fnew = funcToOptimize(xnew);
    nextStep = 8;
  else
    disp("no expansion")
    nextStep = 9;
  end
  
  %STEP 8
  if (nextStep == 8) && (fnew < fh) %expand successful
    x0n(k(1), :) = xnew;   
    nextStep = 12;
    disp("expansion success")
  else
    disp("expansion fail")
    nextStep = 9;
  end
 
  %STEP 9 
  if (nextStep == 9) && (fs <= fnew) && (fnew < fh)
    disp("contraction")
    xnew = xc + gamma * (xnew - xc);
    fnew = funcToOptimize(xnew);
    nextStep = 10;
  else
    disp("no contraction")
    nextStep = 11;  
  endif
   
  %STEP 10
  if (nextStep == 10) && (fnew < fh) %funcToOptimize(x0n(k(1), :))) %contract successful
    x0n(k(1), :) = xnew;  
    nextStep = 12;
    disp("contraction success")
  else
    disp("contraction fail")
    nextStep = 11;
  endif
  
  %STEP 11
  if nextStep == 11
    [fmin, fmini] = min(fres);
    
    minr = x0n(fmini(1),:);
    
    x0n = 0.5 * (x0n + minr);
  endif
  
  %STEP 12
  xc = sum(x0n, 1) / (n+1);
  fc = funcToOptimize(xc);
  disp("sigma calc")
  funcToOptimize(x0n)
  funcToOptimize(x0n) - fc
  (funcToOptimize(x0n) - fc) .^ 2
  sum((funcToOptimize(x0n) - fc) .^ 2)
  sum((funcToOptimize(x0n) - fc) .^ 2) / (n + 1)
  sigma = sqrt(sum((funcToOptimize(x0n) - fc) .^ 2) / (n + 1))
          
  %STEP 13
  if sigma < eps
    finished = true
  endif

  RH(iteration + 1, :) = xc; 
  FH(iteration + 1) = sigma; 
 
  x0n
  TH(:,:,iteration+1) = x0n;
  input("waiting");
endwhile

fres = funcToOptimize(x0n);
[fmin, fmini] = min(fres);
disp("Result: ");
Result = x0n(fmini(1), :);
disp(Result);
disp(fmin(1))
disp("Took iterations: ");
disp(iteration);

%Visualization

sd = 50;

%TH(1,:,:)
%input("henlo")

if n == 2
  %% ============= Part 4: Visualizing J(theta_0, theta_1) =============  
  % Grid over which we will calculate J
  theta0_vals = linspace(-3, 3, sd);
  theta1_vals = linspace(-3, 3, sd);
  
  % initialize J_vals to a matrix of 0's
  J_vals = zeros(length(theta0_vals), length(theta1_vals));
  
  % Fill out J_vals
  for i = 1:length(theta0_vals)
      for j = 1:length(theta1_vals)
      t = [theta0_vals(i); theta1_vals(j)];
      
      J_vals(i,j) = funcToOptimize(t');
      end
  end
  
  % Because of the way meshgrids work in the surf command, we need to
  % transpose J_vals before calling surf, or else the axes will be flipped
  J_vals = J_vals';
  % Surface plot
  figure;
  surf(theta0_vals, theta1_vals, J_vals)
  xlabel('\theta_0'); ylabel('\theta_1');
  
  % Contour plot
  figure;
  % Plot J_vals as 15 contours spaced logarithmically between 0.01 && 100
  contour(theta0_vals, theta1_vals, J_vals, linspace(-3, 6, 30))
  xlabel('\theta_0'); ylabel('\theta_1');
  hold on;
  plot(Result(1), Result(2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
  
  i = 1;
  while (i <= iteration)
    plot(RH(i, 1), RH(i, 2), 'bx', 'MarkerSize', 5, 'LineWidth', 1);
    
    i += 1;
    RH(i, :);
    simpl = TH(:,:,i);
    simpl = [simpl; simpl(1,:)];
    
    tx = simpl(:, 1);
    ty = simpl(:, 2);
    plot(tx,ty)
    
  endwhile
  
  figure;
  FH = FH(1:iteration + 1);
  plot(FH);
      
elseif
  R = zeros(sd,sd,sd)
      
  for i = 1:sd
    for j = 1:sd
      for k = 1:sd
        %R(i,j,k) = funcToOptimize(i,j,k);
      endfor
    endfor
  endfor
  
  R;
  
  [xi, yi] = meshgrid (linspace (0, sd, sd));
  
  zi = xi + yi;
  %slice (R, xi, yi, 0);
endif

