#ifndef COMMANDS_HPP
#define COMMANDS_HPP

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <cstdlib>  // Para establecer la semilla srand() y generar números aleatorios rand()
#include <limits>
#include <math.h>
#include <unistd.h>


struct CLIParams{
	CLIParams()
		:iterations(1000),
    	layers(1),
    	neurons(5),
    	eta(0.1),
    	mu(0.9),
    	slant(false),
    	trainFlag(false),
    	testFlag(false),
    	train(NULL),
    	test(NULL),
    	online(false),
    	function(0),
    	softmax(false)
    	{}

		bool trainFlag;
		bool testFlag;
		char * train;
		char * test;	
		int iterations;
		int layers;
		int neurons;
		float eta;
		float mu;
		bool slant;

		bool online;
		int function;
		bool softmax;

};

void mostrarUso (const char * progname);
int parseCLI (int argc, char* const* argv, CLIParams& params);

#endif