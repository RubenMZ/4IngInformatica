FLAGS = commands.hpp imc/PerceptronMulticapa.h
OBJECTS = practica2.o commands.o PerceptronMulticapa.o

all: practica clean

practica: $(OBJECTS)
	g++ $(OBJECTS) -g -Wall -o3 -o prueba

practica1.o: practica2.cpp $(FLAGS)
	g++ -c practica2.cpp

commands.o: $(FLAGS) commands.cpp
	g++ -c commands.cpp

PerceptronMulticapa.o: imc/PerceptronMulticapa.cpp $(FLAGS)
	g++ -c imc/PerceptronMulticapa.cpp

clean:
	rm -f *.o