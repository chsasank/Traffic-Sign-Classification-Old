%% Read all HOG data
hog = zeros(39209,2916);
labels = zeros(39209,1);
i = 1;
sBasePath = '/users/sasank/test/dip/GTSRB/Training/HOG/HOG_03'; 
h = waitbar(i/12630,'Loading Training Dataset');
for nNumFolder = 0:42
    sFolder = num2str(nNumFolder, '%05d');
    sPath = [sBasePath, '/', sFolder, '/'];
    dd = dir([sPath, '*.txt']);
    files = {dd.name};
    for file = files
        fileName = strcat(sPath,file);
        fileId = fopen(fileName{:},'r');
        hog2(i,:) = fscanf(fileId,'%f');
        labels(i) = nNumFolder+1;
        fclose(fileId);
        i = i+1;
        waitbar(i/39209,h,['numFolder = ',int2str(nNumFolder)]);
    end
end
close(h)
