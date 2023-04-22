%This demo shows how to call the weighted fuzzy C-means algorithm described in the paper:
%A.Golzari oskouei, N.Abdolmaleki and K.Shirini, "SFQC: Superpixel-based Fast Quantum Clustering
%for Brain MRI Segmentation" 2023.
%For the demonstration, the 13 MRI images of the above paper is used.
%Courtesy of A.Golzari Oskouei

clear ;close all;clc;

path = 'Dataset';
imagefiles = dir([path,'\original','\*.tif']);

nfiles = length(imagefiles);    % Number of files found

% Note that you can repeat the program for several times to obtain the best
Results = zeros(nfiles,6);
for i = 1 : nfiles
    currentfilename = char(imagefiles(i).name);
    currentfoldername = imagefiles(i).folder;
    [accurcy,fm, Runtime, Sensitivity, Precision] = main(currentfilename, path);
    Results(i, 1) = accurcy;
    Results(i, 2) = fm;
    Results(i, 3) = Runtime;
    Results(i, 4) = Sensitivity;
    Results(i, 5) = Precision;
end

FileName = {imagefiles.name}';
Accurcy =  Results(:, 1);
F1 = Results(:, 2);
Runtime = Results(:, 3);
Sensitivity =  Results(:, 4);
Precision = Results(:, 5);

table(Accurcy,F1,Runtime,Sensitivity,Precision,'RowNames',FileName)
T = table(FileName, Accurcy,F1,Runtime,Sensitivity,Precision);
writetable(T, 'Results\Results.txt')


