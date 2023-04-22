% This script demonstare the QC algorithm in a truncated SVD space

clear
clc
load dataset1\crab
M = crab(:,1:end-1);
realClust= crab(:,end);
%M = data;
%realClust = label;
%realClust= X(:,end);
% perform SVD - the result are 3 matrixes s.t  genes x S x samples = M
%[genes,S,samples] = svd(M,0);
dims=2;
% load dims most significant vectors to xyData
%X0=genes(:,1:dims); % load dims most significant vectors to xyData
X0 = M;%if you don't use of SVD
% data normalization (gives all vector unit length)

lambda1 = mean(sqrt(sum(X0.^2,2)));
xyData = X0./lambda1;

q=2; % q=1/(2*sigma^2) => (smaller q (bigger kernel bandwidth) -> less clusters)

% QC
tic
D=graddesc(xyData,q,80);  %performs gradient descent on xyData with 20 steps
clust=FineCluster(D,0.1); % "collapse" the points to their final places and
toc                        % return the division of data into clusters


%Evaluation
[ACC,Rcall,FPR,Precision,F1_score,JaccardIndicator, Minkowski]= accuracyfine (realClust,clust);

%plotClust;
drawplot(xyData,clust,realClust);

