from read import *
import numpy as np
import scipy.stats
import random
import math
import time
from cCost import costfn
from sklearn.ensemble import RandomForestClassifier
    
class TreeNode(object):
    """Node of tree.
    
    Attributes:
    right: right tree node (splitVariable > split)
    left: left tree node   (splitVariable <= split)
    splitVariable: index of splitting variable
    split: spliting condition
    predictionLeft: prediction value if splitVariable <= split
    predictionRight: prediction otherwise
    """
    def __init__(self):
        self.right = None
        self.left = None
        self.splitVariable = None
        self.split = None
        self.predictionLeft = None
        self.predictionRight = None
    
    @classmethod
    def printTree(cls,node):
        if node != None:
            print("x_",node.splitVariable,"<",node.split)
            cls.printTree(node.left)
            cls.printTree(node.right)
    @classmethod
    def depth(cls,node):
        if node == None:
            return 0
        else:
            return 1 + max(cls.depth(node.left),cls.depth(node.right))


class RandomTree(object):

    def __init__(self,X,y,verbose = False):
        self.X = X
        self.y = y
        self.randomTree = TreeNode()
        self.verbose = verbose
    
    def grow(self, minimumNodeSize, numCandidateVariables):
        """Fits a random decision tree. Committe of these will be our randomforest
        """
        entryTime = time.time()
        self.randomTree = self.__fitRandomDecisionTree(self.X, self.y, numCandidateVariables, minimumNodeSize,self.verbose)
        # print("Tree Fitted")
        # print("Tree depth =",TreeNode.depth(self.randomTree),"Time spent Training = ","%#5.2f"%(time.time()-entryTime) )
        
        
    def predict(self,value):
        """predicts using constructed decision tree
        """
        nextNode = self.randomTree
        while nextNode != None :
            splitVariable = nextNode.splitVariable
            if splitVariable == None:
                return nextNode.predictionLeft
            
            if value[splitVariable] <= nextNode.split :
                prediction = nextNode.predictionLeft
                nextNode = nextNode.left
            else:
                prediction = nextNode.predictionRight
                nextNode = nextNode.right
    
        return prediction
    

    @classmethod
    def __cost(cls,left,right,measure):
        """Calculates Gini or entropy cost measure for a given split
        """
        threshold = 0
        if left.size > threshold: 
            Pl = np.bincount(left,minlength = 43)
            if measure == 'Entropy':
                cost = scipy.stats.entropy(Pl,base = 2)   
            if measure == 'Gini':
                Pl = Pl/np.sum(Pl)
                cost = sum(Pl*(1-Pl))            
        else:
            cost = 1e10
            
        if right.size > threshold:
            Pr = np.bincount(right,minlength = 43)
            if measure == 'Entropy':
                cost += scipy.stats.entropy(Pr,base = 2)
            if measure == 'Gini':
                Pr = Pr/np.sum(Pr)
                cost += sum(Pr*(1-Pr))
        else:
            cost += 1e10

        return cost     #,predictionLeft,predictionRight
    

    @classmethod    
    def __fitRandomDecisionTree(cls,X,y, m, minimumNodeSize,verbose):
        if X.shape[0] != y.shape[0] : raise Exception("X and y are not compatible. Check sizes")
        
        if y.size < minimumNodeSize:
            #No more growing of tree. Make left and right to be 'None'    
            # print("Terminating growth at this node...")
            node = TreeNode()
            node.predictionLeft = np.argmax(np.bincount(y,minlength = 43))
            node.predictionRight = np.argmax(np.bincount(y,minlength = 43))
            return node
        
        numVariables = X.shape[1] #number of coloumns.
        candidateVariables = random.sample(range(numVariables),m)
        candidateSplits = [x/10 for x in range(10)]
        
        minCost = np.inf
        
        entryTime = time.time()
        
        for v in candidateVariables:
            for s in candidateSplits:
                currentCost = costfn(left,right)
                if (left.size < 10) or(right.size < 10): currentCost = 1e6
                # print('cython:',currentCost,'__cost(gini):',cls.__cost(left,right,'Gini'),'__cost(entropy)',cls.__cost(left,right,'Entropy'))
                if currentCost < minCost:
                    minCost = currentCost
                    splitVariable = v
                    split = s


        
        node = TreeNode()
        node.splitVariable = splitVariable
        node.split = split
        node.predictionLeft = np.argmax(np.bincount(y[X[:,splitVariable]<=split],minlength = 43))
        node.predictionRight = np.argmax(np.bincount(y[X[:,splitVariable]>split],minlength = 43))
        if verbose:
            print("x_",splitVariable,"<",split,"datasize-", y.size, "cost = ",costfn(y[X[:,splitVariable]<=split],y[X[:,splitVariable]>split]))

        if minCost <= 0.0001:
            #No more growing of tree. Make left and right to be 'None'    
            # print("Terminating growth at this node...")
            node.left = None
            node.right = None
        else:
            left = y[X[:,splitVariable]<=split]
            right = y[X[:,splitVariable]>split]
            
            if left.size < minimumNodeSize:
                #No more growing of tree. Make left node to be 'None'    
                leftnode = TreeNode()
                leftnode.predictionLeft = np.argmax(np.bincount(left,minlength = 43))
                leftnode.predictionRight = np.argmax(np.bincount(left,minlength = 43))
                node.left = leftnode
            else:
                node.left = cls.__fitRandomDecisionTree(X[X[:,splitVariable]<=split],left,m,minimumNodeSize,verbose)
            
            if right.size < minimumNodeSize:
                #No more growing of tree. Make left node to be 'None'    
                rightnode = TreeNode()
                rightnode.predictionLeft = np.argmax(np.bincount(left,minlength = 43))
                rightnode.predictionRight = np.argmax(np.bincount(left,minlength = 43))
                node.right = rightnode
            else:
                node.right = cls.__fitRandomDecisionTree(X[X[:,splitVariable]>split], right,m,minimumNodeSize,verbose)

        return node
        
        

class RandomForest(object):
    
    def __init__(self,X,y):
        """Initialize Random forest object
        X - training data where each row is a sample
        y - corresponding labels
        """
        self.forest = [] #should contain TreeNode objects as a list
        self.X = X
        self.y = y
        
    
    def train(self,bootStrapSize = 1000,numTrees = 50, minimumNodeSize = 1000, numCandidateVariables = None):
        if numCandidateVariables == None:
            numCandidateVariables = int(math.sqrt(self.y.size))
        
        ti = time.time()
        for i in range(numTrees):
            print("Training tree",i+1, "out of",numTrees)
            Xb,yb = self.__drawBootstrapSample(bootStrapSize)
            tree = RandomTree(Xb,yb)
            tree.grow(min1imumNodeSize, numCandidateVariables)
            self.forest.append(tree)
        
        print("Training Done in",(time.time()-ti)/60 ,"minutes.")
        
    def predict(self,value):
        comiteeResults = []
        for tree in self.forest:
            r = tree.predict(value)
            comiteeResults.append(r)

        # print( np.bincount(np.array(comiteeResults),minlength = 3))
        return np.argmax(np.bincount(np.array(comiteeResults),minlength = 43)) #return max vote of all rersults
        
            
    def __drawBootstrapSample(self,bootStrapSize):
        b = np.random.randint(self.y.size,size = bootStrapSize)
        Xb = X[b,:]
        yb = y[b]
        return Xb,yb
    

    

X,y = readTrafficSigns('/Users/Sasank/test/DIP/GTSRB/Training/HOG/HOG_01')

# X = np.random.randn(4000,1500)*10
# y = np.zeros(4000,int)
# y[X[:,2]<0] = 1
# y[X[:,11]<10] = 2
# y[X[:,100]>-1.2] = 3
# y[X[:,140]>2.2] = 4
# y[X[:,930]>6.4] = 5

print(X.shape,y.shape)
print(np.bincount(y))

# t = RandomForestClassifier(n_estimators=10,oob_score = True)
# t = t.fit(X, y)
# print(t.oob_score_)

# t = RandomTree(X,y,True)
# t.grow( minimumNodeSize = 100, numCandidateVariables = 1500)

# t = RandomForest(X,y)
# t.train(bootStrapSize = 1000,numTrees = 10, minimumNodeSize = 5, numCandidateVariables = 40)


# Xt,yt = readTrafficSigns('/Users/Sasank/test/DIP/GTSRB/Test/HOG/HOG_01')
errors = []

for i in range(y.size):
    if t.predict(X[i,:]) != y[i]: errors.append(y[i])

print("Errors = ",len(errors), "out of",y.size , "percent = ",len(errors)/y.size*100 )
print(np.bincount(np.array(errors,int),minlength = 43))