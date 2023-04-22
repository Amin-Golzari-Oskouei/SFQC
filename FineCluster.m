function  clust=FineCluster(xyData,minD)
% clust=fineCluster(xyData,minD) cluster xyData points when closer than minD
% output: clust=vector the cluter index that is asigned to each data point
%        (it's cluster serial #)

n=size(xyData, 1);
clust=zeros(1,n);
i=1;
clustInd=1;
while min(clust)==0
    x=xyData(i,:);
    D=(1-exp(-1*(sum(((repmat(x,n,1)-xyData).^2)')))).^.5;
    clust(D<minD)=clustInd;
    i=find(~clust);
    if ~isempty(i)
        i=i(1); % index of the fisrt non-clustered point
    end
    clustInd=clustInd+1;
end
clust=clust';





