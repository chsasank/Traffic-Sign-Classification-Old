%% Uses Images instead of HOG
%% Train LDA 
load data.mat
m = mean(images);
K = 43;
l = LDA(images,labels,K);

%% Classify
y_c = classifyLDA(l,imagesTest);
error = labelsTest(y_c ~= labelsTest);
misClassificationRate = size(error,1)*100/size(labelsTest,1);
classificationRate = 100-misClassificationRate

%% FLD
% f = FLD(images-ones(size(images,1),1)*m,labels,K,K-1);
f = FLD(images,labels,K,K-1);


testProjection = imagesTest*f.W;
tic
closestNeighb = dsearchn(f.dataBase,testProjection);
toc
y_c = labels(closestNeighb);
error = labelsTest(y_c ~= labelsTest);
misClassificationRate = size(error,1)*100/size(labelsTest,1);
classificationRate = 100-misClassificationRate

