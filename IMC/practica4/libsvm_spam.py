# -*- coding: utf-8 -*-
"""
Created on Mon Nov 23 10:14:36 2015

@author: pedroa
"""

import numpy as np
import matplotlib.pyplot as plt

from sklearn.datasets import load_svmlight_file
from sklearn import svm
from sklearn import cross_validation
from sklearn.cross_validation import StratifiedShuffleSplit
from time import time
from sklearn.metrics import confusion_matrix


#Almacenamos el tiempo inicial
tiempo_inicial = time()


# Cargar el dataset
X_sparse_train, y_train = load_svmlight_file("./BasesDatos/libsvm/train_spam.libsvm")
X_sparse_test, y_test = load_svmlight_file("./BasesDatos/libsvm/test_spam.libsvm")

# Convertirlo a formato denso
X_train = np.array(X_sparse_train.todense())
X_test = np.array(X_sparse_test.todense())


# Entrenar el modelo SVM
# Entrenar con el conjunto train
svm_model = svm.SVC(kernel='linear',C=10e-2,gamma=100)
svm_model.fit(X_train, y_train)

prediction = svm_model.predict(X_test)
matrix = confusion_matrix(y_test , prediction)

index = np.where(prediction != y_test)
print index

print "Matriz de confusion "
print matrix

print "CCR Train  %f " %(svm_model.score(X_train, y_train)*100)
print "CCR Test %f " %(svm_model.score(X_test, y_test)*100)
#print svm_model.best_params_

#Almacenamos el tiempo final
tiempo_final = time()
#Almacenamos el tiempo total (final-inicial)
tiempo_ejecucion = tiempo_final - tiempo_inicial

print "Tiempo total %f segundos " %(tiempo_ejecucion)
