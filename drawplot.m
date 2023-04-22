function drawplot(xyData,clust,realClust)
%subplot(2,2,1)
gscatter(xyData(:,1),xyData(:,2),realClust)
grid minor
title('Data with realClust')
xlabel('X1')
ylabel('X2')
%axis equal
hold on
figure

gscatter(xyData(:,1),xyData(:,2),clust)
grid minor
title('Data after OriginalQC')
xlabel('X1')
ylabel('X2')
% axis equal

%figure
%h = histogram2(xyData(:,1), xyData(:,2),'FaceColor','flat');
%colorbar
% h = figure;
%  surf(xyData(:,1),xyData(:,2),clust(:,:,3))
% alpha(0.3)
%  ylabel('log_{10}(E threshold)')
% xlabel('%knn')
% zlabel('#K')
% title('# Clusters ')

end