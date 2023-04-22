function [accurcy,fm, Runtime, Sensitivity, Precision] = main(FileName, PathName)
%This demo shows how to call the weighted fuzzy C-means algorithm described in the paper:
%A.Golzari oskouei, N.Abdolmaleki and K.Shirini, "SFQC: Superpixel-based Fast Quantum Clustering
%for Brain MRI Segmentation" 2023.
%For the demonstration, the 13 MRI images of the above paper is used.
%Courtesy of A.Golzari Oskouei

%% Upload original image and its GT 
Img=imread(strcat(PathName,'\original','\',FileName));
GT = imread(strcat(PathName,'\GT','\',FileName));

%% skull border remove
binarymak = skull_remove(Img);
Img = Img(3:end-3, 4:end-4, :);
GT = GT (3:end-3, 4:end-4);
Img = bsxfun(@times, Img, cast(binarymak, 'like', Img));

%% generate superpixels
%SFQC only needs a minimal structuring element for MMGR, we usually set SE=2 or SE=3 for
%MMGR.
SE=3;
L1=w_MMGR_WT(Img,SE);
L2=imdilate(L1,strel('square',2));
[~,~,~,centerLab]=Label_image(Img,L2);

%% Clustering phase: QC

q=2; % q=1/(2*sigma^2) => (smaller q (bigger kernel bandwidth) -> less clusters)

% data normalization (gives all vector unit length)
lambda1 = mean(sqrt(sum(centerLab.^2,2)));
xyData = centerLab./lambda1;

tic
D=graddesc(xyData,q,80);  %performs gradient descent on xyData with 80 steps
Label=FineCluster(D,0.1); % "collapse" the points to their final places and
Runtime = toc;

%% Lables (imagesize by imagesize)
Lr2=zeros(size(L2,1),size(L2,2));
for i=1:max(L2(:))
    Lr2=Lr2+(L2==i)*Label(i);
end

%% Results
a = double(reshape(GT, [1, size(GT,1) * size(GT,2)]));
b = double(reshape(Lr2, [1, size(GT,1) * size(GT,2)]));
EVAL = Evaluate(a',b');
accurcy=EVAL(1);
fm=EVAL(2);
Sensitivity = EVAL(4);
Precision = EVAL(5);
Lseg=Label_image(Img,Lr2);

%%figure
figure,imshow(Lseg);
imwrite(Lseg, strcat('Results','\',FileName))
end