Criteria = ["Area"; "Rooms"; "Price"; "TimeToMetro"; "Height"] 
Weights = [5; 4; 4; 3; 2]
Scales = [3, 5, 3, 3, 2]
Dirs = [1,1,-1,-1,1]

n = 10
c = 1.7

Area = ceil(rand(n, 1) * Scales(1));

Rooms = ceil(rand(n, 1) * Scales(2));

Price = ceil(rand(n, 1) * Scales(3)); %in K$

TimeToMetro = ceil(rand(n, 1) * Scales(4));

Height = ceil(rand(n,1) * Scales(5));

Matrix = [Area, Rooms, Price, TimeToMetro, Height]

P = zeros(n,n);
N = zeros(n,n);

for i = 1:n-1
  for j = i:n
    temp = Matrix(i, :) - Matrix(j,:);
    temp = temp .* Dirs;
    #Weights(temp>0)
    P(i,j) = sum(Weights(temp>0));
    N(i,j) = sum(Weights(temp<0));
    
    P(j,i) = sum(Weights(temp<0));
    N(j,i) = sum(Weights(temp>0));
    
  endfor
  P;
  N;
endfor

P
N

D = P./N

  
discard = find(D < c);
D(discard) = NaN;
D
    
  
    