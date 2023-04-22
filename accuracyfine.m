function [ACC,Rcall,FPR,Precision,F1_score,JaccardIndicator, Minkowski]= accuracyfine (realClust,clust)
Z = realClust;
clusre=max(Z);
clusgen=max(clust);
cam=[clusre clusgen];
for i=1:clusre
    for j=1:clusgen
        ma(i,j)= length(intersect(find(Z==i),find(clust==j)));
        
    end
end
CountOfCompa = sum(ma(:));
compa= min(cam);
compar=[];
%compar=[(1:clusre)',(1:clusgen)']
mat=ma;
for n=1:compa
    [num] = max(mat(:));
    if num==0
        com1 =(1:clusre)';%original clusre
        com2=(1:clusgen)';
        l1=compar(:,1);
        l2=compar(:,2);
        [ucmr,~,~]=union(l1,com1,'stable');
        [ucmg,~,~]=union(l2,com2,'stable') ;
        ucm=zeros(length(ucmr),1);
        for i=1:length(ucmg)
            ucm(i)=ucmg(i);
        end
        %compar=[ucmr ucmg(1:compa)]
        compar=[ucmr(1:compa) ucmg(1:compa)];
        break;
    end
    [x,y]= ind2sub(size(mat),find(mat==num));
    compar=[compar;[x y]];
    %compar([x y],2) = compar([y x],2)
    mat(x,:) = zeros(1,length(clusgen)); %reduce the size of the matrix
    mat(:,y) = zeros(length(clusre),1);
end

for i=1:compa
    for j=1:compa
        mna(i,j)= length(intersect(find(Z==compar(i,1)),find(clust==(compar(j,2)))));
    end
end
confm = mna;



if clusgen<clusre
    newconfm = zeros(clusre,clusre);
    CountOfCofm = sum(confm(:));
    Remainpoint = CountOfCompa - CountOfCofm;
    newconfm(1,clusre)=Remainpoint;
    Sconfm = size(confm,1);
    newconfm([1:Sconfm], [1:Sconfm], 1) = confm;
    mna = newconfm;
    [row,~]=size(mna);
    n_class=row;
    %    switch n_class
    %       case 2
    %          TP=mna(1,1);
    %         FN=mna(1,2);
    %        FP=mna(2,1);
    %       TN=mna(2,2);
    
    %  otherwise
    TP=zeros(1,n_class);
    FN=zeros(1,n_class);
    FP=zeros(1,n_class);
    TN=zeros(1,n_class);
    for i=1:n_class
        TP(i)=mna(i,i);
        FN(i)=sum(mna(i,:))-mna(i,i);
        FP(i)=sum(mna(:,i))-mna(i,i);
        TN(i)=sum(mna(:))-TP(i)-FP(i)-FN(i);
    end
    
    % end
    
    P=TP+FN;
    N=FP+TN;
    
    Sensitivity=TP./P;
    Specificity=TN./N;
    Precision=TP./(TP+FP);
    ACC = (TP+TN)./(TP+FP+FN+TN);
    ACC(isnan(ACC))= [];
    ACC = mean(ACC);
    
    FPR=1-Specificity;
    FPR(isnan(FPR))=[];
    FPR= mean(FPR);
    beta=1;
    F1_score=( (1+(beta^2))*(Sensitivity.*Precision) ) ./ ( (beta^2)*(Precision+Sensitivity) );
    F1_score(isnan(F1_score))=[];
    
    Sensitivity(isnan(Sensitivity))=[];
    Sensitivity=mean(Sensitivity);
    Rcall = Sensitivity;
    %Specificity=mean(Specificity);
    Precision(isnan(Precision))=[];
    Precision=mean(Precision);
    F1_score=mean(F1_score);
    
    [jm] =myClustMeasure(clust,realClust);
    JaccardIndicator = jm;
    Minkowski = sqrt((FP+FN)/(TP+FN));
end %end If clusgen<clusre


if (clusgen > clusre)
    CountOfCofm = sum(confm(:));
    Remainpoint = CountOfCompa - CountOfCofm;
    if  (clusre ==2)
        mna(clusre,1)= mna(clusre,1)+Remainpoint;
        mna(1,clusre)= mna(1,clusre)+Remainpoint;
    end
    mna(1,clusre)= mna(1,clusre)+Remainpoint;
    
    [row,~]=size(mna);
    n_class=row;
    switch n_class
        case 2
            TP=mna(1,1);
            FN=mna(1,2);
            FP=mna(2,1);
            TN=mna(2,2);
            
        otherwise
            TP=zeros(1,n_class);
            FN=zeros(1,n_class);
            FP=zeros(1,n_class);
            TN=zeros(1,n_class);
            for i=1:n_class
                TP(i)=mna(i,i);
                FN(i)=sum(mna(i,:))-mna(i,i);
                FP(i)=sum(mna(:,i))-mna(i,i);
                TN(i)=sum(mna(:))-TP(i)-FP(i)-FN(i);
            end
            
    end
    
    P=TP+FN;
    N=FP+TN;
    
    
    
    Sensitivity=TP./P;
    Specificity=TN./N;
    Precision=TP./(TP+FP);
    ACC = (TP+TN)./(TP+FP+FN+TN);
    ACC(isnan(ACC))= [];
    ACC = mean(ACC);
    
    FPR=1-Specificity;
    FPR(isnan(FPR))=[];
    FPR= mean(FPR);
    beta=1;
    F1_score=( (1+(beta^2))*(Sensitivity.*Precision) ) ./ ( (beta^2)*(Precision+Sensitivity) );
    F1_score(isnan(F1_score))=[];
    
    Sensitivity(isnan(Sensitivity))=[];
    Sensitivity=mean(Sensitivity);
    Rcall = Sensitivity;
    %Specificity=mean(Specificity);
    Precision(isnan(Precision))=[];
    Precision=mean(Precision);
    F1_score=mean(F1_score);
    
    [jm] =myClustMeasure(clust,realClust);
    JaccardIndicator = jm;
    Minkowski = sqrt((FP+FN)/(TP+FN));
end

if (clusgen == clusre)
    [row,~]=size(mna);
    n_class=row;
    switch n_class
        case 2
            TP=mna(1,1);
            FN=mna(1,2);
            FP=mna(2,1);
            TN=mna(2,2);
            
        otherwise
            TP=zeros(1,n_class);
            FN=zeros(1,n_class);
            FP=zeros(1,n_class);
            TN=zeros(1,n_class);
            for i=1:n_class
                TP(i)=mna(i,i);
                FN(i)=sum(mna(i,:))-mna(i,i);
                FP(i)=sum(mna(:,i))-mna(i,i);
                TN(i)=sum(mna(:))-TP(i)-FP(i)-FN(i);
            end
            
    end
    
    P=TP+FN;
    N=FP+TN;
    
    
    Sensitivity=TP./P;
    Specificity=TN./N;
    Precision=TP./(TP+FP);
    ACC = (TP+TN)./(TP+FP+FN+TN);
    ACC(isnan(ACC))= [];
    ACC = mean(ACC);
    
    FPR=1-Specificity;
    FPR(isnan(FPR))=[];
    FPR= mean(FPR);
    beta=1;
    F1_score=( (1+(beta^2))*(Sensitivity.*Precision) ) ./ ( (beta^2)*(Precision+Sensitivity) );
    F1_score(isnan(F1_score))=[];
    
    Sensitivity(isnan(Sensitivity))=[];
    Sensitivity=mean(Sensitivity);
    Rcall = Sensitivity;
    %Specificity=mean(Specificity);
    Precision(isnan(Precision))=[];
    Precision=mean(Precision);
    F1_score=mean(F1_score);
    temp1 = (TP)/(TP+FP+FN);
    %JaccardIndicator = max([temp1, 1-temp1]);
    JaccardIndicator = mean(temp1);
    Minkowski = sqrt((FP+FN)/(TP+FN));
   
    
end

end