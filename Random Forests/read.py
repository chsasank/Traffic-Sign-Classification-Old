import os
import numpy as np
# function for reading the images
# arguments: path to the traffic sign data, for example './GTSRB/Training'
# returns: list of images, list of corresponding labels 
def readTrafficSigns(rootpath):
    '''Reads HOG traffic sign data for German Traffic Sign Recognition Benchmark.

    Arguments: path to the traffic sign data, for example './GTSRB/Training'
    Returns:   list of images, list of corresponding labels'''
    images = []
    labels = [] # corresponding labels
    i = 0
    # loop over all 43 classes
    for c in range(43):####
        currentDir = rootpath + '/' + format(c, '05d')   # subdirectory for class
        print("Loading files for sign ",c, currentDir)
        for file in os.listdir(currentDir):
            f = open(currentDir+'/'+file,"r")
            contents = f.read()
            f.close()
            hog = [float(x) for x in contents.split("\n")]
            images.append(hog)
            labels.append(c)
            i = i+1
            
         
            
    return np.array(images), np.array(labels) #remove first row



def readTestSigns(rootpath,resultsFile):
    images = []
    labels = [] 
    currentDir = rootpath
    for file in os.listdir(currentDir):
        f = open(currentDir+'/'+file,"r")
        contents = f.read()
        f.close()
        hog = [float(x) for x in contents.split("\n")]
        images.append(hog)
    

    M = np.genfromtxt(resultsFile, delimiter=',')
    labels = M[:,-1] #labels are in last coloumn
    
    return np.array(images),labels
