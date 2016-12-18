#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 28 12:37:04 2016

@author: pagutierrez
"""

"""
TODO: Incluir todos los import necesarios
"""

import pandas as pd
import numpy as np
import random
from sklearn.cluster import KMeans
from scipy.spatial import distance
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import mean_squared_error

from time import time #importamos la función time para capturar tiempos
from sklearn.metrics import confusion_matrix




def entrenar_rbf(fichero_train, fichero_test, num_rbf, clasificacion, eta, l2):
    """ Función principal
        Recibe los siguientes parámetros:
            - fichero_train: nombre del fichero de entrenamiento.
            - fichero_test: nombre del fichero de test.
            - num_rbf: número de neuronas de tipo RBF.
            - clasificacion: True si el problema es de clasificacion.
            - eta: valor del parámetro de regularización para la Regresión 
              Logística.
            - l2: True si queremos utilizar L2 para la Regresión Logística. 
              False si queremos usar L1.
        Devuelve:
            - train_mse: Error de tipo Mean Squared Error en entrenamiento. 
              En el caso de clasificación, calcularemos el MSE de las 
              probabilidades predichas frente a las objetivo.
            - test_mse: Error de tipo Mean Squared Error en test. 
              En el caso de clasificación, calcularemos el MSE de las 
              probabilidades predichas frente a las objetivo.
            - train_ccr: Error de clasificación en entrenamiento. 
              En el caso de regresión, devolvemos un cero.
            - test_ccr: Error de clasificación en test. 
              En el caso de regresión, devolvemos un cero.
    """
    train_inputs, train_outputs, test_inputs, test_outputs = lectura_datos(fichero_train, 
                                                                           fichero_test)

    kmedias, distancias, centros = clustering(clasificacion, train_inputs, 
                                              train_outputs, num_rbf)
    
    radios = calcular_radios(centros, num_rbf)
    
    matriz_r = calcular_matriz_r(distancias, radios)

    if not clasificacion:
        coeficientes = invertir_matriz_regresion(matriz_r, train_outputs)
    else:
        if eta==0.0:
            eta=10e-15
        logreg = logreg_clasificacion(matriz_r, train_outputs, eta, l2)

    """
    TODO: Calcular las distancias de los centroides a los patrones de test
          y la matriz R de test
    """

    
    distancias_test = kmedias.transform(test_inputs)
    
    matriz_test = calcular_matriz_r(distancias_test, radios)

    if not clasificacion:
        """
        TODO: Obtener las predicciones de entrenamiento y de test y calcular
              el MSE
        """
        obtenido_train= np.dot(matriz_r, coeficientes)       
        obtenido_test  = np.dot(matriz_test, coeficientes)

        train_mse = mean_squared_error(obtenido_train, train_outputs)
        test_mse  = mean_squared_error(obtenido_test, test_outputs)
        train_ccr = 0.0
        test_ccr = 0.0
    else:
        """
        TODO: Obtener las predicciones de entrenamiento y de test y calcular
              el CCR. Calcular también el MSE, comparando las probabilidades 
              obtenidas y las probabilidades objetivo
        """
        
        prediccion_train = logreg.predict(matriz_r)
        prediccion_test = logreg.predict(matriz_test)
        
        cnf_matrix = confusion_matrix(test_outputs, prediccion_test)

        print cnf_matrix
        
        print logreg.coef_
        print "Numero clases ", logreg.coef_.shape[0]
        print "Numero nodos ocultos ", logreg.coef_.shape[1]

        train_mse = mean_squared_error(prediccion_train, train_outputs)
        test_mse  = mean_squared_error(prediccion_test, test_outputs)        
        
        train_ccr = logreg.score(matriz_r, train_outputs)*100
        test_ccr = logreg.score(matriz_test, test_outputs)*100
        

    return train_mse, test_mse, train_ccr, test_ccr
    
def lectura_datos(fichero_train, fichero_test):
    """ Realiza la lectura de datos.
        Recibe los siguientes parámetros:
            - fichero_train: nombre del fichero de entrenamiento.
            - fichero_test: nombre del fichero de test.
        Devuelve:
            - train_inputs: matriz con las variables de entrada de 
              entrenamiento.
            - train_outputs: matriz con las variables de salida de 
              entrenamiento.
            - test_inputs: matriz con las variables de entrada de 
              test.
            - test_outputs: matriz con las variables de salida de 
              test.
    """

    """
    TODO: Completar el código de la función
    """
    file = pd.read_csv(fichero_train, header=None)
    file2 = pd.read_csv(fichero_test, header=None)
    
    train_inputs = file.values[:, 0:-1]
    train_outputs = file.values[:, -1:]
    
    test_inputs = file2.values[:, 0:-1]
    test_outputs = file2.values[:, -1:]

    return train_inputs, train_outputs, test_inputs, test_outputs

def inicializar_centroides_clas(train_inputs, train_outputs, num_rbf):
    """ Inicializa los centroides para el caso de clasificación.
        Debe elegir, aprox., num_rbf/num_clases patrones por cada clase.
        Recibe los siguientes parámetros:
            - train_inputs: matriz con las variables de entrada de 
              entrenamiento.
            - train_outputs: matriz con las variables de salida de 
              entrenamiento.
            - num_rbf: número de neuronas de tipo RBF.
        Devuelve:
            - centroides: matriz con todos los centroides iniciales
                          (num_rbf x num_entradas).
    """
    
    """
    TODO: Completar el código de la función
    """        
    num_patrones = train_outputs.shape[0]
    num_entradas = train_inputs.shape[1]

    # Clasificación de patrones por clase
    clases = []
    num_clases = len(np.unique(train_outputs[:,0]))
        
    centroides = np.zeros(shape=(num_rbf,num_entradas))
    for i in range(num_rbf):
        mod = i%num_clases;
        while True:
            index = random.randint(0, num_patrones-1)
            clase = int(train_outputs[index,0])
            if clase == mod:
                break
            
        centroides[i]= train_inputs[index]

    return centroides

def clustering(clasificacion, train_inputs, train_outputs, num_rbf):
    """ Realiza el proceso de clustering. En el caso de la clasificación, se
        deben escoger los centroides usando inicializar_centroides_clas()
        En el caso de la regresión, se escogen aleatoriamente.
        Recibe los siguientes parámetros:
            - clasificacion: True si el problema es de clasificacion.
            - train_inputs: matriz con las variables de entrada de 
              entrenamiento.
            - train_outputs: matriz con las variables de salida de 
              entrenamiento.
            - num_rbf: número de neuronas de tipo RBF.
        Devuelve:
            - kmedias: objeto de tipo sklearn.cluster.KMeans ya entrenado.
            - distancias: matriz (num_patrones x num_rbf) con la distancia 
              desde cada patrón hasta cada rbf.
            - centros: matriz (num_rbf x num_entradas) con los centroides 
              obtenidos tras el proceso de clustering.
    """

    """
    TODO: Completar el código de la función
    """

    if clasificacion:
        centroides =  inicializar_centroides_clas(train_inputs, train_outputs, num_rbf)
        kmedias = KMeans(n_clusters=num_rbf, init=centroides, n_init=1, max_iter=500)
    else:
        #centroides = np.array(sample(train_inputs, num_rbf))
        kmedias = KMeans(n_clusters=num_rbf, init='random', n_init=1, max_iter=500)
        
    kmedias.fit(train_inputs,train_outputs)
    #kmeans = KMeans(n_clusters=num_rbf, init=centroides, max_iter=500).fit(train_inputs,train_outputs)
    centros = kmedias.cluster_centers_

    distancias = np.zeros(shape=(train_inputs.shape[0],num_rbf))
    for i in range(distancias.shape[0]):
        for j in range(distancias.shape[1]):
            distancias[i][j]= distance.euclidean(train_inputs[i,:], centros[j,:])

    return kmedias, distancias, centros

def calcular_radios(centros, num_rbf):
    """ Calcula el valor de los radios tras el clustering.
        Recibe los siguientes parámetros:
            - centros: conjunto de centroides.
            - num_rbf: número de neuronas de tipo RBF.
        Devuelve:
            - radios: vector (num_rbf) con el radio de cada RBF.
    """

    """
    TODO: Completar el código de la función
    """
    radios = np.zeros(num_rbf)
    for i in range(num_rbf):
        aux=0
        for j in range(num_rbf):
            aux += distance.euclidean(centros[i,:], centros[j, :])
            
        radios[i]= (1.0/(2.0*(num_rbf-1.0))) * aux
        
        
    return radios

def calcular_matriz_r(distancias, radios):
    """ Devuelve el valor de activación de cada neurona para cada patrón 
        (matriz R en la presentación)
        Recibe los siguientes parámetros:
            - distancias: matriz (num_patrones x num_rbf) con la distancia 
              desde cada patrón hasta cada rbf.
            - radios: array (num_rbf) con el radio de cada RBF.
        Devuelve:
            - matriz_r: matriz (num_patrones x (num_rbf+1)) con el valor de 
              activación (out) de cada RBF para cada patrón. Además, añadimos
              al final, en la última columna, un vector con todos los 
              valores a 1, que actuará como sesgo.
    """

    """
    TODO: Completar el código de la función
    """
    matriz_r = np.zeros(shape=(distancias.shape[0], distancias.shape[1]+1))
    
    dist = np.square(distancias)
    rad = np.square(radios)
    
    aux = np.exp(-dist/(2.0*rad))

    matriz_r[:, :-1]=aux
    matriz_r[:, -1:]=1.0

    return matriz_r

def invertir_matriz_regresion(matriz_r, train_outputs):
    """ Devuelve el vector de coeficientes obtenidos para el caso de la 
        regresión (matriz beta en las diapositivas)
        Recibe los siguientes parámetros:
            - matriz_r: matriz (num_patrones x (num_rbf+1)) con el valor de 
              activación (out) de cada RBF para cada patrón. Además, añadimos
              al final, en la última columna, un vector con todos los 
              valores a 1, que actuará como sesgo.
            - train_outputs: matriz con las variables de salida de 
              entrenamiento.
        Devuelve:
            - coeficientes: vector (num_rbf+1) con el valor del sesgo y del 
              coeficiente de salida para cada rbf.
    """

    """
    TODO: Completar el código de la función
    """
    #Realliza la pseudoinversa de Moore-Penrose
    pseudo = np.linalg.pinv(matriz_r)
    #Realiza el productor matricial de la pseudo y las salidas deseadas
    coeficientes = np.dot(pseudo, train_outputs)
            
    return coeficientes

def logreg_clasificacion(matriz_r, train_outputs, eta, l2):
    """ Devuelve el objeto de tipo regresión logística obtenido a partir de la
        matriz R.
        Recibe los siguientes parámetros:
            - matriz_r: matriz (num_patrones x (num_rbf+1)) con el valor de 
              activación (out) de cada RBF para cada patrón. Además, añadimos
              al final, en la última columna, un vector con todos los 
              valores a 1, que actuará como sesgo.
            - train_outputs: matriz con las variables de salida de 
              entrenamiento.
            - eta: valor del parámetro de regularización para la Regresión 
              Logística.
            - l2: True si queremos utilizar L2 para la Regresión Logística. 
              False si queremos usar L1.
        Devuelve:
            - logreg: objeto de tipo sklearn.linear_model.LogisticRegression ya
              entrenado.
    """

    """
    TODO: Completar el código de la función
    """

    if l2:
        logreg = LogisticRegression(penalty='l2', C=1.0/eta, solver='liblinear', fit_intercept=False).fit(matriz_r, train_outputs)
    else:
        logreg = LogisticRegression(penalty='l1', C=1.0/eta, solver='liblinear', fit_intercept=False).fit(matriz_r, train_outputs)
        
    return logreg

if __name__ == "__main__":
    
    tiempo_inicial = time() 
    
    train_mses = np.empty(5)
    train_ccrs = np.empty(5)
    test_mses = np.empty(5)
    test_ccrs = np.empty(5)
    
    for s in range(10,60,10):
        print "-----------"
        print "Semilla: %d" % s
        print "-----------"
        
        np.random.seed(s)
        
        train_mses[s/10-1], test_mses[s/10-1], train_ccrs[s/10-1], test_ccrs[s/10-1] = \
            entrenar_rbf(fichero_train='./basesDatos/csv/train_cpu.csv', 
                         fichero_test='./basesDatos/csv/test_cpu.csv', num_rbf=55, clasificacion=False, eta=0.0001, l2=False)
        print "MSE de entrenamiento: %f" % train_mses[s/10-1]
        print "MSE de test: %f" % test_mses[s/10-1]
        print "CCR de entrenamiento: %.2f%%" % train_ccrs[s/10-1]
        print "CCR de test: %.2f%%" % test_ccrs[s/10-1]
        
    
    mse_train_media=np.mean(train_mses)
    mse_test_media=np.mean(test_mses)
    ccr_train_media=np.mean(train_ccrs)
    ccr_test_media=np.mean(test_ccrs)
    
    mse_train_std=np.std(train_mses)
    mse_test_std=np.std(test_mses)
    ccr_train_std=np.std(train_ccrs)
    ccr_test_std=np.std(test_ccrs)
    
    print "---------------------------"
    print "INFORME FINAL"
    print "---------------------------"
    print "Error de entrenamiento (Media +- DT): %f +- %f " %(mse_train_media, mse_train_std)
    print "Error de test (Media +- DT): %f +- %f " %(mse_test_media, mse_test_std)
    print "CCR de entrenamiento (Media +- DT): %.2f%% +- %f%% " %(ccr_train_media, ccr_train_std)
    print "CCR de test (Media +- DT): %.2f%% +- %f%% " %(ccr_test_media, ccr_test_std)
    
    tiempo_final = time() 
 
    tiempo_ejecucion = tiempo_final - tiempo_inicial
 
    print 'El tiempo de ejecucion fue:',tiempo_ejecucion #En segundos
    
    
    
    
    """
    TODO: Imprimir la media y la desviación típica del MSE y del CCR
    """
