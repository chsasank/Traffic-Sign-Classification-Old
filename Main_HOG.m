%% Used HOG data
%% Build LDA object
clear
%load data.mat
readHOG
readTestHOG
K = 43;
l = LDA(hog,labels,K);

%% Classify
y_c = classifyLDA(l,hogTest);
error = labelsTest(y_c ~= labelsTest);
misClassificationRate = size(error,1)*100/size(labelsTest,1);
classificationRate = 100-misClassificationRate

%% FLD
f = FLD(hog,labels,K,K-1);

testProjection = hogTest*f.W;
closestNeighb = dsearchn(f.dataBase,testProjection);
y_c = labels(closestNeighb);
error = labelsTest(y_c ~= labelsTest);
misClassificationRate = size(error,1)*100/size(labelsTest,1);
classificationRate = 100-misClassificationRate
