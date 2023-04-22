function [V,P,E,dV] = qc (ri,q,r)
%tic;
% function qc
% purpose: performing quantum clustering in n dimensions
% input:
%       ri - a vector of points in n dimensions
%       q - the factor q which determines the clustering width
%       r - the vector of points to calculate the potential for. equals ri if not specified
% output:
%       V - the potential
%       P - the wave function
%       E - the energy
%       dV - the gradient of V
% example: [V,P,E,dV] = qc ([1,1;1,3;3,3],5,[0.5,1,1.5]);
% see also: qc2d

%close all;
if nargin<3
    r=ri;
end

%default q
if nargin<2
    q=0.5;
end
%default xi
[pointsNum,dims] = size(ri);
calculatedNum=size(r,1);
% prepare the potential
V=zeros(calculatedNum,1);
dP2=zeros(calculatedNum,1);
% prepare P
P=zeros(calculatedNum,1);
singlePoint = ones(pointsNum,1);
singleLaplace = zeros(pointsNum,1);
singledV1=zeros(pointsNum,dims);
singledV2=zeros(pointsNum,dims);
% prevent division by zero
% calculate V
%run over all the points and calculate for each the P and dP2
for point = 1:calculatedNum
    singlePoint = ones(pointsNum,1);
    singleLaplace = singleLaplace.*0;
    
    D2=sum(((repmat(r(point,:),calculatedNum,1)-ri).^2)');
    singlePoint=exp(-q*D2)';
    %EXPij=(repmat(singlePoint',calculatedNum,1).*(repmat(singlePoint,1,calculatedNum)));
    %      singleLaplace = sum((D2').*singlePoint);
    for dim=1:dims
        singleLaplace = singleLaplace + (r(point,dim)-ri(:,dim)).^2.*singlePoint;
    end
    for dim=1:dims
        singledV1(:,dim) = (r(point,dim)-ri(:,dim)).*singleLaplace;
    end
    for dim=1:dims
        singledV2(:,dim) = (r(point,dim)-ri(:,dim)).*singlePoint;
    end
    P(point) = sum(singlePoint);
    dP2(point) = sum(singleLaplace);
    dV1(point,:)=sum(singledV1,1);
    dV2(point,:)=sum(singledV2,1);
end
% dill with zero
%v1(find(v1==0)) = min(v1(find(v1)));
%v2x(find(v2x==0)) = min(v2x(find(v2x>0)));
%v2y(find(v2y==0)) = min(v2y(find(v2y>0)));
P(find(P==0)) = min(P(find(P)));

V=-dims/2+q*dP2./P;
E=-min(V);
V=V+E;
for dim=1:dims
    dV(:,dim)=-q*dV1(:,dim)+(V-E+(dims+2)/2).*dV2(:,dim);
end
dV(find(P==0),:)=0;
%toc;