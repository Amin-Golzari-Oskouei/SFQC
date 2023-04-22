function [pairsMatrix]= establishPairsMatrix(array)
len = length(array);
pairsMatrix = sparse(len,len);
for ind = 1:max(array)
    [indices]= find(array==ind);
    lenInd =   length(indices);
    %     if mod(ind,10) ==0
    %         disp('.');
    %     end
    for jnd = 1:lenInd-1
        pairsMatrix(indices(jnd),indices(jnd+1:lenInd))=1;
    end
end