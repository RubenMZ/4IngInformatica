#include "commands.hpp"

 void mostrarUso (const char * progname)
{
  std::cout << std::endl;
  std::cout << "Este programa representa perceptron multicapa: " << std::endl;
  std::cout << "Uso: " << progname << " -t fileTrain.txt [-T fileTest.txt] [-i iterations]..." << std::endl;
  std::cout << "Donde: " << std::endl;
  std::cout << "-t <arg>\t\tFichero de entrenamiento." << std::endl;
  std::cout << "-T <arg>\t\tFichero de test." << std::endl;
  std::cout << "-i <arg>\t\tNumero de iteraciones en bucle externo" << std::endl;
  std::cout << "-l <arg>\t\tNumero de capas ocultas" << std::endl;
  std::cout << "-h <arg>\t\tNumero de neuronas en cada capa" << std::endl;
  std::cout << "-e <arg>\t\tValor del parametro eta" << std::endl;
  std::cout << "-m <arg>\t\tValor del parametro mu" << std::endl;
  std::cout << "-b\t\tSesgo de las neuronas" << std::endl;
  std::cout << "-o\t\tEspecifica version online" << std::endl;
  std::cout << "-f <arg>\t\tEspecifica funcion <0> MSE o <1> entropia cruzada para el error" << std::endl;
  std::cout << "-s\t\tIndica si se utiliza softmax, por defecto sigmoide" << std::endl;
}

int parseCLI (int argc, char* const* argv, CLIParams& params) 
{

  int opcion;
  while ((opcion = getopt (argc, argv, "t:T:i:l:h:e:m:bof:s")) != -1)
  {
    switch (opcion)
    {
      case 't':
        params.train=optarg;
        params.trainFlag=true;
        break;

      case 'T':
        params.test=optarg;
        params.testFlag=true;
        break;

      case 'i':
        params.iterations=atoi(optarg);
        break;

      case 'l':
        params.layers=atoi(optarg);
        break;

      case 'h':
        params.neurons=atoi(optarg);
        break;
    
      case 'e':
        params.eta=atof(optarg);
        break;

      case 'm':
        params.mu=atof(optarg);
        break;

      case 'b':
        params.slant=true;
        break;

        case 'o':
        params.online=true;
        break;

        case 'f':
        params.function=atoi(optarg);
        break;

         case 's':
        params.softmax=true;
        break;

      case '?': // en caso de error getopt devuelve el caracter ?
    
    if (isprint (optopt))
      std::cerr << "Error: Opción desconocida \'" << optopt
        << "\'" << std::endl;
    else
      std::cerr << "Error: Caracter de opcion desconocido \'x" << std::hex << optopt
        << "\'" << std::endl;
    mostrarUso(argv[0]);    
    exit (EXIT_FAILURE);
    
    // en cualquier otro caso lo consideramos error grave y salimos
      default:
    std::cerr << "Error: línea de comandos errónea." << std::endl;
    mostrarUso(argv[0]);
    exit(EXIT_FAILURE); 
    }  // case
    
  }// while
  return optind;
}