# -*- coding: utf-8 -*-
"""
Created on Mon Nov 23 10:14:36 2015

@author: pedroa
"""

import arff, numpy as np
import matplotlib.pyplot as plt

from sklearn.datasets import load_svmlight_file
from sklearn import svm
from sklearn.grid_search import GridSearchCV
from time import time


#Almacenamos el tiempo inicial
tiempo_inicial = time()

#Cargar dataset
dataset = arff.load(open('./BasesDatos/arff/train_digits.arff', 'rb'))
data = np.array(dataset['data'])
dataset_test = arff.load(open('./BasesDatos/arff/test_digits.arff', 'rb'))
data_test = np.array(dataset_test['data'])

#Parsear los datos leidos
X_sparse_train = data[:,0:-1]
y_train = data[:,-1]

X_sparse_test = data_test[:,0:-1]
y_test = data_test[:,-1]

#Eliminar valores basura y convertir los char a float
X_train = np.char.encode(X_sparse_train , encoding="ascii", errors="ignore") 
y_train = np.char.encode(y_train, encoding="ascii", errors="ignore")

X_train = np.float32(X_train)
y_train = np.float32(y_train)


X_test = np.char.encode(X_sparse_test , encoding="ascii", errors="ignore") 
y_test = np.char.encode(y_test, encoding="ascii", errors="ignore")

X_test = np.float32(X_test)
y_test = np.float32(y_test)


Cs = np.logspace(-5, 7, num=10, base=2)
Gs = np.logspace(-5, 7, num=10, base=2)
# Entrenar el modelo SVM
svm_model = svm.SVC()
#Estima los valores de C y gamma
svm_model = GridSearchCV(estimator=svm_model, param_grid=dict(C=Cs,gamma=Gs),n_jobs=-1,cv=10)
svm_model.fit(X_train,y_train)


print "CCR Train  %f " %(svm_model.score(X_train, y_train)*100)
print "CCR Test %f " %(svm_model.score(X_test, y_test)*100)
print svm_model.best_params_

#Almacenamos el tiempo final
tiempo_final = time()
#Almacenamos el tiempo total (final-inicial)
tiempo_ejecucion = tiempo_final - tiempo_inicial

print "Tiempo total %f segundos " %(tiempo_ejecucion)
