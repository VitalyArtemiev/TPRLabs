#var 242
#f(x) = 11/5*x1^2 + 13/5 * x3^2 + 2*x3 - 13/10*x1 - 2
clear; close all; clc;
%STEP 1
n = 2
h = 2 %step
d = 2 %step reduction coef
m = 0.25 %accel. coef
eps = 0.001

x0 = zeros(1,n)

x0n = zeros(2, n);
x0n(1,:) = x0

%LOGGING

iteration = 0;
RH = zeros(30,n);
FH = zeros(30,1);
CH = zeros(1,n);
CH(1, :) = x0n(1,:);

while h > eps
  
  %STEP 2, 3
  
  iteration++
  
  x0n(2,:) = x0n(1,:);
  
  fres = funcToOptimize(x0n);
  
  do %fres(2) >= fres(1)
  disp("while fres")
    %STEP 4
    
    dir = 1; %i
    
    while dir <= n
    
      %STEP 5
      
      stepVector = zeros(1,n);
      stepVector(dir) = h
      x0n(2,:) += stepVector;   
      CH = [CH ; x0n(2,:)];
      
      fres = funcToOptimize(x0n);
      
      %STEP 6
      
      if fres(2) >= fres(1);

        x0n(2,:) -= 2 * stepVector;
        CH = [CH ; x0n(2,:)];
        fres = funcToOptimize(x0n);
        
        %STEP 7
        
        if fres(2) >= fres(1)
          x0n(2,:) += stepVector;    
          %TH(dir*2,:,iteration) = x0n(2,:); ????????
          CH = [CH ; x0n(2,:)];
          fres = funcToOptimize(x0n);
        endif
        
      endif
           
      %STEP 8
      
      dir += 1;
    
    endwhile
    
    %STEP 9
    
    h = h/d;
      
  until x0n(1,:) != x0n(2,:)
  
  %STEP 10
  
    xp = x0n(1,:) + m * (x0n(2,:) - x0n(1,:));
    fp = funcToOptimize(xp);
    
    %STEP 11
    
    if fp < fres(2)
      x0n(1,:) = xp;
    else
      x0n(1,:) = x0n(2,:);  
    endif  
  
  
  %LOGGING
  
  RH(iteration, :) = x0n(1,:);
  FH(iteration) = funcToOptimize(x0n(1,:)); 

  x0n;

  %pause
  
endwhile

%STEP 12

Result = x0n(2,:);

fres = funcToOptimize(Result);
disp("Result: ");
disp(Result);
disp(fres)
disp("Took iterations: ");
disp(iteration);

%Visualization

sd = 50;

CH;

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
  axis equal;
  contour(theta0_vals, theta1_vals, J_vals, linspace(-3, 6, 30))
  axis equal;
  xlabel('\theta_0'); ylabel('\theta_1');
  hold on;
  
  plot(Result(1), Result(2), 'bx', 'MarkerSize', 10, 'LineWidth', 3);
  
  RH;
  
  RH(iteration+1:end,:) = [];
  
  plot(RH(:, 1), RH(:, 2), 'x-b', 'MarkerSize', 5, 'LineWidth', 1);
  hold on;
  
  plot(CH(:, 1), CH(:, 2), 'o-r', 'MarkerSize', 5, 'LineWidth', 1);
  hold on;

  figure;
  FH = FH(1:iteration);
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

