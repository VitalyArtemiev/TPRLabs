function [Max_Car_Score ] = ahp_simple()
%% AHP analytical hierarchy process, simple example
%
%  To run, just load script into editor and hit the run key!
%
% This simple by example function (with default values) gives the basic 
% elements of the Analytical Hierarchial Process (AHP) for decision making 
% to include matrix formulations, pairwise analysis, calculating 
% eigenvectors, and determining the final 'best' decision based on criteria. 

%% Example problem:
% Situation: I wish to purchase a car (civic, focus, corolla, BMW318)
% and select the best car based on criteria (style, reliability,
% and fuel economy). To make the best car purchase decision, I will use
% AHP with the following:
%         alternatives:  civic, focus, corolla, BMW318
%         criteria:      style, reliability, fuel economy
%%---------------------------------------------

%% Problem formulation:
clear all; close all; clc;
%% Step 1: Criteria Matrix and Criteria Eigenvector
% 
% Since this part is subjective, I give reliability, style and fuel economy
% importance. Thus I will rank these as follows (subjective qualitative):
% Reliability (R) is 2 time as important as style (S)
% Style (S) is 3 times as important as fuel economy (FE)
% Reliability (R) is 4 times as important as fuel economy (FE)
% Using Scale:
%   1-equal, 3-moderate, 5-strong, 7-very strong, 9-extreme
disp('Criteria Pairwise Comparison Matrix PCM');
% pairwise comparision of each criteria to each criteria
% denoted as the matrix PCM
%      (S)   (R)  (FE)    
PCM= [ 1/1   1/2   3/1; ...   % (S-style)
       2/1   1/1   4/1; ...   % (R-reliability)
       1/3   1/4   1/1 ]      % (FE-fuel economy)
   %ePCM=eig(PCM)
   
   ePCM=calc_eig(PCM)
%%
   

%% Step 2: Alternatives Matrix and Alternatives Eigenvectors 
% Alternative Ranking (Car to Car on Style, Reliability, and Fuel)
% Compaire each car to each car denoted as the alternatives 
% (civic, focus, corolla, BMW318)
% In the terms of style, reliability, and fuel economy using
% pairwise comparison for qualitative and normalization for quantitative
% 
%   example of the style comparison
%
%                    civic        focus         corolla         BMW318
% civic               1/1         1/4            4/1            1/6
% focus               4/1         1/1            4/1            1/4
% corolla             1/4         1/4            1/1            1/5
% BMW318              6/1         4/1            5/1            1/1

%% Compare Style:
disp('Style Comparison: Alternatives Qualitative Pairwise');
ACM_St = [ 1/1 1/4 4/1 1/6; ...
           4/1 1/1 4/1 1/4; ...
           1/4 1/4 1/1 1/5; ...
           6/1 4/1 5/1 1/1]
eACM_St = calc_eig(ACM_St) % calculate eigenvector on qualitative matrix
%%

%% Compare Reliability:
disp('Reliability Comparison: Alternatives Qualitative Pairwise');
ACM_Re = [ 1/1 2/1 5/1 1/1; ...
           1/2 1/1 3/1 2/1; ...
           1/5 1/3 1/1 1/4; ...
           1/1 1/2 4/1 1/1]
eACM_Re = calc_eig(ACM_Re) % calculate eigenvector on qualitative matrix
%% 

%% Compare Fuel Economy:
disp('Fuel Economy Comparision: Alternatives Quantitative (MPG)');
% given MPG data for each vehicle, create a fuel economy matrix
%  MPG matrix    
 cv = 34;   % civic
 sa = 27;   % focus
 es = 24;   % corolla
 cl = 28;   % BMW318
 
 ACM_Fe = [ cv; ...
            sa; ...
            es; ...
            cl]
      
 eACM_Fe  = calc_norm(ACM_Fe)  % normalize quantitative type data      
 %%
 
 disp('Hit space key to continue to winner of benefits')
        pause()   
        clc;

    
 %% Step 3:  Calculate Final Answer and Determine winner
 % construc a matrix of eigenvectors calculated above for each criteria
 % eigenvectors: Style   Reliability   Fuel-econ
 eM         =   [eACM_St   eACM_Re      eACM_Fe];
 
 % multiply eigenvector matrix by eigenvector of criteria to obtain
 % scores for each car based on criteria and car-to-car comparisons
 disp('Scores for: civic, focus, corolla, BMW318')
 Car_Scores = eM * ePCM
 
 % Best Car as a factor of benefits (criteria)
 disp('Winning Car based on benefits, BMW318')
 Max_Car_benefits = max(Car_Scores)
 

 
 disp('Hit space key to continue to calculate in costs')
        pause()   
        clc; 
 
 %% Step 4: Costs versus benefits 
 % now we consider costs
  benefits = Car_Scores;
%  Costs Matrix   
 cv = 16;   % civic
 fo = 13;   % focus
 co = 15;   % corolla
 bm = 40;   % BMW318
 
 costs = [ cv; ...
         fo;   ...
         co; ...
         bm]
 
 ncosts = calc_norm(costs); %normalize costs 
 disp('Benefits to cost ratio');
 benefits_cost_ratio=benefits./ncosts

disp('If costs are considered, then winner is focus')


%% sub-function on calculating eigenvectors
    function [eigvect ] = calc_eig(M) 
        %Convert pairwise matrix (PCM) into ranking of criteria (RCM) using
        %eignevectors (reference: the analytical hierarchy process, 1990,
        % Thomas L. Saaty
        
        % Note: A simple/fast way to solve for the eigenvectors are:
        % 1. Raise pairwise matrix to powers that are successively squared
        % 2. Sum the rows and normalize summed rows.
        % 3. Stop when the difference between the sums in two consecutive
        %    iterations is smaller than tolerance.
        c=1;
        [m n]=size(M);
        nrM(m,:)=10000; tolmet=0; tolerance=.035;
        while tolmet<1 
            c=c+1;                                        % counter
            M=M^2;                                        % pairwise matrix^2
            sr1M = sum(M,2);                              % sum rows
            sr2M = sum(sr1M);                             % sum of sum rows
            nrM(:,c) = sr1M./sr2M;                        % normalize
            tol(c)=sum(abs(nrM(:,c) - nrM(:,c-1)));       % calc. tolerance
             if tol < tolerance                    % tolerance met?
                tolmet=1;                          % tolerance met, stop iterations
             elseif sum(sum(M))>=10e30 
                 tolmet=1;                         % tolerance unlikely, stop iterations
             end
        end
        disp('Eigenvector of matrix');
        eigvect = nrM(:,end); % eigenvector of PCM
    end

%% sub-function to normalize a vector (0-1)
    function [normvect ] = calc_norm(M) 
        sM = sum(M);
        normvect = M./sM;
        disp('Normalized matrix');
    end

end



   
  