/*********************************************************************
 * File  : PerceptronMulticapa.cpp
 * Date  : 2016
 *********************************************************************/

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <cstdlib>  // Para establecer la semilla srand() y generar números aleatorios rand()
#include <limits>
#include <math.h>

#include "PerceptronMulticapa.h"

using namespace imc;
using namespace std;

// ------------------------------
// Obtener un número real aleatorio en el intervalo [Low,High]
double realAleatorio(double Low, double High)
{
	double f = drand48();
    return (Low + f * (High - Low));
}

// ------------------------------
// CONSTRUCTOR: Dar valor por defecto a todos los parámetros
PerceptronMulticapa::PerceptronMulticapa()
{
	nNumCapas=3;
	pCapas=NULL;
}

// Reservar memoria para las estructuras de datos
// nl tiene el numero de capas y npl es un vector que contiene el número de neuronas por cada una de las capas
// Rellenar vector Capa* pCapas
int PerceptronMulticapa::inicializar(int nl, int npl[]) {
	nNumCapas=nl;
	pCapas=(Capa*)malloc(sizeof(Capa)*nl);

	for (int i = 0; i < nNumCapas; ++i)//La capa 0 es la entrada
	{
		pCapas[i].pNeuronas=(Neurona *)malloc(npl[i]*sizeof(Neurona));
		pCapas[i].nNumNeuronas=npl[i];
		for (int j = 0; j < pCapas[i].nNumNeuronas; ++j)
		{
			pCapas[i].pNeuronas[j].x=1;
			pCapas[i].pNeuronas[j].dX=1;
			if(i!=0){
				int nEntradas = pCapas[i-1].nNumNeuronas;
				if(bSesgo)//El +1 es el sesgo
					nEntradas++;

				pCapas[i].pNeuronas[j].w=(double *)malloc(sizeof(double)*nEntradas);
				pCapas[i].pNeuronas[j].deltaW=(double *)malloc(sizeof(double)*nEntradas);
				pCapas[i].pNeuronas[j].ultimoDeltaW=(double *)malloc(sizeof(double)*nEntradas);
				pCapas[i].pNeuronas[j].wCopia=(double *)malloc(sizeof(double)*nEntradas);
				for (int k = 0; k < nEntradas; ++k)
				{
					pCapas[i].pNeuronas[j].w[k]=0.0;
					pCapas[i].pNeuronas[j].deltaW[k]=0.0;
					pCapas[i].pNeuronas[j].ultimoDeltaW[k]=0.0;
					pCapas[i].pNeuronas[j].wCopia[k]=0.0;
				}
			}else{
				pCapas[i].pNeuronas[j].w=NULL;
				pCapas[i].pNeuronas[j].deltaW=NULL;
				pCapas[i].pNeuronas[j].ultimoDeltaW=NULL;
				pCapas[i].pNeuronas[j].wCopia=NULL;
			}
			
		}
	}
	return 1;
}


// ------------------------------
// DESTRUCTOR: liberar memoria
PerceptronMulticapa::~PerceptronMulticapa() {
	liberarMemoria();
}


// ------------------------------
// Liberar memoria para las estructuras de datos
void PerceptronMulticapa::liberarMemoria() {
	for (int i = 0; i < nNumCapas; ++i)//La capa 0 es la entrada
	{
		for (int j = 0; j < pCapas[i].nNumNeuronas; ++j)
		{
			if(i!=0){
					free(pCapas[i].pNeuronas[j].w);
					free(pCapas[i].pNeuronas[j].deltaW);
					free(pCapas[i].pNeuronas[j].ultimoDeltaW);
					free(pCapas[i].pNeuronas[j].wCopia);
			}
		}
		free(pCapas[i].pNeuronas);
	}

	free(pCapas);
}

// ------------------------------
// Rellenar todos los pesos (w) aleatoriamente entre -1 y 1
void PerceptronMulticapa::pesosAleatorios() {

	for (int i = 1; i < nNumCapas; ++i)//La capa 0 es la entrada
	{
		for (int j = 0; j < pCapas[i].nNumNeuronas; ++j)
		{
				int nEntradas = pCapas[i-1].nNumNeuronas;
				if(bSesgo)
					nEntradas++;

				for (int k = 0; k < nEntradas; ++k)
				{	
					double x = realAleatorio(-1.0,1.0);
					pCapas[i].pNeuronas[j].w[k]=x;
					pCapas[i].pNeuronas[j].wCopia[k]=x;
				}	
		}
	}
}

// ------------------------------
// Alimentar las neuronas de entrada de la red con un patrón pasado como argumento
void PerceptronMulticapa::alimentarEntradas(double* input) {
	for (int i = 0; i < pCapas[0].nNumNeuronas; ++i)
	{
		pCapas[0].pNeuronas[i].x=input[i];
		pCapas[0].pNeuronas[i].dX=input[i];
	}
}

// ------------------------------
// Recoger los valores predichos por la red (out de la capa de salida) y almacenarlos en el vector pasado como argumento
void PerceptronMulticapa::recogerSalidas(double* output) {
	int x = pCapas[nNumCapas-1].nNumNeuronas;
	for (int i = 0; i < x; ++i)
	{
		output[i]= pCapas[nNumCapas-1].pNeuronas[i].x;
	}
}

// ------------------------------
// Hacer una copia de todos los pesos (copiar w en copiaW)
void PerceptronMulticapa::copiarPesos() {
	for (int i = 1; i < nNumCapas; ++i)//La capa 0 es la entrada
	{
		for (int j = 0; j < pCapas[i].nNumNeuronas; ++j)
		{
			int nEntradas = pCapas[i-1].nNumNeuronas;
			if(bSesgo)
					nEntradas++;
			for (int k = 0; k < nEntradas; ++k)
			{	
				double x = pCapas[i].pNeuronas[j].w[k];
				pCapas[i].pNeuronas[j].wCopia[k]=x;
			}	
		}
	}
}

// ------------------------------
// Restaurar una copia de todos los pesos (copiar copiaW en w)
void PerceptronMulticapa::restaurarPesos() {
	for (int i = 1; i < nNumCapas; ++i)//La capa 0 es la entrada
	{
		for (int j = 0; j < pCapas[i].nNumNeuronas; ++j)
		{
			int nEntradas = pCapas[i-1].nNumNeuronas;
			if(bSesgo)
					nEntradas++;
			for (int k = 0; k < nEntradas; ++k)
			{	
				double x = pCapas[i].pNeuronas[j].wCopia[k];
				pCapas[i].pNeuronas[j].w[k]=x;
			}	
		}
	}
}

// ------------------------------
// Calcular y propagar las salidas de las neuronas, desde la primera capa hasta la última
void PerceptronMulticapa::propagarEntradas() {
	for (int i = 1; i < nNumCapas; ++i)//La capa 0 es la entrada
	{
		for (int j = 0; j < pCapas[i].nNumNeuronas; ++j)
		{

			int nEntradas = pCapas[i-1].nNumNeuronas;
			double exponente = 0.0;
			if(bSesgo){
				nEntradas++;
				exponente+= pCapas[i].pNeuronas[j].w[0];
			}
			for (int k = 0; k < nEntradas; ++k)
			{	
				double weight;
				weight = pCapas[i].pNeuronas[j].w[k];
				double x = pCapas[i-1].pNeuronas[k].x;
				exponente += (weight*x);
			}
			pCapas[i].pNeuronas[j].x = 1/(1+exp(-exponente));	
		}
	}
}

// ------------------------------
// Calcular el error de salida (MSE) del out de la capa de salida con respecto a un vector objetivo y devolverlo
double PerceptronMulticapa::calcularErrorSalida(double* target) {
	double error = 0.0;
	for (int i = 0; i < pCapas[nNumCapas-1].nNumNeuronas; ++i)
	{
		error += pow( (pCapas[nNumCapas-1].pNeuronas[i].x - target[i]), 2);
	}
	return (error / pCapas[nNumCapas-1].nNumNeuronas);
}


// ------------------------------
// Retropropagar el error de salida con respecto a un vector pasado como argumento, desde la última capa hasta la primera
void PerceptronMulticapa::retropropagarError(double* objetivo) {
	for (int i = 0; i < pCapas[nNumCapas-1].nNumNeuronas; ++i)
	{
		double out = pCapas[nNumCapas-1].pNeuronas[i].x;
		pCapas[nNumCapas-1].pNeuronas[i].dX = - (objetivo[i] - out )*out*(1-out);
	}
	for (int i = (nNumCapas-2); i > 0; --i)//La capa 0 es la entrada
	{
		for (int j = 0; j < pCapas[i].nNumNeuronas; ++j)
		{
			int nEntradas = pCapas[i+1].nNumNeuronas;
			double sum = 0.0;
			for (int k = 0; k < nEntradas; ++k)
	      	{
	      			sum += pCapas[i+1].pNeuronas[k].w[j]*pCapas[i+1].pNeuronas[k].dX;
	      	}
			double out =  pCapas[i].pNeuronas[j].x;
			pCapas[i].pNeuronas[j].dX = sum*out*(1-out);
		}
	}
}

// ------------------------------
// Acumular los cambios producidos por un patrón en deltaW
void PerceptronMulticapa::acumularCambio() {
	for (int i = 1; i < nNumCapas; ++i)
	{
		for (int j = 0; j < pCapas[i].nNumNeuronas ; ++j)
		{
			int nEntradas = pCapas[i-1].nNumNeuronas;
			if(bSesgo)
				nEntradas++;
			for (int k = 0; k < nEntradas; ++k)
			{
				if(bSesgo && k==0)
					pCapas[i].pNeuronas[j].deltaW[k] += pCapas[i].pNeuronas[j].dX;
				else
					pCapas[i].pNeuronas[j].deltaW[k] += pCapas[i].pNeuronas[j].dX * pCapas[i-1].pNeuronas[k].x;
			}		
		}
	}
}

// ------------------------------
// Actualizar los pesos de la red, desde la primera capa hasta la última
void PerceptronMulticapa::ajustarPesos() {
	for (int i = 1; i < nNumCapas; ++i)
	{
		for (int j = 0; j < pCapas[i].nNumNeuronas ; ++j)
		{
			int nEntradas = pCapas[i-1].nNumNeuronas;
			if(bSesgo)
				nEntradas++;
			for (int k = 0; k < nEntradas; ++k)
			{
				if(bSesgo && k==0)
					pCapas[i].pNeuronas[j].w[k] += (-dEta)*pCapas[i].pNeuronas[j].deltaW[k] - dMu * (dEta*pCapas[i].pNeuronas[j].ultimoDeltaW[k]);
				else
					pCapas[i].pNeuronas[j].w[k] += (-dEta)*pCapas[i].pNeuronas[j].deltaW[k] - dMu * (dEta*pCapas[i].pNeuronas[j].ultimoDeltaW[k]);
			}
		}
	}
}

// ------------------------------
// Imprimir la red, es decir, todas las matrices de pesos
void PerceptronMulticapa::imprimirRed() {
	for(int i = 1 ; i < nNumCapas ; ++i){
		// Recorremos cada una de las neuronas de cada capa
		cout << "Capa " << i << endl;
		cout << "----"	<< endl;
		for(int j=0 ; j < pCapas[i].nNumNeuronas ; ++j){
			int nEntradas = pCapas[i-1].nNumNeuronas;
			if(bSesgo)
				nEntradas++;
			std::cout<< "Nodo "<<j<<" -> ";
			for(int k=0 ; k < nEntradas ; ++k){
				cout << " " << pCapas[i].pNeuronas[j].w[k];
			}
			std::cout << std::endl;
		}
	}
}

// ------------------------------
// Simular la red: propagar las entradas hacia delante, computar el error, retropropagar el error y ajustar los pesos
// entrada es el vector de entradas del patrón y objetivo es el vector de salidas deseadas del patrón
void PerceptronMulticapa::simularRedOnline(double* entrada, double* objetivo) {
	for (int i = 1; i < nNumCapas; ++i)
	{
		for (int j = 0; j < pCapas[i].nNumNeuronas ; ++j)
		{
			int nEntradas = pCapas[i-1].nNumNeuronas;
			for (int k = 0; k < nEntradas; ++k)
			{
				pCapas[i].pNeuronas[j].ultimoDeltaW[k] = pCapas[i].pNeuronas[j].deltaW[k];
				pCapas[i].pNeuronas[j].deltaW[k] = 0.0;
			}
		}
	}
	alimentarEntradas(entrada);
	propagarEntradas();
	retropropagarError(objetivo);
	acumularCambio();
	ajustarPesos();

}

// ------------------------------
// Leer una matriz de datos a partir de un nombre de fichero y devolverla
Datos* PerceptronMulticapa::leerDatos(const char *archivo) {
	fstream file;
	string line;
 
	Datos * data=(Datos*)malloc(sizeof(Datos));


	file.open(archivo, ios::in);

	getline(file, line, ' ');//Inputs
	data->nNumEntradas = atoi(line.c_str());

	getline(file, line, ' ');//Outputs
	data->nNumSalidas = atoi(line.c_str());
	getline(file, line, '\n');//Instances
	data->nNumPatrones = atoi(line.c_str());


	data->entradas = (double**)malloc(data->nNumPatrones * sizeof(double*));
	data->salidas = (double**)malloc(data->nNumPatrones * sizeof(double*));

	for (int i = 0; i < data->nNumPatrones; ++i)
	{
		(data->entradas)[i] = (double*)malloc(data->nNumEntradas * sizeof(double));
		(data->salidas)[i] = (double*)malloc(data->nNumSalidas * sizeof(double));
	}

	for (int i = 0; i < data->nNumPatrones; ++i)
	{
		for (int j = 0; j < (data->nNumEntradas) ; ++j)
		{
			getline(file, line, ' ');
			(data->entradas)[i][j]= atof(line.c_str());
		} 

		for (int j = 0; j < ((data->nNumSalidas)-1) ; ++j)
		{
			getline(file, line, ' ');
			(data->salidas)[i][j]= atof(line.c_str());
		}
		getline(file, line, '\n');
		(data->salidas)[i][(data->nNumSalidas)-1]= atof(line.c_str());
	}
	file.close();

	return data;
}

// ------------------------------
// Entrenar la red on-line para un determinado fichero de datos
void PerceptronMulticapa::entrenarOnline(Datos* pDatosTrain) {
	int i;
	for(i=0; i<pDatosTrain->nNumPatrones; i++)
		simularRedOnline(pDatosTrain->entradas[i], pDatosTrain->salidas[i]);
}

// ------------------------------
// Probar la red con un conjunto de datos y devolver el error MSE cometido
double PerceptronMulticapa::test(Datos* pDatosTest) {
	int i;
	double dAvgTestError = 0;
	for(i=0; i<pDatosTest->nNumPatrones; i++){
		// Cargamos las entradas y propagamos el valor
		alimentarEntradas(pDatosTest->entradas[i]);
		propagarEntradas();
		dAvgTestError += calcularErrorSalida(pDatosTest->salidas[i]);
	}
	dAvgTestError /= pDatosTest->nNumPatrones;
	return dAvgTestError;
}

// ------------------------------
// Ejecutar el algoritmo de entrenamiento durante un número de iteraciones, utilizando pDatosTrain
// Una vez terminado, probar como funciona la red en pDatosTest
// Tanto el error MSE de entrenamiento como el error MSE de test debe calcularse y almacenarse en errorTrain y errorTest
void PerceptronMulticapa::ejecutarAlgoritmoOnline(Datos * pDatosTrain, Datos * pDatosTest, int maxiter, double *errorTrain, double *errorTest)
{
	int countTrain = 0;
	// Inicialización de pesos
	pesosAleatorios();

	double minTrainError = 0;
	int numSinMejorar;
	double testError = 0.0;

	fstream salida;
	salida.open("errores.txt", ios::out);

	// Aprendizaje del algoritmo
	do {
		entrenarOnline(pDatosTrain);
		double trainError = test(pDatosTrain);
		testError = test(pDatosTest);
		// El 0.00001 es un valor de tolerancia, podría parametrizarse
		if(countTrain==0 || fabs(trainError - minTrainError) > 0.00001){
			minTrainError = trainError;
			copiarPesos();
			numSinMejorar = 0;
		}
		else{
			numSinMejorar++;
		}

		if(numSinMejorar==50){
			restaurarPesos();
			countTrain = maxiter;
		}

		countTrain++;

		cout << "Iteración " << countTrain << "\t Error de entrenamiento: " << trainError << " y test: "<< testError<< endl;
		salida<<countTrain<<" "<<trainError<<" "<<testError<<endl;
	} while ( countTrain<maxiter );

	cout << "PESOS DE LA RED" << endl;
	cout << "===============" << endl;
	imprimirRed();

	cout << "Salida Esperada Vs Salida Obtenida (test)" << endl;
	cout << "=========================================" << endl;
	for(int i=0; i<pDatosTest->nNumPatrones; i++){
		double* prediccion = new double[pDatosTest->nNumSalidas];

		// Cargamos las entradas y propagamos el valor
		alimentarEntradas(pDatosTest->entradas[i]);
		propagarEntradas();
		recogerSalidas(prediccion);
		for(int j=0; j<pDatosTest->nNumSalidas; j++)
			cout << pDatosTest->salidas[i][j] << " -- " << prediccion[j];
		cout << endl;
		delete[] prediccion;

	}

	testError = test(pDatosTest);
	*errorTest=testError;
	*errorTrain=minTrainError;

	salida.close();

}
