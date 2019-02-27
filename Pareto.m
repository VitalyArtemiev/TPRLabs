n = 10

maxarea = 100
maxrooms = 10
maxprice = 10000
maxtime = 60

minheight = 2
heightvar = 2

Area = ceil(rand(n, 1) * maxarea);
Area = [1 ; Area];

Rooms = ceil(rand(n, 1) * maxrooms);
Rooms = [1; Rooms];

Price = ceil(rand(n, 1) * maxprice); %in K$
Price = [-1; Price];

TimeToMetro = ceil(rand(n, 1) * maxtime);
TimeToMetro = [-1; TimeToMetro];

Height = ceil(rand(n,1) * heightvar)  .+ minheight;
Height = [1; Height];

Matrix = [Area, Rooms, Price, TimeToMetro, Height]

#Matrix = [1, 1; 2,4 ; 3, 4; 3,3; 5,2; 4,3]

m = Matrix(2:n+1, :);

Frontier = m;
list = [];

for i = 1:n-1
  for j = i+1:n
    temp = m(i, :) - m(j,:);
    temp = temp .* Matrix(1, :);
    round(temp);
    temp<0;
    if (sum(temp<0) > 0) && (sum(temp>0) == 0)
      list = [list, i];
      break
    endif
    list;
  endfor
endfor

i = n;

for j = i:n-1
    temp = m(i, :) - m(j,:);
    temp = temp .* Matrix(1, :);
    round(temp);
    temp<0;
    if (sum(temp<0) > 0) && (sum(temp>0) == 0)
      list = [list, i];
      break
    endif
endfor

list;

Frontier(list,:) = []

mins = [20, 2, 2000, 12, 2]
maxs = [90, 9, 9000, 50, 4]

#mins = mins * 0.2;
#mins(2) = round(mins(2));
#maxs = maxs * 0.9;
#maxs(2) = round(maxs(2));
#mins
#maxs

[i,j] = find((Frontier .- mins)<0);
Frontier(i,:) = [];
printf("After excluding by min:\n")
Frontier
fb = Frontier;

[i,j] = find((maxs .- Frontier)<0);
Frontier(i,:) = [];
printf("After excluding by max:\n")
Frontier
Frontier = fb;

printf("Best by area:\n")
disp( sortrows(Frontier,1)(1,:))

printf("Best by room count:\n")
disp( sortrows(Frontier,2)(1,:))

printf("Best by price:\n")
disp( sortrows(Frontier,3)(1,:))

printf("Best by time:\n")
disp( sortrows(Frontier,4)(1,:))

printf("Best by height:\n")
disp( sortrows(Frontier,5)(1,:))




%CritPrior = [-1, -2, -3, -4, -5]

%Matrix(1, :) = Matrix(1, :) .* CritPrior;

%ResultByCritPrior = sortrows(Matrix(2:n+1,:), Matrix(1, :))