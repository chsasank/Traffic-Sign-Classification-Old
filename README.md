Traffic-Sign-Classification
===========================
These are MATLAB codes for traffic sign classification. 
Database used is German Traffic Sign Database, available for download here: http://benchmark.ini.rub.de/?section=gtsrb&subsection=dataset

Some Sample Images:
------------------
Images from this database are very life-like and are challenging to classify. They are of different sizes and differently illuminated etc.

![](/Report/b.png)
![](/Report/c.png)
![](/Report/d.png)
![](/Report/e.png)
![](/Report/a.png)

We used:
-------
1. Linear Discriminant Analysis

2. Fisher's Linear Discriminant/Fisherfaces

3. Random Forests (in python)

algorithms to classify 

1. Raw intensity values from Images

2. Histogram of Oriented Gradients descriptors

To get these codes working, point to the correct directory containing dataset in readHOG.m, readTestHOG.m, readImages.m, readTestImages.m files

A detailed report containing results is availabe in **report** folder. References are also available in it.

#Note on Random Forests Implementation: 
We tried to implement our own randomforests class in python. 
As of the moment, it's not working and has to be debugged.
Instead use **RF_builtin.py** to classify using scikit-learn's randomforest classifier class.
As before, edit the file to point to the folder containing dataset.
