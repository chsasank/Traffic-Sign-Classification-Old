sPath = '/users/sasank/test/dip/GTSRB/Test/HOG/HOG_02/'; 
hogTest = zeros(12630,1568);
dd = dir([sPath, '*.txt']);
files = {dd.name};
i = 1;
h = waitbar(i/12630,'Loading Test Dataset');
for file = files
        fileName = strcat(sPath,file);
        fileId = fopen(fileName{:},'r');
        hogTest(i,:) = fscanf(fileId,'%f');
        fclose(fileId);
        i = i+1;
        waitbar(i/12630,h)
end
close(h)
M = csvread('GT-final_test.csv');
labelsTest = M(:,end)+1;