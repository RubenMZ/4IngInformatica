//============================================================================
// Introducción a los Modelos Computacionales
// Name        : practica1.cpp
// Author      : Pedro A. Gutiérrez
// Version     :
// Copyright   : Universidad de Córdoba
//============================================================================

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <iostream>
#include <ctime>    // Para cojer la hora time()
#include <cstdlib>  // Para establecer la semilla srand() y generar números aleatorios rand()
#include <string.h>
#include <math.h>
#include "imc/PerceptronMulticapa.h"
#include "commands.hpp"

using namespace imc;
using namespace std;


int main(int argc, char **argv) {

    // Procesar la línea de comandos

    // Leer iteraciones, capas y neuronas desde la línea de comandos

    // Leer sesgo, eta y mu de la línea desde comandos

    // Leer fichero de train y de test desde la línea de comandos

    CLIParams params;
    double mediaErrorTrain=0.0, mediaErrorTest=0.0;
    double mediaCCRTrain = 0.0, mediaCCRTest=0.0;
    double desviacionTipicaErrorTrain=0.0, desviacionTipicaErrorTest=0.0;
    double desviacionTipicaCCRTrain=0.0, desviacionTipicaCCRTest=0.0;
    int * topologia;

    parseCLI(argc, argv, params);


    if(params.trainFlag==false){
        cout << "Uso: " << argv[0] << " -t fileTrain.txt [-T fileTest.txt] [-i iterations]..." << endl;
        exit(EXIT_FAILURE);
    }else{
        if(params.testFlag==false){
            params.test=params.train;
            params.testFlag=true;
        }
    }

    if (params.iterations>1000 || params.iterations<1)
    {
        cout << "El numero de iteraciones tiene que ser [1-1000]" << endl;
        exit(EXIT_FAILURE);
    }

    if (params.function!=0 && params.function!=1)
    {
        cout << "La funcion para el error tiene que ser <0> MSE o <1> entropia cruzada" << endl;
        exit(EXIT_FAILURE);
    }

    PerceptronMulticapa mlp;

    std::cout<<"Leyendo fichero train... "<<std::endl;
    Datos * pDatosTrain = mlp.leerDatos(params.train);

    mlp.nNumPatronesTrain = pDatosTrain->nNumPatrones;


    std::cout<<"Leyendo fichero test... "<<std::endl;
    Datos * pDatosTest = mlp.leerDatos(params.test);


    // Inicializar el vector "topología"
    // (número de neuronas por cada capa, incluyendo la de entrada
    //  y la de salida)
    // ...
    topologia = (int * )malloc(sizeof(int)*(params.layers+2));

    topologia[0]=pDatosTrain->nNumEntradas;
    topologia[params.layers+1]= pDatosTrain->nNumSalidas;
    for (int i = 1; i < params.layers+1; ++i)
    {
        topologia[i]=params.neurons;
    }

    // Sesgo
    mlp.bSesgo = params.slant;

    // Eta
    if (params.online)
    {
        mlp.dEta= params.eta/mlp.nNumPatronesTrain;
    }else{
        mlp.dEta = params.eta/mlp.nNumPatronesTrain;
    }

    // Mu
    mlp.dMu = params.mu;

    // Inicialización propiamente dicha
    mlp.inicializar(params.layers+2,topologia);
    
    // Semilla de los números aleatorios
    int semillas[] = {10,20,30,40,50};
    double *erroresTest = new double[5];
    double *erroresTrain = new double[5];
    double *ccrsTest = new double[5];
    double *ccrsTrain = new double[5];
    for(int i=0; i<5; i++){
        srand48(semillas[i]);
    	cout << "**********" << endl;
    	cout << "SEMILLA " << semillas[i] << endl;
    	cout << "**********" << endl;
        mlp.ejecutarAlgoritmo(pDatosTrain,pDatosTest,params.iterations,&(erroresTrain[i]),&(erroresTest[i]), &(ccrsTrain[i]),&(ccrsTest[i]),params.function, params.online, params.softmax);
		cout << "Finalizamos => Error de test final: " << erroresTest[i] << endl;
        cout << "Finalizamos => CCR de test final: " << ccrsTest[i] << endl;
    }

    cout << "HEMOS TERMINADO TODAS LAS SEMILLAS" << endl;

    // Calcular media y desviación típica de los errores de Train y de Test
    // ....
    for (int i = 0; i < 5; ++i)
    {
        mediaErrorTrain += erroresTrain[i];
        mediaErrorTest += erroresTest[i];

        mediaCCRTrain += ccrsTrain[i];
        mediaCCRTest += ccrsTest[i];
    }
    
    mediaCCRTrain = mediaCCRTrain/5;
    mediaCCRTest = mediaCCRTest/5;

    double auxTest = 0.0, auxTrain=0.0;
    double auxCCRTest = 0.0, auxCCRTrain=0.0;

    for(int i=0; i<5; i++){
        auxTest += pow(erroresTest[i] - mediaErrorTest,2);
        auxTrain += pow(erroresTrain[i] - mediaErrorTrain, 2);

        auxCCRTest += pow(ccrsTest[i] - mediaCCRTest,2);
        auxCCRTrain += pow(ccrsTrain[i] - mediaCCRTrain, 2);
    }

    desviacionTipicaErrorTrain = sqrt((0.25)*auxTrain);
    desviacionTipicaErrorTest = sqrt((0.25)* auxTest);

    desviacionTipicaCCRTrain = sqrt((0.25)*auxCCRTrain);
    desviacionTipicaCCRTest = sqrt((0.25)* auxCCRTest);

    cout << "INFORME FINAL" << endl;
    cout << "*************" << endl;
    cout << "Error de entrenamiento (Media +- DT): " << mediaErrorTrain << " +- " << desviacionTipicaErrorTrain << endl;
    cout << "Error de test (Media +- DT):          " << mediaErrorTest << " +- " << desviacionTipicaErrorTest << endl;
    cout << "CCR de entrenamiento (Media +- DT): " << mediaCCRTrain << " +- " << desviacionTipicaCCRTrain << endl;
    cout << "CCR de test (Media +- DT): " << mediaCCRTest << " +- " << desviacionTipicaCCRTest << endl;


    return EXIT_SUCCESS;
}

