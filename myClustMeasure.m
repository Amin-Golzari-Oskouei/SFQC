function [jm,MS, AccuracyNew] =myClustMeasure(clust, realClust)
% emptyRealMapping = a flag : if == 1 then ignore
%function [jm,efficiency, purity,PE] =myClustMeasure2(calculatedClust, realClust,emptyRealMapping)
% Initialization
efficiency = 0;
purity = 0;
MS = 0;
%purity = 0;
%PE = 0;
jm = 0;
N =  size(realClust,1);
NN = (N*(N-1))/2;
%if nargin <3 || emptyRealMapping ==0
%   pNum=length(calculatedClust);
% both vectors should be in length*1 format
%   [x,y] = size(calculatedClust);
%  if y>x
%      calculatedClust = calculatedClust';
%  end
%  [x,y] = size(realClust);
%  if y >x
%      realClust=realClust';
% end
% if 2 ~= length (find(size(calculatedClust) == size (realClust)))
%    errordlg('Dimensions of Calculated and real mapping are mismatch','Wrong dimensions','modal');
%   return
%end
% S=the clutering result in pairs - S(i,j)=1 iff data point i and j are asigned to the same cluster
clustPairs =  establishPairsMatrix (clust);
realClustPairs = establishPairsMatrix (realClust);
n11Mat= clustPairs&realClustPairs;%pairs that appear in both methods
n11=length(find(n11Mat));% number of pairs that appear in both methods
n10 = length(find(realClustPairs)) - n11; % number of pairs that appear in 'real' classification, but not in the algorithm
n01 =length(find(clustPairs)) - n11;% number of pairs that appear in algorithm, but not in the 'real' classification
n00 = NN - (n11+ n10+ n01);
if (n10+n01+n11)>0
    jm=n11/(n10+n01+n11);
end
if (n10+n11)>0
    %efficiency=sum(sum(efficiencyMat))/(numOfRealClust*numOfCalcClust);
    efficiency = n11/(n10+n11);
end
if (n01+n11)>0
    %purity=sum(sum(purityMat))/(numOfRealClust*numOfCalcClust);
    purity = n11/(n01+n11);
    % Accuracy = (n11)/(n11 + n10 + N);
    %AccuracyNew = ((n11+n00)/(N))*(1/100);
    AccuracyNew = ((n11+n00)/(n10+n01+n11+n00));
end

MS = sqrt((n01+n10)/(n11+n10));
%PE=sqrt(efficiency^2+purity^2);%norm
end




