from read import readTrafficSigns,readTestSigns
from sklearn.ensemble import RandomForestClassifier
import numpy as np

X,y = readTrafficSigns('/Users/Sasank/test/DIP/GTSRB/Training/HOG/HOG_01')
print(X.shape,y.shape)
print(np.bincount(y))

t = RandomForestClassifier(n_estimators=50,oob_score = True)
t = t.fit(X, y)

Xt,yt = readTestSigns('/Users/Sasank/test/DIP/GTSRB/Test/HOG/HOG_01/', 'GT-final_test.csv')


error = yt[yt != t.predict(Xt)]
print("Errors = ",len(error), "out of",yt.size , "classifaction percentage = ",100-len(error)/yt.size*100)
print(np.bincount(np.array(error,int),minlength = 43))