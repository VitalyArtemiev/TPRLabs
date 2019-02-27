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
m = 0.25
eps = 0.1

x0 = ones(1,n)

x0n = zeros(n+1, n);
x0n(1,:) = x0

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
RH = zeros(30,n)
FH = zeros(30,1)
TH = zeros(n+1, n, 30)

while !finished
  iteration++
  
  %STEP 3  
  fres = funcToOptimize(x0n);
  
  [fmax, fmaxi] = max(fres);
  disp("k = "); disp(fmaxi);
  sum(x0n, 1);
  
  %STEP 4
  xk = x0n(fmaxi(1), :);
  xc = sum(x0n, 1) - xk; 
  xc /= n;
  
  %STEP 5
  xnew = 2 * xc - xk
  
  fnew = funcToOptimize(xnew);
  
  %STEP 6
  if fnew < fmax
    x0n(fmaxi(1), :) = xnew;
  else   
    %STEP 7
    [fmin, fmini] = min(fres);
    
    minr = x0n(fmini(1),:)
    
    x0n = 0.5 * (x0n + minr)
  endif
  
  %STEP 8
  xc = sum(x0n, 1) / (n+1);
  fc = funcToOptimize(xc)
  RH(iteration + 1, :) = xc; 
  FH(iteration + 1) = fc; 
  
  %STEP 9  
  dif = abs(funcToOptimize(x0n) .- fc)
  if sum(dif >= eps) == 0
    finished = true;
  endif
 
  x0n
  TH(:,:,iteration+1) = x0n;
  %input("waiting");
endwhile

fres = funcToOptimize(x0n);
[fmin, fmini] = min(fres);
disp("Result: ");
Result = x0n(fmini(1), :);
disp(Result);
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
  % Plot J_vals as 15 contours spaced logarithmically between 0.01 and 100
  contour(theta0_vals, theta1_vals, J_vals, logspace(-1, 2, 30))
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

