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


# Cargar el dataset
X_sparse, y = load_svmlight_file("./BasesDatos/libsvm/dataset3.libsvm")

# Convertirlo a formato denso
X = np.array(X_sparse.todense())

# Dividir patrones en 20% test y 80% train
sss = StratifiedShuffleSplit(y, test_size=0.2, train_size=0.8)

for train_index, test_index in sss:
	X_train, X_test = X[train_index], X[test_index]
	y_train, y_test = y[train_index], y[test_index]

# Entrenar el modelo SVM
# Entrenar con el conjunto train
svm_model = svm.SVC(kernel='rbf',C=0.2,gamma=200)
svm_model.fit(X_train, y_train)

# Representar los puntos
# Generalizar con conjunto test
plt.figure(1)
plt.clf()
plt.scatter(X_test[:, 0], X_test[:, 1], c=y_test, zorder=10, cmap=plt.cm.Paired)

# Representación gráfica de la SVM
# --------------------------------
plt.axis('tight')
# Extraer límites del conjunto train
x_min = X_train[:, 0].min()
x_max = X_train[:, 0].max()
y_min = X_train[:, 1].min()
y_max = X_train[:, 1].max()

# Crear un grid con todos los puntos y obtener el valor Z devuelto por la SVM
XX, YY = np.mgrid[x_min:x_max:500j, y_min:y_max:500j]
Z = svm_model.decision_function(np.c_[XX.ravel(), YY.ravel()])

# Hacer un plot a color con los resultados
Z = Z.reshape(XX.shape)
plt.pcolormesh(XX, YY, Z > 0, cmap=plt.cm.Paired)
plt.contour(XX, YY, Z, colors=['k', 'k', 'k'], linestyles=['--', '-', '--'],
               levels=[-.5, 0, .5])

plt.show()